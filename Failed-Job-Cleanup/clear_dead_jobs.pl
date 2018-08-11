#!/usr/bin/perl

chomp($totalpages = `tower-cli job list --status=failed | egrep Page`);
$totalpages =~ s/^.*\(Page 1 of ([0-9]+)\..*$/$1/g;

print "CLEARING FAILED JOBS from $totalpages pages of job logs.\n";

if (! $totalpages){
		&clear_page(1);
}else{
	while ($thispage < $totalpages){
		$thispage++;
		print "CLEARING PAGE $thispage\n";
		&clear_page($thispage);
	}
}



sub clear_page(){
	my $page = shift(@_);
	my ($job, $jobid);

	my @deadjobs = split(/\n/,`tower-cli job list --status=failed --page=$page`);
	foreach $job(@deadjobs){
		$job =~ s/^\s+//g;
		next if ($job !~ /^[0-9]/);
		($jobid,undef) = split(/\s+/,$job);
		print "tower-cli job delete $jobid\n";
		system("tower-cli job delete $jobid");
	}
}
