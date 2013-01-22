#!/usr/bin/perl -w

# This program creates a server session and an infinitude of clients
# that connect to it, all in the same process.  It's mainly used to
# test for memory leaks, but it's also something of a benchmark.

# It is possible to split this program into two separate processes:
#   Change $server_addr to something appropriate.
#   Make a second copy of this program.
#   In the "server" copy, comment out the call to &pool_create();
#   In the "client" copy, comment out th ecall to &server_create();

use strict;
use lib '../lib';
use Socket;

#sub POE::Kernel::ASSERT_DEFAULT () { 1 }
use POE qw(Wheel::ListenAccept Wheel::ReadWrite Driver::SysRW Filter::Line
           Wheel::SocketFactory
          );

sub MAX_SIMULTANEOUS_CLIENTS () { 5 }
                                        # make 1 to enable output
sub DEBUG () { 0 }
                                        # address and port the server binds to
my $server_addr = '127.0.0.1';
my $server_port = 32100;

###############################################################################
# This is a single client session.  It uses two separator wheels: a
# SocketFactory to establish a connection, and a ReadWrite to process
# data once the connection is made

#------------------------------------------------------------------------------
# This is regular Perl sub that helps create new clients.  It's not an
# event handler.

sub client_create {
  my $serial_number = shift;
                                        # create the session
  POE::Session->create(
    inline_states => {
      _start    => \&client_start,
      _stop     => \&client_stop,
      receive   => \&client_receive,
      error     => \&client_error,
      connected => \&client_connected,
      signals   => \&client_signals,
      _parent   => sub {},
    },

    # ARG0
    args => [ $serial_number ]
 );
}

#------------------------------------------------------------------------------
# Accept POE's standard _start event, and create a non-blocking client
# socket.

sub client_start {
  my ($kernel, $heap, $serial) = @_[KERNEL, HEAP, ARG0];

  DEBUG && print "Client $serial is starting.\n";
                                        # remember this client's serial number
  $heap->{'serial'} = $serial;
                                        # watch for SIGINT
  $kernel->sig('INT', 'signals');
                                        # create a socket factory
  $heap->{'wheel'} = POE::Wheel::SocketFactory->new(
    RemoteAddress  => $server_addr,   # connecting to address $server_addr
    RemotePort     => $server_port,   # connecting to port $server_port
    SuccessEvent   => 'connected',    # generating this event when connected
    FailureEvent   => 'error',        # generating this event upon an error
  );
}

#------------------------------------------------------------------------------
# Accept POE's standard _stop event.  This normally would clean up the
# session, but this program doesn't keep anything in the heap that
# needs to be cleaned up.

sub client_stop {
  my $heap = $_[HEAP];
  DEBUG && print "Client $heap->{'serial'} has stopped.\n";
}

#------------------------------------------------------------------------------
# This event handler/state is invoked when a connection has been
# established successfully.  It replaces the SocketFactory wheel with
# a ReadWrite wheel.  The new wheel generates different events.

sub client_connected {
  my ($heap, $socket) = @_[HEAP, ARG0];

  die "possible filehandle leak" if fileno($socket) > 63;
  DEBUG && print "Client $heap->{'serial'} is connected.\n";
                                        # switch to read/write behavior
  $heap->{'wheel'} = POE::Wheel::ReadWrite->new(
    Handle     => $socket,                 # read and write on this socket
    Driver     => POE::Driver::SysRW->new, # using sysread and syswrite
    Filter     => POE::Filter::Line->new,  # and parsing I/O as lines
    InputEvent => 'receive',               # generating this event on input
    ErrorEvent => 'error',                 # generating this event on error
  );

  shutdown($socket, 1);
}

#------------------------------------------------------------------------------
# This state is invoked by the ReadWrite wheel to process complete
# chunks of input.

sub client_receive {
  my ($heap, $line) = @_[HEAP, ARG0];
  DEBUG && print "Client $heap->{'serial'} received: $line\n";
}

#------------------------------------------------------------------------------
# This state is invoked by both the SocketFactory and the ReadWrite
# wheels when an error occurs.

sub client_error {
  my ($heap, $operation, $errnum, $errstr) = @_[HEAP, ARG0, ARG1, ARG2];
  if (DEBUG) {
    if ($errnum) {
      print( "Client $heap->{'serial'} encountered ",
             "$operation error $errnum: $errstr\n"
           );
    }
    else {
      print "Client $heap->{'serial'} the server closed the connection.\n";
    }
  }
                                        # removing the wheel stops the session
  delete $heap->{'wheel'};
}

#------------------------------------------------------------------------------
# Catch and log signals.  Never handle them.

sub client_signals {
  my ($heap, $signal_name) = @_[HEAP, ARG0];
  DEBUG && print "Client $heap->{'serial'} caught SIG$signal_name\n";
                                        # doesn't handle SIGINT, so it can stop
  return 0;
}

###############################################################################
# This is a client pool session.  It ensures that at least five
# clients are interacting with the server at any given time.
# Actually, there are brief periods where only four clients are
# connected.

#------------------------------------------------------------------------------
# This is a regular Perl sub that helps create new client pools.  It's
# not an event handler.

###############################################################################
# This is a single server session.  It is spawned by the daytime
# server to handle incoming connections.

#------------------------------------------------------------------------------
# This is a regular Perl sub that helps create new sessions.  It's not
# an event handler.

sub session_create {
  my ($handle, $peer_host, $peer_port) = @_;
                                        # create the session
  POE::Session->create(
    inline_states => {
      _start  => \&session_start,
      _stop   => \&session_stop,
      receive => \&session_receive,
      flushed => \&session_flushed,
      error   => \&session_error,
      signals => \&session_signals,
      _child  => sub {},
      _parent => sub {},
    },

    # ARG0, ARG1, ARG2
    args => [ $handle, $peer_host, $peer_port ]
  );
}

#------------------------------------------------------------------------------
# Accept POE's standard _start event, and start transacting with the
# client.

sub session_start {
  my ($kernel, $heap, $handle, $peer_host, $peer_port) =
    @_[KERNEL, HEAP, ARG0, ARG1, ARG2];
                                        # make the address printable
  $peer_host = inet_ntoa($peer_host);
  DEBUG && print "Session with $peer_host $peer_port is starting.\n";
                                        # watch for SIGINT
  $kernel->sig('INT', 'signals');
                                        # record the client info for later
  $heap->{'host'} = $peer_host;
  $heap->{'port'} = $peer_port;
                                        # start reading and writing
  $heap->{'wheel'} = POE::Wheel::ReadWrite->new(
    Handle       => $handle,                 # on the client's socket
    Driver       => POE::Driver::SysRW->new, # using sysread and syswrite
    Filter       => POE::Filter::Line->new,  # and parsing I/O as lines
    InputEvent   => 'receive',               # generating this event on input
    ErrorEvent   => 'error',                 # generating this event on error
    FlushedEvent => 'flushed',               # generating this event on flush
  );
                                        # give the client the time of day
  $heap->{'wheel'}->put(
    "Hi, $peer_host $peer_port!  The time is: " . gmtime() . " GMT"
  );
}

#------------------------------------------------------------------------------
# Accept POE's standard _stop event.  This normally would clean up the
# session, but this program doesn't keep anything in the heap that
# needs to be cleaned up.

sub session_stop {
  my $heap = $_[HEAP];
  DEBUG && print "Session with $heap->{'host'} $heap->{'port'} has stopped.\n";
}

#------------------------------------------------------------------------------
# This state is invoked by the ReadWrite wheel whenever a complete
# request has been received.

sub session_receive {
  my ($heap, $line) = @_[HEAP, ARG0];
  DEBUG && print "Received from $heap->{'host'} $heap->{'port'}: $line\n";
}

#------------------------------------------------------------------------------
# This state is invoked when the ReadWrite wheel encounters an error.

sub session_error {
  my ($heap, $operation, $errnum, $errstr) = @_[HEAP, ARG0, ARG1, ARG2];
  DEBUG && print( "Session with $heap->{'host'} $heap->{'port'} ",
                  "encountered $operation error $errnum: $errstr\n"
                );
  delete $heap->{'wheel'};
}

#------------------------------------------------------------------------------
# This state is invoked when the ReadWrite wheel's output buffer
# becomes empty.  For a daytime server session, a flushed buffer means
# it's okay to close the connection.

sub session_flushed {
  my $heap = $_[HEAP];
  DEBUG && print "Output to $heap->{'host'} $heap->{'port'} has flushed.\n";
                                        # removing the wheel stops the session
  delete $heap->{'wheel'};
}

#------------------------------------------------------------------------------
# Catch and log signals, but never handle them.

sub session_signals {
  my ($heap, $signal_name) = @_[HEAP, ARG0];
  DEBUG && print( "Session with $heap->{'host'} $heap->{'port'} ",
                  "has received a SIG$signal_name\n"
                );
                                        # doesn't handle SIGINT, so it can stop
  return 0;
}

###############################################################################
# This is a generic daytime server.  Its only purpose is to listen on
# a socket, accept connections, and spawn daytime sessions to handle
# the connections.

#------------------------------------------------------------------------------
# This is a regular Perl sub that helps create new servers.  It's not
# an event handler.

sub server_create {
                                        # create the server
  POE::Session->create(
    inline_states => {
      _start         => \&server_start,
      _stop          => \&server_stop,
      accept_success => \&server_accept,
      accept_error   => \&server_error,
      signals        => \&server_signals,
      _child         => sub {},
      _parent        => sub {},
    }
  );
}

#------------------------------------------------------------------------------
# Accept POE's standard _start event.  Create a non-blocking server.

sub server_start {
  my ($kernel, $heap) = @_[KERNEL, HEAP];

  DEBUG && print "Daytime server is starting.\n";
                                        # set an alias so pool_stop can signal
  $kernel->alias_set('server');
                                        # watch for SIGINT and SIGQUIT
  $kernel->sig('INT', 'signals');
  $kernel->sig('QUIT', 'signals');
                                        # create a socket factory
  $heap->{'wheel'} = POE::Wheel::SocketFactory->new(
    BindAddress    => $server_addr,   # bind the listener to this address
    BindPort       => $server_port,   # bind the listener to this port
    Reuse          => 'yes',          # and reuse the socket right away
    SuccessEvent   => 'accept_success', # generate this event for connections
    FailureEvent   => 'accept_error',   # generate this event for errors
  );
}

#------------------------------------------------------------------------------
# Accept POE's standard _stop event.  This normally would clean up the
# session, but this program doesn't keep anything in the heap that
# needs to be cleaned up.

sub server_stop {
  my $heap = $_[HEAP];
  DEBUG && print "Daytime server has stopped.\n";
}

#------------------------------------------------------------------------------
# This state is invoked by the SocketFactory when an error occurs.

sub server_error {
  my ($operation, $errnum, $errstr) = @_[ARG0, ARG1, ARG2];
  DEBUG
    && print "Daytime server encountered $operation error $errnum: $errstr\n";
}

#------------------------------------------------------------------------------
# The SocketFactory invokes this state when a new client connection
# has been accepted.  The parameters include the client socket,
# address and port.

sub server_accept {
  my ($handle, $host, $port) = @_[ARG0, ARG1, ARG2];
                                        # spawn a server session
  die "possible filehandle leak" if fileno($handle) > 63;
  &session_create($handle, $host, $port);
}

#------------------------------------------------------------------------------
# Catch and log signals, but never handle them.

sub server_signals {
  my $signal_name = $_[ARG0];
  DEBUG && print "Daytime server caught SIG$signal_name\n";
                                        # doesn't handle SIGINT, so it can stop
  return 0;
}

###############################################################################
# Start the daytime server and a pool of clients to transact with it.

&server_create();
#&pool_create();

$poe_kernel->run();

exit;
