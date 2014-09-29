# This Makefile is for the AI::MicroStructure extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.98 (Revision: 69800) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT => q[AI::MicroStructure   Creates Concepts for words]
#     AUTHOR => [q[santex <santex@cpan.org>]]
#     BUILD_REQUIRES => {  }
#     CONFIGURE_REQUIRES => { ExtUtils::MakeMaker=>q[6.30] }
#     DISTNAME => q[AI-MicroStructure]
#     EXE_FILES => [q[bin/micro-steemer], q[bin/micro-test.pl], q[bin/x], q[bin/micro-wiki], q[bin/go], q[bin/micro-sock], q[bin/websock002.pl], q[bin/micro-dict], q[bin/micro], q[bin/micro-wiki-2], q[bin/micro-git], q[bin/CG.pl], q[bin/geany_run_script.sh], q[bin/cleantext.pl], q[bin/micrownet], q[bin/micro-ontology], q[bin/micro-wiki-clean], q[bin/quicky.pl], q[bin/micro-daemon], q[bin/micro-relation], q[bin/micro-sense], q[bin/micro-sockx], q[bin/micro-rename], q[bin/micro-wnet], q[bin/go.pl], q[bin/micro-test]]
#     LICENSE => q[perl]
#     NAME => q[AI::MicroStructure]
#     PREREQ_PM => { Digest::SHA1=>q[0], Parallel::Iterator=>q[0], Cache::Memcached::Fast=>q[0], AnyEvent::Subprocess::Easy=>q[0], File::Glob=>q[0], Data::Dumper=>q[0], Statistics::MVA::BayesianDiscrimination=>q[0], Fcntl=>q[0], Exporter=>q[0], Class::Container=>q[0], Cwd=>q[0], IO::Async::Loop=>q[0], Sysadm::Install=>q[0], File::Spec=>q[0], Config::Auto=>q[0], Params::Validate=>q[0], Getopt::Long=>q[0], Storable::CouchDB=>q[0], Net::Async::WebSocket::Server=>q[0], Statistics::Contingency=>q[0], Statistics::MVA::HotellingTwoSample=>q[0], HTML::Strip=>q[0], Search::ContextGraph=>q[0], Carp=>q[0], File::Basename=>q[0], List::Util=>q[0], Storable=>q[0], AnyDBM_File=>q[0], HTML::SimpleLinkExtor=>q[0], Data::Printer=>q[0], Algorithm::BaumWelch=>q[0], Statistics::Descriptive=>q[0], AI::Categorizer=>q[0], HTTP::Request::Common=>q[0], Mojolicious=>q[1.22], Lingua::StopWords=>q[0], IO::File=>q[0], JSON::XS=>q[0], AI::Categorizer::Learner::NaiveBayes=>q[0], Statistics::Basic=>q[0], Digest::MD5=>q[0], AI::Categorizer::KnowledgeSet=>q[0], Statistics::Distributions::Ancova=>q[0], JSON=>q[0], AI::Categorizer::Document=>q[0], LWP::UserAgent=>q[0] }
#     TEST_REQUIRES => {  }
#     VERSION => q[0.17]
#     test => { TESTS=>q[t/*.t] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/lib/x86_64-linux-gnu/perl/5.20/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = cc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -Wl,-E
DLEXT = so
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = cc
LDDLFLAGS = -shared -L/usr/local/lib -fstack-protector
LDFLAGS =  -fstack-protector -L/usr/local/lib
LIBC = libc-2.19.so
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 3.2.0-4-amd64
RANLIB = :
SITELIBEXP = /usr/local/share/perl/5.20.0
SITEARCHEXP = /usr/local/lib/x86_64-linux-gnu/perl/5.20.0
SO = so
VENDORARCHEXP = /usr/lib/x86_64-linux-gnu/perl5/5.20
VENDORLIBEXP = /usr/share/perl5


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = AI::MicroStructure
NAME_SYM = AI_MicroStructure
VERSION = 0.17
VERSION_MACRO = VERSION
VERSION_SYM = 0_17
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.17
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1p
MAN3EXT = 3pm
INSTALLDIRS = site
INSTALL_BASE = /home/santex/perl5
DESTDIR = 
PREFIX = $(INSTALL_BASE)
INSTALLPRIVLIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = $(INSTALL_BASE)/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = $(INSTALL_BASE)/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = $(INSTALL_BASE)/bin
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /usr/share/perl/5.20
PERL_ARCHLIB = /usr/lib/x86_64-linux-gnu/perl/5.20
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/lib/x86_64-linux-gnu/perl/5.20/CORE
PERL = /usr/bin/perl5.20.0
FULLPERL = /usr/bin/perl5.20.0
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /home/santex/perl5/lib/perl5/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.98
MM_REVISION = 69800

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = AI/MicroStructure
BASEEXT = MicroStructure
PARENT_NAME = AI
DLBASE = $(BASEEXT)
VERSION_FROM = 
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = 
MAN3PODS = lib/AI/MicroStructure.pm \
	lib/AI/MicroStructure/Alias.pm \
	lib/AI/MicroStructure/Categorizer.pm \
	lib/AI/MicroStructure/Collection.pm \
	lib/AI/MicroStructure/Context.pm \
	lib/AI/MicroStructure/DrKnow.pm \
	lib/AI/MicroStructure/Fitnes.pm \
	lib/AI/MicroStructure/Hypothesis.pm \
	lib/AI/MicroStructure/List.pm \
	lib/AI/MicroStructure/Locale.pm \
	lib/AI/MicroStructure/Memorizer.pm \
	lib/AI/MicroStructure/MultiList.pm \
	lib/AI/MicroStructure/Object.pm \
	lib/AI/MicroStructure/ObjectParser.pm \
	lib/AI/MicroStructure/Relations.pm \
	lib/AI/MicroStructure/RemoteList.pm \
	lib/AI/MicroStructure/Scoring.pm \
	lib/AI/MicroStructure/WordBlacklist.pm \
	lib/AI/MicroStructure/any.pm \
	lib/AI/MicroStructure/contributors.pm \
	lib/AI/MicroStructure/digits.pm \
	lib/AI/MicroStructure/foo.pm \
	lib/AI/MicroStructure/linux.pm \
	lib/AI/MicroStructure/pause_id.pm \
	lib/AI/MicroStructure/pm_groups.pm \
	lib/AI/MicroStructure/pornstars.pm \
	lib/AI/MicroStructure/services.pm \
	lib/AI/MicroStructure/simpsons.pm

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)/AI
INST_ARCHLIBDIR  = $(INST_ARCHLIB)/AI

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/AI/MicroStructure.pm \
	lib/AI/MicroStructure/Alias.pm \
	lib/AI/MicroStructure/Cache.pm \
	lib/AI/MicroStructure/Categorizer.pm \
	lib/AI/MicroStructure/Collection.pm \
	lib/AI/MicroStructure/Context.pm \
	lib/AI/MicroStructure/DrKnow.pm \
	lib/AI/MicroStructure/Fitnes.pm \
	lib/AI/MicroStructure/Hypothesis.pm \
	lib/AI/MicroStructure/List.pm \
	lib/AI/MicroStructure/Locale.pm \
	lib/AI/MicroStructure/Memd.pm \
	lib/AI/MicroStructure/Memorizer.pm \
	lib/AI/MicroStructure/MicroMemd.pm \
	lib/AI/MicroStructure/MultiList.pm \
	lib/AI/MicroStructure/Object.pm \
	lib/AI/MicroStructure/ObjectParser.pm \
	lib/AI/MicroStructure/ObjectSet.pm \
	lib/AI/MicroStructure/Reactor.pm \
	lib/AI/MicroStructure/Relations.pm \
	lib/AI/MicroStructure/Remember.pm \
	lib/AI/MicroStructure/RemoteList.pm \
	lib/AI/MicroStructure/Scoring.pm \
	lib/AI/MicroStructure/Tree.pm \
	lib/AI/MicroStructure/Util.pm \
	lib/AI/MicroStructure/WordBlacklist.pm \
	lib/AI/MicroStructure/any.pm \
	lib/AI/MicroStructure/contributors.pm \
	lib/AI/MicroStructure/digits.pm \
	lib/AI/MicroStructure/foo.pm \
	lib/AI/MicroStructure/geany_run_script.sh \
	lib/AI/MicroStructure/germany.pm \
	lib/AI/MicroStructure/linux.pm \
	lib/AI/MicroStructure/pause_id.pm \
	lib/AI/MicroStructure/pm_groups.pm \
	lib/AI/MicroStructure/pornstars.pm \
	lib/AI/MicroStructure/services.pm \
	lib/AI/MicroStructure/simpsons.pm \
	lib/icro.pm

PM_TO_BLIB = lib/AI/MicroStructure.pm \
	blib/lib/AI/MicroStructure.pm \
	lib/AI/MicroStructure/Alias.pm \
	blib/lib/AI/MicroStructure/Alias.pm \
	lib/AI/MicroStructure/Cache.pm \
	blib/lib/AI/MicroStructure/Cache.pm \
	lib/AI/MicroStructure/Categorizer.pm \
	blib/lib/AI/MicroStructure/Categorizer.pm \
	lib/AI/MicroStructure/Collection.pm \
	blib/lib/AI/MicroStructure/Collection.pm \
	lib/AI/MicroStructure/Context.pm \
	blib/lib/AI/MicroStructure/Context.pm \
	lib/AI/MicroStructure/DrKnow.pm \
	blib/lib/AI/MicroStructure/DrKnow.pm \
	lib/AI/MicroStructure/Fitnes.pm \
	blib/lib/AI/MicroStructure/Fitnes.pm \
	lib/AI/MicroStructure/Hypothesis.pm \
	blib/lib/AI/MicroStructure/Hypothesis.pm \
	lib/AI/MicroStructure/List.pm \
	blib/lib/AI/MicroStructure/List.pm \
	lib/AI/MicroStructure/Locale.pm \
	blib/lib/AI/MicroStructure/Locale.pm \
	lib/AI/MicroStructure/Memd.pm \
	blib/lib/AI/MicroStructure/Memd.pm \
	lib/AI/MicroStructure/Memorizer.pm \
	blib/lib/AI/MicroStructure/Memorizer.pm \
	lib/AI/MicroStructure/MicroMemd.pm \
	blib/lib/AI/MicroStructure/MicroMemd.pm \
	lib/AI/MicroStructure/MultiList.pm \
	blib/lib/AI/MicroStructure/MultiList.pm \
	lib/AI/MicroStructure/Object.pm \
	blib/lib/AI/MicroStructure/Object.pm \
	lib/AI/MicroStructure/ObjectParser.pm \
	blib/lib/AI/MicroStructure/ObjectParser.pm \
	lib/AI/MicroStructure/ObjectSet.pm \
	blib/lib/AI/MicroStructure/ObjectSet.pm \
	lib/AI/MicroStructure/Reactor.pm \
	blib/lib/AI/MicroStructure/Reactor.pm \
	lib/AI/MicroStructure/Relations.pm \
	blib/lib/AI/MicroStructure/Relations.pm \
	lib/AI/MicroStructure/Remember.pm \
	blib/lib/AI/MicroStructure/Remember.pm \
	lib/AI/MicroStructure/RemoteList.pm \
	blib/lib/AI/MicroStructure/RemoteList.pm \
	lib/AI/MicroStructure/Scoring.pm \
	blib/lib/AI/MicroStructure/Scoring.pm \
	lib/AI/MicroStructure/Tree.pm \
	blib/lib/AI/MicroStructure/Tree.pm \
	lib/AI/MicroStructure/Util.pm \
	blib/lib/AI/MicroStructure/Util.pm \
	lib/AI/MicroStructure/WordBlacklist.pm \
	blib/lib/AI/MicroStructure/WordBlacklist.pm \
	lib/AI/MicroStructure/any.pm \
	blib/lib/AI/MicroStructure/any.pm \
	lib/AI/MicroStructure/contributors.pm \
	blib/lib/AI/MicroStructure/contributors.pm \
	lib/AI/MicroStructure/digits.pm \
	blib/lib/AI/MicroStructure/digits.pm \
	lib/AI/MicroStructure/foo.pm \
	blib/lib/AI/MicroStructure/foo.pm \
	lib/AI/MicroStructure/geany_run_script.sh \
	blib/lib/AI/MicroStructure/geany_run_script.sh \
	lib/AI/MicroStructure/germany.pm \
	blib/lib/AI/MicroStructure/germany.pm \
	lib/AI/MicroStructure/linux.pm \
	blib/lib/AI/MicroStructure/linux.pm \
	lib/AI/MicroStructure/pause_id.pm \
	blib/lib/AI/MicroStructure/pause_id.pm \
	lib/AI/MicroStructure/pm_groups.pm \
	blib/lib/AI/MicroStructure/pm_groups.pm \
	lib/AI/MicroStructure/pornstars.pm \
	blib/lib/AI/MicroStructure/pornstars.pm \
	lib/AI/MicroStructure/services.pm \
	blib/lib/AI/MicroStructure/services.pm \
	lib/AI/MicroStructure/simpsons.pm \
	blib/lib/AI/MicroStructure/simpsons.pm \
	lib/icro.pm \
	blib/lib/icro.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.98
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --
CP_NONEMPTY = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'cp_nonempty' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = AI-MicroStructure
DISTVNAME = AI-MicroStructure-0.17


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"\
	INSTALL_BASE="$(INSTALL_BASE)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(BOOTSTRAP) $(INST_DYNAMIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	lib/AI/MicroStructure.pm \
	lib/AI/MicroStructure/Alias.pm \
	lib/AI/MicroStructure/Categorizer.pm \
	lib/AI/MicroStructure/Collection.pm \
	lib/AI/MicroStructure/Context.pm \
	lib/AI/MicroStructure/DrKnow.pm \
	lib/AI/MicroStructure/Fitnes.pm \
	lib/AI/MicroStructure/Hypothesis.pm \
	lib/AI/MicroStructure/List.pm \
	lib/AI/MicroStructure/Locale.pm \
	lib/AI/MicroStructure/Memorizer.pm \
	lib/AI/MicroStructure/MultiList.pm \
	lib/AI/MicroStructure/Object.pm \
	lib/AI/MicroStructure/ObjectParser.pm \
	lib/AI/MicroStructure/Relations.pm \
	lib/AI/MicroStructure/RemoteList.pm \
	lib/AI/MicroStructure/Scoring.pm \
	lib/AI/MicroStructure/WordBlacklist.pm \
	lib/AI/MicroStructure/any.pm \
	lib/AI/MicroStructure/contributors.pm \
	lib/AI/MicroStructure/digits.pm \
	lib/AI/MicroStructure/foo.pm \
	lib/AI/MicroStructure/linux.pm \
	lib/AI/MicroStructure/pause_id.pm \
	lib/AI/MicroStructure/pm_groups.pm \
	lib/AI/MicroStructure/pornstars.pm \
	lib/AI/MicroStructure/services.pm \
	lib/AI/MicroStructure/simpsons.pm
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/AI/MicroStructure.pm $(INST_MAN3DIR)/AI::MicroStructure.$(MAN3EXT) \
	  lib/AI/MicroStructure/Alias.pm $(INST_MAN3DIR)/AI::MicroStructure::Alias.$(MAN3EXT) \
	  lib/AI/MicroStructure/Categorizer.pm $(INST_MAN3DIR)/AI::MicroStructure::Categorizer.$(MAN3EXT) \
	  lib/AI/MicroStructure/Collection.pm $(INST_MAN3DIR)/AI::MicroStructure::Collection.$(MAN3EXT) \
	  lib/AI/MicroStructure/Context.pm $(INST_MAN3DIR)/AI::MicroStructure::Context.$(MAN3EXT) \
	  lib/AI/MicroStructure/DrKnow.pm $(INST_MAN3DIR)/AI::MicroStructure::DrKnow.$(MAN3EXT) \
	  lib/AI/MicroStructure/Fitnes.pm $(INST_MAN3DIR)/AI::MicroStructure::Fitnes.$(MAN3EXT) \
	  lib/AI/MicroStructure/Hypothesis.pm $(INST_MAN3DIR)/AI::MicroStructure::Hypothesis.$(MAN3EXT) \
	  lib/AI/MicroStructure/List.pm $(INST_MAN3DIR)/AI::MicroStructure::List.$(MAN3EXT) \
	  lib/AI/MicroStructure/Locale.pm $(INST_MAN3DIR)/AI::MicroStructure::Locale.$(MAN3EXT) \
	  lib/AI/MicroStructure/Memorizer.pm $(INST_MAN3DIR)/AI::MicroStructure::Memorizer.$(MAN3EXT) \
	  lib/AI/MicroStructure/MultiList.pm $(INST_MAN3DIR)/AI::MicroStructure::MultiList.$(MAN3EXT) \
	  lib/AI/MicroStructure/Object.pm $(INST_MAN3DIR)/AI::MicroStructure::Object.$(MAN3EXT) \
	  lib/AI/MicroStructure/ObjectParser.pm $(INST_MAN3DIR)/AI::MicroStructure::ObjectParser.$(MAN3EXT) \
	  lib/AI/MicroStructure/Relations.pm $(INST_MAN3DIR)/AI::MicroStructure::Relations.$(MAN3EXT) \
	  lib/AI/MicroStructure/RemoteList.pm $(INST_MAN3DIR)/AI::MicroStructure::RemoteList.$(MAN3EXT) \
	  lib/AI/MicroStructure/Scoring.pm $(INST_MAN3DIR)/AI::MicroStructure::Scoring.$(MAN3EXT) \
	  lib/AI/MicroStructure/WordBlacklist.pm $(INST_MAN3DIR)/AI::MicroStructure::WordBlacklist.$(MAN3EXT) \
	  lib/AI/MicroStructure/any.pm $(INST_MAN3DIR)/AI::MicroStructure::any.$(MAN3EXT) \
	  lib/AI/MicroStructure/contributors.pm $(INST_MAN3DIR)/AI::MicroStructure::contributors.$(MAN3EXT) \
	  lib/AI/MicroStructure/digits.pm $(INST_MAN3DIR)/AI::MicroStructure::digits.$(MAN3EXT) \
	  lib/AI/MicroStructure/foo.pm $(INST_MAN3DIR)/AI::MicroStructure::foo.$(MAN3EXT) \
	  lib/AI/MicroStructure/linux.pm $(INST_MAN3DIR)/AI::MicroStructure::linux.$(MAN3EXT) \
	  lib/AI/MicroStructure/pause_id.pm $(INST_MAN3DIR)/AI::MicroStructure::pause_id.$(MAN3EXT) \
	  lib/AI/MicroStructure/pm_groups.pm $(INST_MAN3DIR)/AI::MicroStructure::pm_groups.$(MAN3EXT) \
	  lib/AI/MicroStructure/pornstars.pm $(INST_MAN3DIR)/AI::MicroStructure::pornstars.$(MAN3EXT) \
	  lib/AI/MicroStructure/services.pm $(INST_MAN3DIR)/AI::MicroStructure::services.$(MAN3EXT) \
	  lib/AI/MicroStructure/simpsons.pm $(INST_MAN3DIR)/AI::MicroStructure::simpsons.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = bin/micro-steemer bin/micro-test.pl bin/x bin/micro-wiki bin/go bin/micro-sock bin/websock002.pl bin/micro-dict bin/micro bin/micro-wiki-2 bin/micro-git bin/CG.pl bin/geany_run_script.sh bin/cleantext.pl bin/micrownet bin/micro-ontology bin/micro-wiki-clean bin/quicky.pl bin/micro-daemon bin/micro-relation bin/micro-sense bin/micro-sockx bin/micro-rename bin/micro-wnet bin/go.pl bin/micro-test

pure_all :: $(INST_SCRIPT)/micro-dict $(INST_SCRIPT)/micro-relation $(INST_SCRIPT)/quicky.pl $(INST_SCRIPT)/micro-daemon $(INST_SCRIPT)/micro-ontology $(INST_SCRIPT)/geany_run_script.sh $(INST_SCRIPT)/websock002.pl $(INST_SCRIPT)/micrownet $(INST_SCRIPT)/go $(INST_SCRIPT)/micro-sockx $(INST_SCRIPT)/CG.pl $(INST_SCRIPT)/micro $(INST_SCRIPT)/go.pl $(INST_SCRIPT)/micro-test.pl $(INST_SCRIPT)/micro-git $(INST_SCRIPT)/micro-wiki-2 $(INST_SCRIPT)/micro-steemer $(INST_SCRIPT)/x $(INST_SCRIPT)/micro-test $(INST_SCRIPT)/micro-wnet $(INST_SCRIPT)/micro-wiki-clean $(INST_SCRIPT)/micro-sense $(INST_SCRIPT)/cleantext.pl $(INST_SCRIPT)/micro-sock $(INST_SCRIPT)/micro-rename $(INST_SCRIPT)/micro-wiki
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/micro-dict $(INST_SCRIPT)/micro-relation \
	  $(INST_SCRIPT)/quicky.pl $(INST_SCRIPT)/micro-daemon \
	  $(INST_SCRIPT)/micro-ontology $(INST_SCRIPT)/geany_run_script.sh \
	  $(INST_SCRIPT)/websock002.pl $(INST_SCRIPT)/micrownet \
	  $(INST_SCRIPT)/go $(INST_SCRIPT)/micro-sockx \
	  $(INST_SCRIPT)/CG.pl $(INST_SCRIPT)/micro \
	  $(INST_SCRIPT)/go.pl $(INST_SCRIPT)/micro-test.pl \
	  $(INST_SCRIPT)/micro-git $(INST_SCRIPT)/micro-wiki-2 \
	  $(INST_SCRIPT)/micro-steemer $(INST_SCRIPT)/x \
	  $(INST_SCRIPT)/micro-test $(INST_SCRIPT)/micro-wnet \
	  $(INST_SCRIPT)/micro-wiki-clean $(INST_SCRIPT)/micro-sense \
	  $(INST_SCRIPT)/cleantext.pl $(INST_SCRIPT)/micro-sock \
	  $(INST_SCRIPT)/micro-rename $(INST_SCRIPT)/micro-wiki 

$(INST_SCRIPT)/micro-dict : bin/micro-dict $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-dict
	$(CP) bin/micro-dict $(INST_SCRIPT)/micro-dict
	$(FIXIN) $(INST_SCRIPT)/micro-dict
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-dict

$(INST_SCRIPT)/micro-relation : bin/micro-relation $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-relation
	$(CP) bin/micro-relation $(INST_SCRIPT)/micro-relation
	$(FIXIN) $(INST_SCRIPT)/micro-relation
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-relation

$(INST_SCRIPT)/quicky.pl : bin/quicky.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/quicky.pl
	$(CP) bin/quicky.pl $(INST_SCRIPT)/quicky.pl
	$(FIXIN) $(INST_SCRIPT)/quicky.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/quicky.pl

$(INST_SCRIPT)/micro-daemon : bin/micro-daemon $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-daemon
	$(CP) bin/micro-daemon $(INST_SCRIPT)/micro-daemon
	$(FIXIN) $(INST_SCRIPT)/micro-daemon
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-daemon

$(INST_SCRIPT)/micro-ontology : bin/micro-ontology $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-ontology
	$(CP) bin/micro-ontology $(INST_SCRIPT)/micro-ontology
	$(FIXIN) $(INST_SCRIPT)/micro-ontology
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-ontology

$(INST_SCRIPT)/geany_run_script.sh : bin/geany_run_script.sh $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/geany_run_script.sh
	$(CP) bin/geany_run_script.sh $(INST_SCRIPT)/geany_run_script.sh
	$(FIXIN) $(INST_SCRIPT)/geany_run_script.sh
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/geany_run_script.sh

$(INST_SCRIPT)/websock002.pl : bin/websock002.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/websock002.pl
	$(CP) bin/websock002.pl $(INST_SCRIPT)/websock002.pl
	$(FIXIN) $(INST_SCRIPT)/websock002.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/websock002.pl

$(INST_SCRIPT)/micrownet : bin/micrownet $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micrownet
	$(CP) bin/micrownet $(INST_SCRIPT)/micrownet
	$(FIXIN) $(INST_SCRIPT)/micrownet
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micrownet

$(INST_SCRIPT)/go : bin/go $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/go
	$(CP) bin/go $(INST_SCRIPT)/go
	$(FIXIN) $(INST_SCRIPT)/go
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/go

$(INST_SCRIPT)/micro-sockx : bin/micro-sockx $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-sockx
	$(CP) bin/micro-sockx $(INST_SCRIPT)/micro-sockx
	$(FIXIN) $(INST_SCRIPT)/micro-sockx
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-sockx

$(INST_SCRIPT)/CG.pl : bin/CG.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/CG.pl
	$(CP) bin/CG.pl $(INST_SCRIPT)/CG.pl
	$(FIXIN) $(INST_SCRIPT)/CG.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/CG.pl

$(INST_SCRIPT)/micro : bin/micro $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro
	$(CP) bin/micro $(INST_SCRIPT)/micro
	$(FIXIN) $(INST_SCRIPT)/micro
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro

$(INST_SCRIPT)/go.pl : bin/go.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/go.pl
	$(CP) bin/go.pl $(INST_SCRIPT)/go.pl
	$(FIXIN) $(INST_SCRIPT)/go.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/go.pl

$(INST_SCRIPT)/micro-test.pl : bin/micro-test.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-test.pl
	$(CP) bin/micro-test.pl $(INST_SCRIPT)/micro-test.pl
	$(FIXIN) $(INST_SCRIPT)/micro-test.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-test.pl

$(INST_SCRIPT)/micro-git : bin/micro-git $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-git
	$(CP) bin/micro-git $(INST_SCRIPT)/micro-git
	$(FIXIN) $(INST_SCRIPT)/micro-git
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-git

$(INST_SCRIPT)/micro-wiki-2 : bin/micro-wiki-2 $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-wiki-2
	$(CP) bin/micro-wiki-2 $(INST_SCRIPT)/micro-wiki-2
	$(FIXIN) $(INST_SCRIPT)/micro-wiki-2
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-wiki-2

$(INST_SCRIPT)/micro-steemer : bin/micro-steemer $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-steemer
	$(CP) bin/micro-steemer $(INST_SCRIPT)/micro-steemer
	$(FIXIN) $(INST_SCRIPT)/micro-steemer
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-steemer

$(INST_SCRIPT)/x : bin/x $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/x
	$(CP) bin/x $(INST_SCRIPT)/x
	$(FIXIN) $(INST_SCRIPT)/x
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/x

$(INST_SCRIPT)/micro-test : bin/micro-test $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-test
	$(CP) bin/micro-test $(INST_SCRIPT)/micro-test
	$(FIXIN) $(INST_SCRIPT)/micro-test
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-test

$(INST_SCRIPT)/micro-wnet : bin/micro-wnet $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-wnet
	$(CP) bin/micro-wnet $(INST_SCRIPT)/micro-wnet
	$(FIXIN) $(INST_SCRIPT)/micro-wnet
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-wnet

$(INST_SCRIPT)/micro-wiki-clean : bin/micro-wiki-clean $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-wiki-clean
	$(CP) bin/micro-wiki-clean $(INST_SCRIPT)/micro-wiki-clean
	$(FIXIN) $(INST_SCRIPT)/micro-wiki-clean
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-wiki-clean

$(INST_SCRIPT)/micro-sense : bin/micro-sense $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-sense
	$(CP) bin/micro-sense $(INST_SCRIPT)/micro-sense
	$(FIXIN) $(INST_SCRIPT)/micro-sense
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-sense

$(INST_SCRIPT)/cleantext.pl : bin/cleantext.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/cleantext.pl
	$(CP) bin/cleantext.pl $(INST_SCRIPT)/cleantext.pl
	$(FIXIN) $(INST_SCRIPT)/cleantext.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/cleantext.pl

$(INST_SCRIPT)/micro-sock : bin/micro-sock $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-sock
	$(CP) bin/micro-sock $(INST_SCRIPT)/micro-sock
	$(FIXIN) $(INST_SCRIPT)/micro-sock
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-sock

$(INST_SCRIPT)/micro-rename : bin/micro-rename $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-rename
	$(CP) bin/micro-rename $(INST_SCRIPT)/micro-rename
	$(FIXIN) $(INST_SCRIPT)/micro-rename
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-rename

$(INST_SCRIPT)/micro-wiki : bin/micro-wiki $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/micro-wiki
	$(CP) bin/micro-wiki $(INST_SCRIPT)/micro-wiki
	$(FIXIN) $(INST_SCRIPT)/micro-wiki
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/micro-wiki



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).bso $(BASEEXT).def \
	  $(BASEEXT).exp $(BASEEXT).x \
	  $(BOOTSTRAP) $(INST_ARCHAUTODIR)/extralibs.all \
	  $(INST_ARCHAUTODIR)/extralibs.ld $(MAKE_APERL_FILE) \
	  *$(LIB_EXT) *$(OBJ_EXT) \
	  *perl.core MYMETA.json \
	  MYMETA.yml blibdirs.ts \
	  core core.*perl.*.? \
	  core.[0-9] core.[0-9][0-9] \
	  core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
	  core.[0-9][0-9][0-9][0-9][0-9] lib$(BASEEXT).def \
	  mon.out perl \
	  perl$(EXE_EXT) perl.exe \
	  perlmain.c pm_to_blib \
	  pm_to_blib.ts so_locations \
	  tmon.out 
	- $(RM_RF) \
	  blib 
	  $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(FIRST_MAKEFILE) $(MAKEFILE_OLD) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '---' > META_new.yml
	$(NOECHO) $(ECHO) 'abstract: '\''AI::MicroStructure   Creates Concepts for words'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '  - '\''santex <santex@cpan.org>'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'build_requires: {}' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: '\''6.30'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'dynamic_config: 1' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by: '\''ExtUtils::MakeMaker version 6.98, CPAN::Meta::Converter version 2.140640'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'license: perl' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '  url: http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '  version: '\''1.4'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'name: AI-MicroStructure' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '  directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - t' >> META_new.yml
	$(NOECHO) $(ECHO) '    - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  AI::Categorizer: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  AI::Categorizer::Document: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  AI::Categorizer::KnowledgeSet: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  AI::Categorizer::Learner::NaiveBayes: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Algorithm::BaumWelch: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  AnyDBM_File: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  AnyEvent::Subprocess::Easy: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Cache::Memcached::Fast: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Carp: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Class::Container: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Config::Auto: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Cwd: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Data::Dumper: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Data::Printer: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Digest::MD5: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Digest::SHA1: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Exporter: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Fcntl: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Basename: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Glob: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Spec: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Getopt::Long: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  HTML::SimpleLinkExtor: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  HTML::Strip: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  HTTP::Request::Common: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  IO::Async::Loop: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  IO::File: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  JSON: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  JSON::XS: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  LWP::UserAgent: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Lingua::StopWords: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  List::Util: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Mojolicious: '\''1.22'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Net::Async::WebSocket::Server: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Parallel::Iterator: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Params::Validate: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Search::ContextGraph: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Statistics::Basic: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Statistics::Contingency: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Statistics::Descriptive: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Statistics::Distributions::Ancova: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Statistics::MVA::BayesianDiscrimination: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Statistics::MVA::HotellingTwoSample: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Storable: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Storable::CouchDB: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  Sysadm::Install: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'version: '\''0.17'\''' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml
	$(NOECHO) $(ECHO) Generating META.json
	$(NOECHO) $(ECHO) '{' > META_new.json
	$(NOECHO) $(ECHO) '   "abstract" : "AI::MicroStructure   Creates Concepts for words",' >> META_new.json
	$(NOECHO) $(ECHO) '   "author" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "santex <santex@cpan.org>"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "dynamic_config" : 1,' >> META_new.json
	$(NOECHO) $(ECHO) '   "generated_by" : "ExtUtils::MakeMaker version 6.98, CPAN::Meta::Converter version 2.140640",' >> META_new.json
	$(NOECHO) $(ECHO) '   "license" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "perl_5"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "meta-spec" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",' >> META_new.json
	$(NOECHO) $(ECHO) '      "version" : "2"' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "name" : "AI-MicroStructure",' >> META_new.json
	$(NOECHO) $(ECHO) '   "no_index" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "directory" : [' >> META_new.json
	$(NOECHO) $(ECHO) '         "t",' >> META_new.json
	$(NOECHO) $(ECHO) '         "inc"' >> META_new.json
	$(NOECHO) $(ECHO) '      ]' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "prereqs" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "build" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {}' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "configure" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "6.30"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "runtime" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "AI::Categorizer" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "AI::Categorizer::Document" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "AI::Categorizer::KnowledgeSet" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "AI::Categorizer::Learner::NaiveBayes" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Algorithm::BaumWelch" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "AnyDBM_File" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "AnyEvent::Subprocess::Easy" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Cache::Memcached::Fast" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Carp" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Class::Container" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Config::Auto" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Cwd" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Data::Dumper" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Data::Printer" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Digest::MD5" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Digest::SHA1" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Exporter" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Fcntl" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Basename" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Glob" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Spec" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Getopt::Long" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "HTML::SimpleLinkExtor" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "HTML::Strip" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "HTTP::Request::Common" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "IO::Async::Loop" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "IO::File" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "JSON" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "JSON::XS" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "LWP::UserAgent" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Lingua::StopWords" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "List::Util" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Mojolicious" : "1.22",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Net::Async::WebSocket::Server" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Parallel::Iterator" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Params::Validate" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Search::ContextGraph" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Statistics::Basic" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Statistics::Contingency" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Statistics::Descriptive" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Statistics::Distributions::Ancova" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Statistics::MVA::BayesianDiscrimination" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Statistics::MVA::HotellingTwoSample" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Storable" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Storable::CouchDB" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Sysadm::Install" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "release_status" : "stable",' >> META_new.json
	$(NOECHO) $(ECHO) '   "version" : "0.17"' >> META_new.json
	$(NOECHO) $(ECHO) '}' >> META_new.json
	-$(NOECHO) $(MV) META_new.json $(DISTVNAME)/META.json


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.yml to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.json to MANIFEST: $$$${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)


doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /usr/bin/perl5.20.0

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="$(VERSION)">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>AI::MicroStructure   Creates Concepts for words</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>santex &lt;santex@cpan.org&gt;</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="AI::Categorizer" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="AI::Categorizer::Document" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="AI::Categorizer::KnowledgeSet" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="AI::Categorizer::Learner::NaiveBayes" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Algorithm::BaumWelch" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="AnyDBM_File::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="AnyEvent::Subprocess::Easy" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Cache::Memcached::Fast" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Carp::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Class::Container" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Config::Auto" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Cwd::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Data::Dumper" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Data::Printer" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Digest::MD5" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Digest::SHA1" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Exporter::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Fcntl::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::Basename" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::Glob" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::Spec" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Getopt::Long" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="HTML::SimpleLinkExtor" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="HTML::Strip" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="HTTP::Request::Common" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="IO::Async::Loop" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="IO::File" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="JSON::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="JSON::XS" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="LWP::UserAgent" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Lingua::StopWords" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="List::Util" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE VERSION="1.22" NAME="Mojolicious::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Net::Async::WebSocket::Server" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Parallel::Iterator" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Params::Validate" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Search::ContextGraph" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Statistics::Basic" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Statistics::Contingency" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Statistics::Descriptive" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Statistics::Distributions::Ancova" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Statistics::MVA::BayesianDiscrimination" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Statistics::MVA::HotellingTwoSample" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Storable::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Storable::CouchDB" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Sysadm::Install" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="x86_64-linux-gnu-thread-multi-5.20" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/AI/MicroStructure.pm blib/lib/AI/MicroStructure.pm \
	  lib/AI/MicroStructure/Alias.pm blib/lib/AI/MicroStructure/Alias.pm \
	  lib/AI/MicroStructure/Cache.pm blib/lib/AI/MicroStructure/Cache.pm \
	  lib/AI/MicroStructure/Categorizer.pm blib/lib/AI/MicroStructure/Categorizer.pm \
	  lib/AI/MicroStructure/Collection.pm blib/lib/AI/MicroStructure/Collection.pm \
	  lib/AI/MicroStructure/Context.pm blib/lib/AI/MicroStructure/Context.pm \
	  lib/AI/MicroStructure/DrKnow.pm blib/lib/AI/MicroStructure/DrKnow.pm \
	  lib/AI/MicroStructure/Fitnes.pm blib/lib/AI/MicroStructure/Fitnes.pm \
	  lib/AI/MicroStructure/Hypothesis.pm blib/lib/AI/MicroStructure/Hypothesis.pm \
	  lib/AI/MicroStructure/List.pm blib/lib/AI/MicroStructure/List.pm \
	  lib/AI/MicroStructure/Locale.pm blib/lib/AI/MicroStructure/Locale.pm \
	  lib/AI/MicroStructure/Memd.pm blib/lib/AI/MicroStructure/Memd.pm \
	  lib/AI/MicroStructure/Memorizer.pm blib/lib/AI/MicroStructure/Memorizer.pm \
	  lib/AI/MicroStructure/MicroMemd.pm blib/lib/AI/MicroStructure/MicroMemd.pm \
	  lib/AI/MicroStructure/MultiList.pm blib/lib/AI/MicroStructure/MultiList.pm \
	  lib/AI/MicroStructure/Object.pm blib/lib/AI/MicroStructure/Object.pm \
	  lib/AI/MicroStructure/ObjectParser.pm blib/lib/AI/MicroStructure/ObjectParser.pm \
	  lib/AI/MicroStructure/ObjectSet.pm blib/lib/AI/MicroStructure/ObjectSet.pm \
	  lib/AI/MicroStructure/Reactor.pm blib/lib/AI/MicroStructure/Reactor.pm \
	  lib/AI/MicroStructure/Relations.pm blib/lib/AI/MicroStructure/Relations.pm \
	  lib/AI/MicroStructure/Remember.pm blib/lib/AI/MicroStructure/Remember.pm \
	  lib/AI/MicroStructure/RemoteList.pm blib/lib/AI/MicroStructure/RemoteList.pm \
	  lib/AI/MicroStructure/Scoring.pm blib/lib/AI/MicroStructure/Scoring.pm \
	  lib/AI/MicroStructure/Tree.pm blib/lib/AI/MicroStructure/Tree.pm \
	  lib/AI/MicroStructure/Util.pm blib/lib/AI/MicroStructure/Util.pm \
	  lib/AI/MicroStructure/WordBlacklist.pm blib/lib/AI/MicroStructure/WordBlacklist.pm \
	  lib/AI/MicroStructure/any.pm blib/lib/AI/MicroStructure/any.pm \
	  lib/AI/MicroStructure/contributors.pm blib/lib/AI/MicroStructure/contributors.pm \
	  lib/AI/MicroStructure/digits.pm blib/lib/AI/MicroStructure/digits.pm \
	  lib/AI/MicroStructure/foo.pm blib/lib/AI/MicroStructure/foo.pm \
	  lib/AI/MicroStructure/geany_run_script.sh blib/lib/AI/MicroStructure/geany_run_script.sh \
	  lib/AI/MicroStructure/germany.pm blib/lib/AI/MicroStructure/germany.pm \
	  lib/AI/MicroStructure/linux.pm blib/lib/AI/MicroStructure/linux.pm \
	  lib/AI/MicroStructure/pause_id.pm blib/lib/AI/MicroStructure/pause_id.pm \
	  lib/AI/MicroStructure/pm_groups.pm blib/lib/AI/MicroStructure/pm_groups.pm \
	  lib/AI/MicroStructure/pornstars.pm blib/lib/AI/MicroStructure/pornstars.pm 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/AI/MicroStructure/services.pm blib/lib/AI/MicroStructure/services.pm \
	  lib/AI/MicroStructure/simpsons.pm blib/lib/AI/MicroStructure/simpsons.pm \
	  lib/icro.pm blib/lib/icro.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
