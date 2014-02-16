
package AI::MicroStructure::DrKnow;

use strict;
use warnings;
use AI::MicroStructure::ObjectSet;
use AnyEvent::Subprocess::Easy qw(qx_nonblock);
use File::Temp qw(tempdir);
use Log::Log4perl qw(:easy);
use File::Spec::Functions;
use File::Spec;
use File::Path;
use File::Copy;
use File::Find;
use File::Basename;
use IPC::Run qw(run);
use Cwd;

our $VERSION = "0.16";

sub new {

    my($class, %options) = @_;

    my $self = {
        Know                  => undef,
        tmpdir               => undef,
        Know_read_options     => '',
        Know_write_options    => '',
        Know_gnu_read_options => [],
        dirs                 => 0,
        max_cmd_line_args    => 512,
        ramdisk              => undef,
        %options,
    };

    bless $self, $class;

    $self->{Know} = bin_find("micro") unless defined $self->{Know};
    $self->{Know} = bin_find("pdftotext") unless defined $self->{Know};

    if( ! defined $self->{Know} ) {
        LOGDIE "Know not found in PATH, please specify location";
    }

    if(defined $self->{ramdisk}) {
        my $rc = $self->ramdisk_mount( %{ $self->{ramdisk} } );
        if(!$rc) {
            LOGDIE "Mounting ramdisk failed";
        }
        $self->{tmpdir} = $self->{ramdisk}->{tmpdir};
    } else {
        $self->{tmpdir} = tempdir($self->{tmpdir} ?
                                        (DIR => $self->{tmpdir}) : ());
    }

    $self->{Knowdir} = File::Spec->catfile($self->{tmpdir}, "Know");
    mkpath [$self->{Knowdir}], 0, 0755 or
        LOGDIE "Cannot mkpath $self->{Knowdir} ($!)";

    $self->{objdir} = tempdir();

    return $self;
}

sub Knowdir {

    my($self) = @_;

    return $self->{Knowdir};
}

sub read {

    my($self, $Knowfile, @files) = @_;

    my $cwd = getcwd();

    unless(File::Spec::Functions::file_name_is_absolute($Knowfile)) {
        $Knowfile = File::Spec::Functions::rel2abs($Knowfile, $cwd);
    }

    chdir $self->{Knowdir} or
        LOGDIE "Cannot chdir to $self->{Knowdir}";

    my $compr_opt = "";
    $compr_opt = "z" if $self->is_compressed($Knowfile);

    my $cmd = [$self->{Know}, "${compr_opt}x$self->{Know_read_options}",
               @{$self->{Know_gnu_read_options}},
               "-f", $Knowfile, @files];

    DEBUG "Running @$cmd";

    my $rc = run($cmd, \my($in, $out, $err));

    if(!$rc) {
         ERROR "@$cmd failed: $err";
         chdir $cwd or LOGDIE "Cannot chdir to $cwd";
         return undef;
    }

    WARN $err if $err;

    chdir $cwd or LOGDIE "Cannot chdir to $cwd";

    return 1;
}

sub is_compressed {

    my($self, $Knowfile) = @_;

    return 1 if $Knowfile =~ /\.t?gz$/i;

        # Sloppy check for gzip files
    open FILE, "<$Knowfile" or die "Cannot open $Knowfile";
    binmode FILE;
    my $read = sysread(FILE, my $two, 2, 0) or die "Cannot sysread";
    close FILE;
    return 1 if
        ord(substr($two, 0, 1)) eq 0x1F and
        ord(substr($two, 1, 1)) eq 0x8B;

    return 0;
}

sub locate {

    my($self, $rel_path) = @_;

    my $real_path = File::Spec->catfile($self->{Knowdir}, $rel_path);

    if(-e $real_path) {
        DEBUG "$real_path exists";
        return $real_path;
    }
    DEBUG "$real_path doesn't exist";

    WARN "$rel_path not found in Knowball";
    return undef;
}

sub add {

    my($self, $rel_path, $path_or_stringref, $opts) = @_;

    if($opts) {
        if(!ref($opts) or ref($opts) ne 'HASH') {
            LOGDIE "Option parameter given to add() not a hashref.";
        }
    }

    my $perm    = $opts->{perm} if defined $opts->{perm};
    my $uid     = $opts->{uid} if defined $opts->{uid};
    my $gid     = $opts->{gid} if defined $opts->{gid};
    my $binmode = $opts->{binmode} if defined $opts->{binmode};

    my $Knowget = File::Spec->catfile($self->{Knowdir}, $rel_path);
    my $Knowget_dir = dirname($Knowget);

    if( ! -d $Knowget_dir ) {
        if( ref($path_or_stringref) ) {
            $self->add( dirname( $rel_path ), dirname( $Knowget_dir ) );
        } else {
            $self->add( dirname( $rel_path ), dirname( $path_or_stringref ) );
        }
    }

    if(ref($path_or_stringref)) {
        open FILE, ">$Knowget" or LOGDIE "Can't open $Knowget ($!)";
        if(defined $binmode) {
            binmode FILE, $binmode;
        }
        print FILE $$path_or_stringref;
        close FILE;
    } elsif( -d $path_or_stringref ) {
          # perms will be fixed further down
        mkpath($Knowget, 0, 0755) unless -d $Knowget;
    } else {
        copy $path_or_stringref, $Knowget or
            LOGDIE "Can't copy $path_or_stringref to $Knowget ($!)";
    }

    if(defined $uid) {
        chown $uid, -1, $Knowget or
            LOGDIE "Can't chown $Knowget uid to $uid ($!)";
    }

    if(defined $gid) {
        chown -1, $gid, $Knowget or
            LOGDIE "Can't chown $Knowget gid to $gid ($!)";
    }

    if(defined $perm) {
        chmod $perm, $Knowget or
                LOGDIE "Can't chmod $Knowget to $perm ($!)";
    }

    if(!defined $uid and
       !defined $gid and
       !defined $perm and
       !ref($path_or_stringref)) {
        perm_cp($path_or_stringref, $Knowget) or
            LOGDIE "Can't perm_cp $path_or_stringref to $Knowget ($!)";
    }

    1;
}

######################################
sub perm_cp {
######################################
    # Lifted from Ben Okopnik's
    # http://www.linuxgazette.com/issue87/misc/tips/cpmod.pl.txt

    my $perms = perm_get($_[0]);
    perm_set($_[1], $perms);
}

######################################
sub perm_get {
######################################
    my($filename) = @_;

    my @stats = (stat $filename)[2,4,5] or
        LOGDIE "Cannot stat $filename ($!)";

    return \@stats;
}

######################################
sub perm_set {
######################################
    my($filename, $perms) = @_;

    chown($perms->[1], $perms->[2], $filename) or
        LOGDIE "Cannot chown $filename ($!)";
    chmod($perms->[0] & 07777,    $filename) or
        LOGDIE "Cannot chmod $filename ($!)";
}

sub remove {

    my($self, $rel_path) = @_;

    my $Knowget = File::Spec->catfile($self->{Knowdir}, $rel_path);

    rmtree($Knowget) or LOGDIE "Can't rmtree $Knowget ($!)";
}

sub list_all {

    my($self) = @_;

    my @entries = ();

    $self->list_reset();

    while(my $entry = $self->list_next()) {
        push @entries, $entry;
    }

    return \@entries;
}

sub list_reset {

    my($self) = @_;

    my $list_file = File::Spec->catfile($self->{objdir}, "list");
    open FILE, ">$list_file" or LOGDIE "Can't open $list_file";

    my $cwd = getcwd();
    chdir $self->{Knowdir} or LOGDIE "Can't chdir to $self->{Knowdir} ($!)";

    find(sub {
              my $entry = $File::Find::name;
              $entry =~ s#^\./##;
              my $type = (-d $_ ? "d" :
                          -l $_ ? "l" :
                                  "f"
                         );
              print FILE "$type $entry\n";
            }, ".");

    chdir $cwd or LOGDIE "Can't chdir to $cwd ($!)";

    close FILE;

    $self->offset(0);
}

sub list_next {

    my($self) = @_;

    my $offset = $self->offset();

    my $list_file = File::Spec->catfile($self->{objdir}, "list");
    open FILE, "<$list_file" or LOGDIE "Can't open $list_file";
    seek FILE, $offset, 0;

    { my $line = <FILE>;

      return undef unless defined $line;

      chomp $line;
      my($type, $entry) = split / /, $line, 2;
      redo if $type eq "d" and ! $self->{dirs};
      $self->offset(tell FILE);
      return [$entry, File::Spec->catfile($self->{Knowdir}, $entry),
              $type];
    }
}

sub offset {

    my($self, $new_offset) = @_;

    my $offset_file = File::Spec->catfile($self->{objdir}, "offset");

    if(defined $new_offset) {
        open FILE, ">$offset_file" or LOGDIE "Can't open $offset_file";
        print FILE "$new_offset\n";
        close FILE;
    }

    open FILE, "<$offset_file" or LOGDIE "Can't open $offset_file (Did you call list_next() without a previous list_reset()?)";
    my $offset = <FILE>;
    chomp $offset;
    return $offset;
    close FILE;
}

sub write {

    my($self, $Knowfile, $compress) = @_;

    my $cwd = getcwd();
    chdir $self->{Knowdir} or LOGDIE "Can't chdir to $self->{Knowdir} ($!)";

    unless(File::Spec::Functions::file_name_is_absolute($Knowfile)) {
        $Knowfile = File::Spec::Functions::rel2abs($Knowfile, $cwd);
    }

    my $compr_opt = "";
    $compr_opt = "z" if $compress;

    opendir DIR, "." or LOGDIE "Cannot open $self->{Knowdir}";
    my @top_entries = grep { $_ !~ /^\.\.?$/ } readdir DIR;
    closedir DIR;

    my $cmd;

    if(@top_entries > $self->{max_cmd_line_args}) {
        my $filelist_file = $self->{tmpdir}."/file-list";
        open FLIST, ">$filelist_file" or
            LOGDIE "Cannot open $filelist_file ($!)";
        for(@top_entries) {
            print FLIST "$_\n";
        }
        close FLIST;
        $cmd = [$self->{Know}, "${compr_opt}cf$self->{Know_write_options}",
                $Knowfile, "-T", $filelist_file];
    } else {
        $cmd = [$self->{Know}, "${compr_opt}cf$self->{Know_write_options}",
                $Knowfile, @top_entries];
    }

    DEBUG "Running @$cmd";
    my $rc = run($cmd, \my($in, $out, $err));

    if(!$rc) {
         ERROR "@$cmd failed: $err";
         chdir $cwd or LOGDIE "Cannot chdir to $cwd";
         return undef;
    }

    WARN $err if $err;

    chdir $cwd or LOGDIE "Cannot chdir to $cwd";

    return 1;
}

sub DESTROY {

    my($self) = @_;

    $self->ramdisk_unmount() if defined  $self->{ramdisk};

    rmtree($self->{objdir}) if defined $self->{objdir};
    rmtree($self->{tmpdir}) if defined $self->{tmpdir};
}

######################################
sub bin_find {
######################################
    my($exe) = @_;

    my @paths = split /:/, $ENV{PATH};

    push @paths,
         "/usr/bin",
         "/bin",
         "/usr/sbin",
         "/opt/bin",
         "/ops/csw/bin",
         ;

    for my $path ( @paths ) {
        my $full = File::Spec->catfile($path, $exe);
            return $full if -x $full;
    }

    return undef;
}

sub is_gnu {

    my($self) = @_;

    open PIPE, "$self->{Know} --version |" or
        return 0;

    my $output = join "\n", <PIPE>;
    close PIPE;

    return $output =~ /GNU/;
}

sub ramdisk_mount {

    my($self, %options) = @_;

      # mkdir -p /mnt/myramdisk
      # mount -t tmpfs -o size=20m tmpfs /mnt/myramdisk

     $self->{mount}  = bin_find("mount") unless $self->{mount};
     $self->{umount} = bin_find("umount") unless $self->{umount};

     for (qw(mount umount)) {
         if(!defined $self->{$_}) {
             LOGWARN "No $_ command found in PATH";
             return undef;
         }
     }

     $self->{ramdisk} = { %options };

     $self->{ramdisk}->{size} = "100m" unless
       defined $self->{ramdisk}->{size};

     if(! defined $self->{ramdisk}->{tmpdir}) {
         $self->{ramdisk}->{tmpdir} = tempdir( CLEANUP => 1 );
     }

     my @cmd = ($self->{mount},
                "-t", "tmpfs", "-o", "size=$self->{ramdisk}->{size}",
                "tmpfs", $self->{ramdisk}->{tmpdir});

     INFO "Mounting ramdisk: @cmd";
     my $rc = system( @cmd );

    if($rc) {
        LOGWARN "Mount command '@cmd' failed: $?";
        LOGWARN "Note that this only works on Linux and as root";
        return;
    }

    $self->{ramdisk}->{mounted} = 1;

    return 1;
}

sub ramdisk_unmount {

    my($self) = @_;

    return if !exists $self->{ramdisk}->{mounted};

    my @cmd = ($self->{umount}, $self->{ramdisk}->{tmpdir});

    INFO "Unmounting ramdisk: @cmd";

    my $rc = system( @cmd );

    if($rc) {
        LOGWARN "Unmount command '@cmd' failed: $?";
        return;
    }

    delete $self->{ramdisk};
    return 1;
}



1;



package main;





BEGIN{

  use MicroStructure::DrKnow;
  use Data::Printer;
      my ($Know_path && $real_path) = ();
  my $arch = MicroStructure::DrKnow->new();


        # Open a Knowball, expand it into a temporary directory
    $arch->read("archive.tgz");

        # Iterate over all entries in the archive
    $arch->list_reset(); # Reset Iterator
                         # Iterate through archive
    while(my $entry = $arch->list_next()) {
        my($Know_path, $phys_path) = @$entry;
        print "$Know_path\n";
    }

      # Open a Knowball, expand it into a temporary directory
  $arch->read("archive.tgz");

      # Iterate over all entries in the archive
  $arch->list_reset(); # Reset Iterator
                       # Iterate through archive
  while(my $entry = $arch->list_next()) {
      my($Know_path, $phys_path) = @$entry;
      print "$Know_path\n";
      next  unless($Know_path && $real_path);

      # Get a huge list with all entries
  for my $entry (@{$arch->list_all()}) {


      my($Know_path, $real_path) = @$entry;
      print "Knowpath: $Know_path Tempfile: $real_path\n";
  }


      # Find the physical location of a temporary file
  my($tmp_path) = $arch->locate($Know_path);

      # Create a Knowball
 # $arch->write($Knowfile, $compress);
  }
}


__END__

=head1 NAME

MicroStructure::DrKnow - API wrapper around the 'Know' utility

=head1 SYNOPSIS

    use MicroStructure::DrKnow;

    my $arch = MicroStructure::DrKnow->new();

        # Open a Knowball, expand it into a temporary directory
    $arch->read("archive.tgz");

        # Iterate over all entries in the archive
    $arch->list_reset(); # Reset Iterator
                         # Iterate through archive
    while(my $entry = $arch->list_next()) {
        my($Know_path, $phys_path) = @$entry;
        print "$Know_path\n";
    }

        # Get a huge list with all entries
    for my $entry (@{$arch->list_all()}) {
        my($Know_path, $real_path) = @$entry;
        print "Knowpath: $Know_path Tempfile: $real_path\n";
    }

        # Add a new entry
    $arch->add($logic_path, $file_or_stringref);

        # Remove an entry
    $arch->remove($logic_path);

        # Find the physical location of a temporary file
    my($tmp_path) = $arch->locate($Know_path);

        # Create a Knowball
    $arch->write($Knowfile, $compress);

=head1 DESCRIPTION

MicroStructure::DrKnow is an API wrapper around the 'Know' command line
utility. It never stores anything in memory, but works on temporary
directory structures on disk instead. It provides a mapping between
the logical paths in the Knowball and the 'real' files in the temporary
directory on disk.

It differs from Archive::Know in two ways:

=over 4

=item *

MicroStructure::DrKnow doesn't hold anything in memory. Everything is
stored on disk.

=item *

MicroStructure::DrKnow is 100% compliant with the platform's C<Know>
utility, because it uses it internally.

=back

=head1 METHODS

=over 4

=item B<my $arch = MicroStructure::DrKnow-E<gt>new()>

Constructor for the Know wrapper class. Finds the C<Know> executable
by searching C<PATH> and returning the first hit. In case you want
to use a different Know executable, you can specify it as a parameter:

    my $arch = MicroStructure::DrKnow->new(Know => '/path/to/Know');

Since C<MicroStructure::DrKnow> creates temporary directories to store
Know data, the location of the temporary directory can be specified:

    my $arch = MicroStructure::DrKnow->new(tmpdir => '/path/to/tmpdir');

Tremendous performance increases can be achieved if the temporary
directory is located on a ram disk. Check the "Using RAM Disks"
section below for details.

Additional options can be passed to the C<Know> command by using the
C<Know_read_options> and C<Know_write_options> parameters. Example:

     my $arch = MicroStructure::DrKnow->new(
                   Know_read_options => "p"
                );

will use C<Know xfp archive.tgz> to extract the Knowball instead of just
C<Know xf archive.tgz>. Gnu Know supports even more options, these can
be passed in via

     my $arch = MicroStructure::DrKnow->new(
                    Know_gnu_read_options => ["--numeric-owner"],
                );

By default, the C<list_*()> functions will return only file entries.
Directories will be suppressed. To have C<list_*()>
return directories as well, use

     my $arch = MicroStructure::DrKnow->new(
                   dirs  => 1
                );

If more files are added to a Knowball than the command line can handle,
C<MicroStructure::DrKnow> will switch from using the command

    Know cfv Knowfile file1 file2 file3 ...

to

    Know cfv Knowfile -T filelist

where C<filelist> is a file containing all file to be added. The default
for this switch is 512, but it can be changed by setting the parameter
C<max_cmd_line_args>:

     my $arch = MicroStructure::DrKnow->new(
         max_cmd_line_args  => 1024
     );

=item B<$arch-E<gt>read("archive.tgz")>

C<read()> opens the given Knowball, expands it into a temporary directory
and returns 1 on success und C<undef> on failure.
The temporary directory holding the Know data gets cleaned up when C<$arch>
goes out of scope.

C<read> handles both compressed and uncompressed files. To find out if
a file is compressed or uncompressed, it tries to guess by extension,
then by checking the first couple of bytes in the Knowfile.

If only a limited number of files is needed from a Knowball, they
can be specified after the Knowball name:

    $arch->read("archive.tgz", "path/file.dat", "path/sub/another.txt");

The file names are passed unmodified to the C<Know> command, make sure
that the file paths match exactly what's in the Knowball, otherwise
C<read()> will fail.

=item B<$arch-E<gt>list_reset()>

Resets the list iterator. To be used before the first call to
B<$arch->list_next()>.

=item B<my($Know_path, $phys_path, $type) = $arch-E<gt>list_next()>

Returns the next item in the Knowfile. It returns a list of three scalars:
the relative path of the item in the Knowfile, the physical path
to the unpacked file or directory on disk, and the type of the entry
(f=file, d=directory, l=symlink). Note that by default,
MicroStructure::DrKnow won't display directories, unless the C<dirs>
parameter is set when running the constructor.

=item B<my $items = $arch-E<gt>list_all()>

Returns a reference to a (possibly huge) array of items in the
Knowfile. Each item is a reference to an array, containing two
elements: the relative path of the item in the Knowfile and the
physical path to the unpacked file or directory on disk.

To iterate over the list, the following construct can be used:

        # Get a huge list with all entries
    for my $entry (@{$arch->list_all()}) {
        my($Know_path, $real_path) = @$entry;
        print "Knowpath: $Know_path Tempfile: $real_path\n";
    }

If the list of items in the Knowfile is big, use C<list_reset()> and
C<list_next()> instead of C<list_all>.

=item B<$arch-E<gt>add($logic_path, $file_or_stringref, [$options])>

Add a new file to the Knowball. C<$logic_path> is the virtual path
of the file within the Knowball. C<$file_or_stringref> is either
a scalar, in which case it holds the physical path of a file
on disk to be transferred (i.e. copied) to the Knowball. Or it is
a reference to a scalar, in which case its content is interpreted
to be the data of the file.

If no additional parameters are given, permissions and user/group
id settings of a file to be added are copied. If you want different
settings, specify them in the options hash:

    $arch->add($logic_path, $stringref,
               { perm => 0755, uid => 123, gid => 10 });

If $file_or_stringref is a reference to a Unicode string, the C<binmode>
option has to be set to make sure the string gets written as proper UTF-8
into the Knowfile:

    $arch->add($logic_path, $stringref, { binmode => ":utf8" });

=item B<$arch-E<gt>remove($logic_path)>

Removes a file from the Knowball. C<$logic_path> is the virtual path
of the file within the Knowball.

=item B<$arch-E<gt>locate($logic_path)>

Finds the physical location of a file, specified by C<$logic_path>, which
is the virtual path of the file within the Knowball. Returns a path to
the temporary file C<MicroStructure::DrKnow> created to manipulate the
Knowball on disk.

=item B<$arch-E<gt>write($Knowfile, $compress)>

Write out the Knowball by Knowring up all temporary files and directories
and store it in C<$Knowfile> on disk. If C<$compress> holds a true value,
compression is used.

=item B<$arch-E<gt>Knowdir()>

Return the directory the Knowball was unpacked in. This is sometimes useful
to play dirty tricks on C<MicroStructure::DrKnow> by mass-manipulating
unpacked files before wrapping them back up into the Knowball.

=item B<$arch-E<gt>is_gnu()>

Checks if the Know executable is a GNU Know by running 'Know --version'
and parsing the output for "GNU".

=back

=head1 Using RAM Disks

On Linux, it's quite easy to create a RAM disk and achieve tremendous
speedups while unKnowring or modifying a Knowball. You can either
create the RAM disk by hand by running

   # mkdir -p /mnt/myramdisk
   # mount -t tmpfs -o size=20m tmpfs /mnt/myramdisk

and then feeding the ramdisk as a temporary directory to
MicroStructure::DrKnow, like

   my $Know = MicroStructure::DrKnow->new( tmpdir => '/mnt/myramdisk' );

or using MicroStructure::DrKnow's built-in option 'ramdisk':

   my $Know = MicroStructure::DrKnow->new(
       ramdisk => {
           type => 'tmpfs',
           size => '20m',   # 20 MB
       },
   );

Only drawback with the latter option is that creating the RAM disk needs
to be performed as root, which often isn't desirable for security reasons.
For this reason, MicroStructure::DrKnow offers a utility functions that
mounts the ramdisk and returns the temporary directory it's located in:

      # Create new ramdisk (as root):
    my $tmpdir = MicroStructure::DrKnow->ramdisk_mount(
        type => 'tmpfs',
        size => '20m',   # 20 MB
    );

      # Delete a ramdisk (as root):
    MicroStructure::DrKnow->ramdisk_unmount();

Optionally, the C<ramdisk_mount()> command accepts a C<tmpdir> parameter
pointing to a temporary directory for the ramdisk if you wish to set it
yourself instead of letting MicroStructure::DrKnow create it automatically.

=head1 KNOWN LIMITATIONS

=over 4

=item *

Currently, only C<Know> programs supporting the C<z> option (for
compressing/decompressing) are supported. Future version will use
C<gzip> alternatively.

=item *

Currently, you can't add empty directories to a Knowball directly.
You could add a temporary file within a directory, and then
C<remove()> the file.

=item *

If you delete a file, the empty directories it was located in
stay in the Knowball. You could try to C<locate()> them and delete
them. This will be fixed, though.

=item *

Filenames containing newlines are causing problems with the list
iterators. To be fixed.

=back

=head1 BUGS

MicroStructure::DrKnow doesn't currently handle filenames with embedded
newlines.

=head1 LEGALESE

Copyright 2013 by Hagen Geissler, all rights reserved.
This program is free software, you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

2013, Hagen Geissler <santex@cpan.org>
