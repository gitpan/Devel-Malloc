package Devel::Malloc;

use 5.006;
use strict;
use Exporter 'import';
our @ISA = qw(Exporter);
our @EXPORT = qw(_malloc _memset _memget _free);
our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Devel::Malloc', $VERSION);

1;
__END__

=head1 NAME

Devel::Malloc - Low-level memory operations for real-time inter-thread communication.

=head1 SYNOPSIS

 use warnings;
 use strict;
 use POSIX;
 use POSIX::RT::Signal qw(sigwaitinfo sigqueue);
 use Devel::Malloc;
 use threads;

 POSIX::sigprocmask(POSIX::SIG_BLOCK, POSIX::SigSet->new(&POSIX::SIGRTMIN));
 my $thr = threads->create(\&_thread);

 sub _thread
 {
    my $sigset = POSIX::SigSet->new(&POSIX::SIGRTMIN);
    my $info=sigwaitinfo($sigset);
    my $str = _memget($info->{value}, 4);
    print $str."\n";
    _free($info->{value});
 }

 my $address = _malloc(4);
 _memset($address, "TEST", 4);
 sigqueue($$, &POSIX::SIGRTMIN, $address);
 $thr->join();

=head1 DESCRIPTION

The _malloc() function allocates size bytes and returns memory address
to the allocated memory. You can store strings to memory using _memset() and
retrieve them using _memget(). The _free() function deallocates memory.

Memory address returned by _malloc() can be used between threads.

I hope you enjoyed it.

=head2 EXPORT

 $address = _malloc(size);
 
 $address = _memset($address, $sv, $size = 0);
 
 $sv = _memget($address, $size);
 
 _free($address)

=head1 AUTHOR

Yury Kotlyarov C<yura@cpan.org>

=head1 SEE ALSO

L<POSIX::RT::Signal>, L<POSIX>, L<threads>

=cut
