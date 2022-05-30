#!/usr/bin/perl
use strict;
use warnings;

my $input=$ARGV[0];#taxa.genus.Abd

my $out=$ARGV[1];

open(FILE,$input);
my $name=<FILE>;chomp $name;
my @name=split"\t",$name;my %strain;my %core;my %j; my %strain_sum;
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	my $n=@a;
	my $strain=substr($a[0],0,2);
	unless($strain=~/[0-9a-zA-Z]/){next;}
	$strain_sum{$strain}++;
	foreach  (1..($n-1)) {
		my $n=$name[$_];
		if($a[$_]>0.00001){$strain{$n}{$strain}+=$a[$_];$j{$n}{$strain}++;}  ####仅考虑大于十万分之一菌属
	}

}
close FILE;
open(OUT,">$out");
my @key=keys %j;
my @people=sort keys %strain_sum;

my %key;
foreach my $people (@people) {
my $strain_sum=$strain_sum{$people};
foreach my $key (@key) {
	if($j{$key}{$people}==$strain_sum){print OUT "$people,$key,";
		my $avg=$strain{$key}{$people}/$strain_sum;
		print OUT "$avg\n";

		$key{$key}{$people}=$avg;
	}
}

}

my @key=keys %key;
print OUT "\nAbundance\n";
print OUT "Genus,";
foreach my $key (@key) {
	print OUT "$key,";
}
print OUT "\n";
foreach my $people (@people) {
	print OUT "$people,";
	foreach my $key (@key) {
		print OUT "$key{$key}{$people},";
	}
	print OUT "\n";
}


print OUT "\n样本中含有的数量/总样本数\n";
print OUT "Genus,";
foreach my $key (@key) {
	print OUT "$key,";
}
print OUT "\n";
foreach my $people (@people) {
	print OUT "$people,";
	foreach my $key (@key) {
		my $t=sprintf "%.2f",$j{$key}{$people}/$strain_sum{$people};
		print OUT "$j{$key}{$people}/$strain_sum{$people}:$t,";
	}
	print OUT "\n";
}
close OUT;