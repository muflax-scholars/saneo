#!/usr/bin/perl
# Copyright muflax <muflax@gmail.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>
use 5.010;
use strict;
use warnings;

my %freq;

for (@ARGV) {
    my $sum;
    my %sub_freq;
    open F, "<", $_;
    while (<F>) {
        my ($c, $f) = split / /;
        $sum += $f;
        $sub_freq{$c} = $f;
    }
    for (keys %sub_freq) {
        $freq{$_} = $sub_freq{$_} / $sum;
    }
}

for (sort {$freq{$a} <=> $freq{$b}} keys %freq) {
    printf "%s %0.3f\n", $_, $freq{$_};
}
