#!/usr/bin/perl
use strict;
use warnings;

##计算每个Genus在某个人中存在的阳性样本比率

my $file=$ARGV[0];#taxa.genus.Abd
my $out=$ARGV[1];

my %g;
open(FILE,$file);
my $name=<FILE>;
chomp $name;
my @name=split"\t",$name;
while(1){
	my $l=<FILE>;
	unless($l){last;}
	chomp $l;
	my @a=split"\t",$l;
	my $sample=$a[0];
	my $n=@a;
	foreach  (1..($n-1)) {
		$g{$sample}{$name[$_]}=$a[$_];
	}
}

my @sample=keys %g;shift @name;
open(OUT,">$out");
print OUT "Genus,P1,P2,P3,P4,P5,P6,P7\n";
foreach my $name (@name) {
	print OUT "$name,";
	foreach  (1..7) {
		my $people=$_;
		my $num=0;my $total;
		foreach my $sample (@sample) {
			my $s=substr($sample,1,1);
			unless($s eq $people){next;}$total++;
			if(exists $g{$sample}{$name} && $g{$sample}{$name}>0){
				$num++;
			}
		}
		my $avg=$num/$total;
		print OUT "$avg,";
	}
	print OUT "\n";
}