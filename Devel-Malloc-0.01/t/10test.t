# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
BEGIN { plan tests => 4 };
use strict;
use Devel::Malloc;

sub malloc_free_test {
  my ($size) = @_;

  my $address = _malloc($size);
  if ($address)
  {
        _free($address);
        return 1;
  } else {
        return 0; 
  }
}

sub malloc_memset_test {
  my ($str) = @_;

  my $address = _malloc(length($str));
  if ($address)
  {
        my $address2 = _memset($address, $str, length($str));
        _free($address);
        return $address == $address2;
  } else {
        return 0;
  }
}

sub malloc_memget_test {
  my ($str) = @_;

  my $address = _malloc(length($str));
  if ($address)
  {
        _memset($address, $str, length($str));
        my $str2 = _memget($address, length($str));
        _free($address);
        return $str eq $str2;
  } else {
        return 0;
  }
}

sub malloc_memget_nolen_test {
  my ($str) = @_;

  my $address = _malloc(length($str));
  if ($address)
  {
        _memset($address, $str);
        my $str2 = _memget($address, length($str));
        _free($address);
        return $str eq $str2;
  } else {
        return 0;
  }
}


# 1
ok(malloc_free_test(1024));
ok(malloc_memset_test("test"));
ok(malloc_memget_test("test2"));
ok(malloc_memget_nolen_test("test3"));
