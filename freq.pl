#!/usr/bin/perl
# Copyright muflax <muflax@gmail.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>
use 5.010;
use strict;
use warnings;

my %freq;

while (<>) {
    $freq{$_}++ for unpack "(A1)*", $_;
}

for (sort {$freq{$a} <=> $freq{$b}} grep {/[[:ascii:]]/} keys %freq) {
    say "$_ ", $freq{$_};
}
