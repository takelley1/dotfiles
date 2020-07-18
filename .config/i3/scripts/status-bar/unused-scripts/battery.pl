#!/usr/bin/env perl

# Status bar script for obtaining the current battery charge level.

# Copyright 2014 Pierre Mavro <deimos@deimos.fr> and Vivien Didelot <vivien@didelot.org>
# Licensed under the terms of the GNU GPL v3, or any later version.
#
# The color will gradually change for a percentage below 85%, and the urgency
# (exit code 33) is set if there is less that 5% remaining.

use strict;
use warnings;
use utf8;
use Sys::Hostname;

my $acpi;
my $status;
my $percent;
my $full_text;
my $host;
my $bat_number = $ENV{BAT_NUMBER} || 0;
my $label = $ENV{LABEL} || "";
$host = hostname;

# Don't run on hosts that don't have batteries.
if ($host eq 'tethys') {
    exit(0);
}

# read the first line of the "acpi" command output
open (ACPI, "acpi -b 2>/dev/null | grep 'Battery $bat_number' |") or die;
$acpi = <ACPI>;
close(ACPI);

# Fail on unexpected output.
if (not defined($acpi)) {
    # Don't print anything to stderr if there is no battery.
    exit(0);
}
elsif ($acpi !~ /: ([\w\s]+), (\d+)%/) {
	die "$acpi\n";
}

$status = $1;
$percent = $2;
$full_text = "$label$percent%";

if ($status eq 'Charging') {
    $full_text .= ' CHRG';
}

if ($acpi =~ /(\d\d:\d\d):/) {
	$full_text .= " ($1)";
}

# Print text.
print " $full_text\n";

# Consider color only on discharge.
if ($status eq 'Discharging') {

	if ($percent < 10) {
		print "#FF0000\n";
	} elsif ($percent < 20) {
		print "#FFAE00\n";
	#} elsif ($percent < 60) {
	        #print "#FFF600\n";
        #} elsif ($percent < 85) {
		#print "#A8FF00\n";
	}
}

exit(0);
