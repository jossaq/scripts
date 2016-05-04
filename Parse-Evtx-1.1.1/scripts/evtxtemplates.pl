#!/usr/bin/perl

=encoding utf8

=head1 NAME

 evtxtemplates.pl - prints a list of XML templates in a Windows Vista event log file

=head1 SYNOPSIS

 evtxtemplates.pl System.evtx

=head1 DESCRIPTION

This program prints a list of XML templates in a Windows Vista (or later)
event log file.

For more information on Vista event logs and future releases of this package
please see
L<http://computer.forensikblog.de/en/topics/windows/vista_event_log/>

=head1 COPYRIGHT

Copyright (c) 2007-2011 by Andreas Schuster

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.

=cut

# Version 1.0.7

use strict;
# use warnings;
# use diagnostics;

use Parse::Evtx;
use Carp::Assert;
use IO::File 1.14;
use Digest::MD5 qw( md5_hex );
use Getopt::Long;

my $opt_hex = 0;
my $opt_values = 1;
my $opt_warn = 1;

GetOptions(
	"hex!" => \$opt_hex,
    "values!" => \$opt_values,
	"warn!" => \$opt_warn,
);

my %templates;
my %seen;
my $cntchunk = 0;
my ($address, $template);
my ($xml, $guid, $md5sum);

my $fh = IO::File->new(shift, "r");
if (!defined $fh) {
	print "Unable to open file: $!\n";
	exit 1;	
}

assert(defined $fh);
my $evtx = Parse::Evtx->new('FH' => $fh);
assert(defined $evtx);
binmode(STDOUT, ":utf8");

my $chunk = $evtx->get_first_chunk();
while (defined $chunk) {
	$chunk->collect_templates();
	foreach $address ($chunk->get_templates()) {
		$template = $chunk->get_template($address);
		assert(defined $template);	
		$xml = $template->get_xml(
			'Substitution' => 0,
			'Values' => $opt_values,
		);
		$guid = $template->get_template_guid();
		$md5sum = md5_hex($xml);
		if (defined $seen{$guid}) {
			# we've already seen this guid
			# skip, if we already know the content, too
			next if ($md5sum eq $seen{$guid});
			# warn about the GUID not being unique
			print "WARNING: The following GUID appears not to be unique!\n" if ($opt_warn);
		}
		# print template
		printf "Template %s at chunk %d, offset 0x%04x:%s\n\n", $guid, $cntchunk, $address, $xml;
		printf"%s\n", $template->get_hexdump() if ($opt_hex);
		# remember GUID
		$seen{$guid} = $md5sum;
	}
	$chunk = $evtx->get_next_chunk();
	$cntchunk++;
	# printf "NEW chunk: %d\n", $cntchunk;
}

$fh->close();
