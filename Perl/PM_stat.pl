#!/usr/bin/perl
use strict;
use warnings;

my $dir=$ARGV[0]; #parallel/Single_Sample/

my @file=glob "$dir/*/Analysis_Report.txt";
print "Sample\tSequences\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\tOTU\n";
foreach my $file (@file) {
	my @f=split"/",$file;
	pop @f;
	my $name=pop @f;
	print "$name\t";
	open(FILE,$file);
	while(1){
		my $line=<FILE>;
		unless($line){last;}
		chomp $line;
		if($line=~/^rRNA Sequence Number/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
		if($line=~/^Kingdom/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
		if($line=~/^Phylum/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
		if($line=~/^Class/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
		if($line=~/^Order/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
		if($line=~/^Family/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
		if($line=~/^Genus/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
		if($line=~/^Species/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
		if($line=~/OTU/){
			my @a=split " ",$line;my $num=pop @a;
			print "$num\t";
		}
	}
	print "\n";
	close FILE;
}