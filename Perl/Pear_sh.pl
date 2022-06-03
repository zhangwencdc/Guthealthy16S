#!/usr/bin/perl
use strict;
use warnings;

my $file=$ARGV[0];#sample.list
my $outdir=$ARGV[1];#

my $shell="/share/nas4/zhangwen/Time/bin/illumina_Stat_QCfilter-v2020.pl";


open(FILE,$file);
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	if($line=~/^Sample/){next;}
	my @a=split"\t",$line;
	system "perl $shell $a[6] $a[7] $a[0] $outdir\n";
}
close FILE;