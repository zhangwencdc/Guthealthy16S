#!/usr/bin/perl
use strict;
#use warnings;

my $file=$ARGV[0];#dada2_counts.taxon.species.txt

open(FILE,$file);
my $line=<FILE>;chomp $line;
my @name=split"\t",$line;
my $sample_n=@name;
$sample_n=$sample_n-7;
my %kingdom;my %phylum;my %class; my %order; my  %family;my  %genus;my %species;my %asv;my %sum;my %asvn;my %asvseq;
my $num=0;my $asv;
while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	unless($a[0]=~/A|T|G|C/){next;}
	my $c=sub_cr($a[0]);
	if(exists $asvseq{$c}){
		$asv=$asvseq{$c};
		
	}else{
	$num++;
	$asv="ASV".$num;
	$asvn{$asv}=$a[0];
	$asvseq{$a[0]}=$asv;
	print ">$asv\n$a[0]\n";
	}
	my $s=pop @a;
	my $g=pop @a;my @gg=split" ",$g;$g=$gg[0];my @ggg=split"_",$g;$g=$ggg[0];
	my $f=pop @a;
	my $o=pop @a;
	my $c=pop @a;
	my $p=pop @a;
	my $k=pop @a;
	unless($s eq "NA"){
	$s=$g." ".$s;}
	foreach  (1..($sample_n-1)) {
		my $read=$a[$_];
		unless($read>=5){next;} ##仅考虑5条read以上
		$kingdom{$k}{$name[$_]}+=$read;
		$phylum{$p}{$name[$_]}+=$read;
		$class{$c}{$name[$_]}+=$read;
		$order{$o}{$name[$_]}+=$read;
		$family{$f}{$name[$_]}+=$read;
		$genus{$g}{$name[$_]}+=$read;
		$species{$s}{$name[$_]}+=$read;
		$asv{$asv}{$name[$_]}+=$read;
		$sum{$name[$_]}+=$read;
	}
}
close FILE;

open(OUT,">Kingdom.txt");
my @k=keys %kingdom;
print OUT "Sample\t";
foreach  (1..($sample_n-1)) {
	unless($sum{$name[$_]}>0){next;}
	print OUT "$name[$_]\t";
}
print OUT  "\n";
foreach my $k (@k) {
	print OUT "$k\t";
	foreach  (1..($sample_n-1)) {
		unless($sum{$name[$_]}>0){next;}
		my $value=$kingdom{$k}{$name[$_]}/$sum{$name[$_]};
		print OUT "$value\t";
	}
	print OUT "\n";
}

close OUT;

open(OUT,">Phylum.txt");
my @p=keys %phylum;
print OUT "Sample\t";
foreach  (1..($sample_n-1)) {
	unless($sum{$name[$_]}>0){next;}
	print OUT "$name[$_]\t";

}
print OUT  "\n";my %tp;my %tpv;
foreach my $p (@p) {
	print OUT "$p\t";
	foreach  (1..($sample_n-1)) {
		unless($sum{$name[$_]}>0){next;}
		my $value=$phylum{$p}{$name[$_]}/$sum{$name[$_]};
		print OUT "$value\t";
		if($value>=$tpv{$name[$_]}){$tpv{$name[$_]}=$value;$tp{$name[$_]}=$p;}
		
	}
	print OUT "\n";
}

close OUT;

open(OUT,">Genus.txt");
my @g=keys %genus;
print OUT "Genus\t";
foreach  (1..($sample_n-1)) {
	unless($sum{$name[$_]}>0){next;}
	print OUT "$name[$_]\t";
}
print OUT  "\n";my %tg;my %tgv;
foreach my $g (@g) {
	my $gn=0;
	foreach  (1..($sample_n-1)) {
		unless($sum{$name[$_]}>0){next;}
		if($genus{$g}{$name[$_]}>0){$gn++};
		
		
	}
	unless($gn>=5){next;}
	print OUT "$g\t";
	foreach  (1..($sample_n-1)) {
		unless($sum{$name[$_]}>0){next;}
		my $value=$genus{$g}{$name[$_]}/$sum{$name[$_]};
		print OUT "$value\t";
		if($value>=$tgv{$name[$_]}){$tgv{$name[$_]}=$value;$tg{$name[$_]}=$g;}
	}
	print OUT "\n";
}

close OUT;

open(OUT,">Species.txt");
my @s=keys %species;
print OUT "Sample\t";
foreach  (1..($sample_n-1)) {
	unless($sum{$name[$_]}>0){next;}
	print OUT "$name[$_]\t";
}
print OUT  "\n";my %ts;my %tsv;
foreach my $s (@s) {
	print OUT "$s\t";
	foreach  (1..($sample_n-1)) {
		unless($sum{$name[$_]}>0){next;}
		my $value=$species{$s}{$name[$_]}/$sum{$name[$_]};
		print OUT "$value\t";
		if($value>=$tsv{$name[$_]}){$tsv{$name[$_]}=$value;$ts{$name[$_]}=$s;}
	}
	print OUT "\n";
}

close OUT;

open(OUT,">ASV.txt");
my @a=sort keys %asv;
print OUT "Sample\t";
foreach my $a (@a) {
	
	print OUT "$a\t";
}
print OUT  "\n";my %ta;my %tav;

foreach  (1..($sample_n-1)) {
		
		unless($sum{$name[$_]}>0){next;}print OUT "$name[$_]\t";
		foreach my $a (@a) {
			#print OUT "$a\t";
		my $value=$asv{$a}{$name[$_]}/$sum{$name[$_]};
		print OUT "$value\t";
		if($value>=$tav{$name[$_]}){$tav{$name[$_]}=$value;$ta{$name[$_]}=$a;}
		}
	print OUT "\n";
}

close OUT;

open(OUT,">Top.csv");
my @key=sort keys %tpv;
print OUT "Sample,Phylum,Genus,Species,ASV\n";
foreach my $key (@key) {
	print OUT "$key,$tp{$key},$tg{$key},$ts{$key},$ta{$key}\n";
}
close OUT;


sub sub_cr
{
	my $seq=shift;
	my $rev=reverse $seq;
	my $final;
	my $len=length $seq;
	foreach  (0..($len-1)) {
		my $site=substr($rev,$_,1);
		if($site=~/A|a/){
			$final=$final."T";
		}elsif($site=~/T|t/){
			$final=$final."A";
		}elsif($site=~/G|g/){
			$final=$final."C";
		}elsif($site=~/C|c/){
			$final=$final."G";
		}else{
			$final=$final.$site;
		}
	}
	return $final;
}