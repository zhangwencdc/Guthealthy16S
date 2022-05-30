#!/usr/bin/perl
use strict;
#use warnings;

###find Bloomµã
my $file=$ARGV[0]; ####taxa.phylum.Abd
open(FILE,$file);
my $line=<FILE>;
chomp $line;
my @name=split"\t",$line;
my $num=@name; my %sum;my %num; my %taxon; my %per;
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	my $sample=$a[0];
	my $people=substr($sample,0,2);
	my $time=substr($sample,3,length($sample)-3);
	foreach  (1..($num-1)) {
		$sum{$people}{$name[$_]}+=$a[$_];
		$num{$people}{$name[$_]}++;
		$taxon{$name[$_]}++;
		my $taxon=$people."_".$name[$_];
		print "$time,$taxon,$a[$_]\n";
		$per{$time}{$taxon}=$a[$_];
	}
}
close FILE;

my @taxon=keys %taxon;
my @people=keys %sum;
my %avg;
foreach my $people (@people) {
	foreach my $taxon (@taxon) {
		if($sum{$people}{$taxon}>0){
			$avg{$people}{$taxon}=$sum{$people}{$taxon}/$num{$people}{$taxon};
		}
	}
}


open(FILE,$file);
my $line=<FILE>;
chomp $line;
open(OUT,">$file.bloom");
print OUT "SampleID,People,Taxon,Percentage,Avg for people\n";
my %bloom;
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	my $sample=$a[0];
	my $people=substr($sample,0,2);
	foreach  (1..($num-1)) {
		unless($avg{$people}{$name[$_]}>=0.001){next;}
		if($a[$_]>=5*$avg{$people}{$name[$_]}){
			print OUT "$sample,$people,$name[$_],$a[$_],$avg{$people}{$name[$_]}\n";
			my $bloom=$people."_".$name[$_];
			$bloom{$bloom}++;
		}
	}
}
close OUT;
close FILE;

open(OUT,">$file.bloom.matrix.csv");
print OUT ",";
foreach  (1..37) {
	my $a=$_;
	if(length($a)==1){$a="0".$_;}
	print "$a\t";print OUT "T$a,";
}
print OUT "\n";
my @bloom=sort keys %bloom;
foreach my $bloom (@bloom) {
	print OUT "$bloom,";
	foreach  (1..37) {
	my $a=$_;
	if(length($a)==1){$a="0".$_;}
	if(exists $per{$a}{$bloom}){print OUT "$per{$a}{$bloom},";}else{print OUT ",";}
	}
	print OUT "\n";
}