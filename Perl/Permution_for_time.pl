#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw/shuffle/;

my $file=$ARGV[0];# Genus_bray_curtis.list.time

open(OUT,">$file.permution");
print OUT "People,Compair,Ture Avg Bray,Ture Avg Bray,Permution,Mix,Max,Percentage\n";
foreach  (1..7) {
	my $people="P".$_;
	my %true;
	
open(FILE,$file); my %time;my %bray; my %point;my $m1t;my $m1nt;my $y1t;my $y1nt;my $y2t;my $y2nt;my $y3t;my $y3nt;
	while(1){
	my $line=<FILE>;
	unless($line){last;}
	chomp $line;
	my @a=split"\t",$line;
	if($a[0] eq "ID"){next;}
	unless($a[2] eq $people){next;}
	$bray{$a[6]}{$a[7]}=$a[8];
	$time{$a[6]}=$a[4];$time{$a[7]}=$a[5];
	$point{$a[6]}++;$point{$a[7]}++;
			my $ta=$a[4];
				my $tb=$a[5];
				my $t;
				if($tb>=$ta){$t=$tb-$ta}else{$t=$ta-$tb;}
				if($t<=1){
					$m1nt++;$m1t+=$a[8];
				}elsif($t>1 && $t<=12){
					$y1nt++;$y1t+=$a[8];
				}elsif($t>12 && $t<=24){
					$y2nt++;$y2t+=$a[8];
				}elsif($t>24){
					$y3nt++;$y3t+=$a[8];
				}

	}
	close FILE;
	my $m1vt=$m1t/$m1nt;
		my $y1vt=$y1t/$y1nt;
		my $y2vt=$y2t/$y2nt;
		my $y3vt=$y3t/$y3nt;
		my $m1y1=$y1vt-$m1vt;
		my $y1y2=$y2vt-$y1vt;
		my $y2y3=$y3vt-$y2vt;
		my $m1y3=$y3vt-$m1vt;
	my @point=keys %point;
	my $point=@point;
	my @m1y1;my @y1y2;my @y2y3;my @m1y3;
	foreach  (1..1000) {
		my @new=shuffle @point;
		#print "$people $_ @new\n";
		my %new; my $m1;my $m1n;my $y1;my $y1n;my $y2;my $y2n;my $y3;my $y3n;
		foreach  (1..($point-1)) {
			my $a=$_-1;
			$new{$new[$a]}=$point[$a];
			foreach  (2..($point)) {
				my $b=$_-1;
				$new{$new[$b]}=$point[$b];
				if($a == $b){next;}
				my $ta=$time{$new[$a]};
				my $tb=$time{$new[$b]};
				my $t;
				if($tb>=$ta){$t=$tb-$ta}else{$t=$ta-$tb;}
				my $bray;
				if(exists $bray{$new{$new[$a]}}{$new{$new[$b]}}){
					$bray=$bray{$new{$new[$a]}}{$new{$new[$b]}};
				}elsif($bray{$new{$new[$b]}}{$new{$new[$a]}}){
					$bray=$bray{$new{$new[$b]}}{$new{$new[$a]}};
				}else{
					print "$new{$new[$b]},$new{$new[$a]},Nobray\n";
				}
				if($t<=1){
					$m1n++;$m1+=$bray;
				}elsif($t>1 && $t<=12){
					$y1n++;$y1+=$bray;
				}elsif($t>12 && $t<24){
					$y2n++;$y2+=$bray;
				}elsif($t>24){
					$y3n++;$y3+=$bray;
				}

			}

		}
		my $m1v=$m1/$m1n;
		my $y1v=$y1/$y1n;
		my $y2v=$y2/$y2n;
		my $y3v=$y3/$y3n;
		my $score=$y1v-$m1v;
		push @m1y1,$score;
		$score=$y2v-$y1v;
		push @y1y2,$score;
		$score=$y3v-$y2v;
		push @y2y3,$score;
		$score=$y3v-$m1v;
		push @m1y3,$score;
	}
	my @nm1y1=sort {$a<=>$b}@m1y1;
	my $num=@nm1y1;my $per=1;
	foreach (0..($num-2)) {
		if($m1y1>=$nm1y1[$_] && $m1y1<=$nm1y1[$_+1] ){
		$per=$_/($num-1);
		}
	}
	print OUT "$people,M1 vs Y1,$m1vt,$y1vt,$m1y1,$nm1y1[0],$nm1y1[$num-1],$per\n";
		my @ny1y2=sort {$a<=>$b}@y1y2;
	my $num=@ny1y2;my $per=1;
	foreach (0..($num-2)) {
		if($y1y2>=$ny1y2[$_] && $y1y2<=$ny1y2[$_+1] ){;
		$per=$_/($num-1);
		}
	}
	print OUT "$people,Y1 vs Y2,$y1vt,$y2vt,$y1y2,$ny1y2[0],$ny1y2[$num-1],$per\n";
		my @ny2y3=sort {$a<=>$b}@y2y3;
	my $num=@ny2y3;my $per=1;
	foreach (0..($num-2)) {
		if($y2y3>=$ny2y3[$_] && $y2y3<=$ny2y3[$_+1] ){
		$per=$_/($num-1);
		}
	}
	print OUT "$people,Y2 vs Y3,$y2vt,$y3vt,$y2y3,$ny2y3[0],$ny2y3[$num-1],$per\n";
		my @nm1y3=sort {$a<=>$b} @m1y3;
	my $num=@nm1y3;my $per=1;
	foreach (0..($num-2)) {
		if($m1y3>=$nm1y3[$_] && $m1y3<=$nm1y3[$_+1] ){
		$per=$_/($num-1);
		}
	}
	print OUT "$people,M1 vs Y3,$y2vt,$y3vt,$m1y3,$nm1y3[0],$nm1y3[$num-1],$per\n";
}