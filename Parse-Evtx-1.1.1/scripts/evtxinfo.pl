#!/usr/bin/perl

=encoding utf8

=head1 NAME

 evtxinfo.pl - report info about a Windows Vista event log file

=head1 SYNOPSIS

 evtxinfo.pl System.evtx

=head1 DESCRIPTION

This program reports information about a Windows Vista (or later)
event log file.

For more information on Vista event logs and future releases of this package
please see
L<http://computer.forensikblog.de/en/topics/windows/vista_event_log/>

=head1 COPYRIGHT

Copyright (c) 2009-2011 by Andreas Schuster

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

# Version 1.0.8

use Parse::Evtx 1.0.8;
use Parse::Evtx::Chunk 1.0.4;
use Parse::Evtx::Const 1.0.4 qw(:checks :hdrflags);

use Carp::Assert;
use IO::File 1.14;

sub print_flags {
	my $flags = shift;
	my $mask = shift;
	my $name = shift;
	my $str0 = shift;
	my $str1 = shift;

	printf("%16s: %s\n",
		$name,
		($flags & $mask) ? $str1 : $str0
	);
}

my $ITEM = '%-16s:';


# open file

my $fh = IO::File->new(shift, "r");
if (!defined $fh) {
	print "Unable to open file: $!\n";
	exit 1;
}

assert(defined $fh);
my $file;
$file = Parse::Evtx->new('FH' => $fh);
if (!defined $file) {
	print "Input is not an EVTX file.";
	exit 1;
}


# process file header

print "Information from file header:\n";
printf("$ITEM %d.%d\n", 
	"Format version",
	$file->{'VersionMajor'}, $file->{'VersionMinor'}
);
printf("$ITEM 0x%08x\n",
	"Flags",
	$file->{'Flags'}
);
# decode known flags
&print_flags($file->{'Flags'}, $EVTX_HDRFLAG_DIRTY, 'File is', 'clean', 'DIRTY');
&print_flags($file->{'Flags'}, $EVTX_HDRFLAG_FULL, 'Log is full', 'no', 'YES');
printf("$ITEM %d of %s\n",
	"Current chunk",
	$file->{'CurrentChunk'}+1,
	$file->{'ChunkCount'}
);
printf("$ITEM %d\n", 
	"Oldest chunk", 
	$file->{'OldestChunk'}+1
);
printf("$ITEM %s\n",
	"Next Record#",
	$file->{'NextRecord'}
);
# run checks on file header
my $status = $file->check();
printf("$ITEM %s\n", 
	"Check sum", 
	($status & $EVTX_CHECK_HEADERCRC) ? 'FAILED' : 'pass'
);


# process chunks

print "\nInformation from chunks:\n";
printf("%s %5s %-21s %-21s %-6s %-6s\n",
	' ', 
	'Chunk',
	'file (first/last)',
	'log (first/last)',
	'Header',
	'Data'
);
printf("%s %5s %21s %21s %6s %6s\n", 
	'-', '-'x5, '-'x21, '-'x21, '-'x6, '-'x6);

my $chunk = $file->get_first_chunk();
my $i = 0;
while (defined $chunk) {
	my $status = $chunk->check();
	$i++;
	
	# adjust indicator
	my $indicator = ' ';
	if ($file->{'CurrentChunk'}+1 == $i) {
		$indicator = '*';
	} elsif ($file->{'OldestChunk'}+1 == $i) {
		$indicator = '>';
	}
	
	printf("%s %5d %10s %10s %10s %10s %6s %6s\n",
		$indicator,
		$i,
		$chunk->{'NumFirst'}, 
		$chunk->{'NumLast'}, 
		$chunk->{'NumFirstFile'},
		$chunk->{'NumLastFile'},
		($status & $EVTX_CHECK_HEADERCRC) ? 'FAILED' : 'pass',
		($status & $EVTX_CHECK_DATACRC) ? 'FAILED' : 'pass'
	);
	$chunk = $file->get_next_chunk();
}

$fh->close();
