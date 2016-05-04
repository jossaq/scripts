#!/usr/bin/perl

=encoding utf8

=head1 NAME

 evtxdump.pl - converts Windows Vista event log files into textual XML

=head1 SYNOPSIS

 evtxdump.pl System.evtx > System.xml

=head1 DESCRIPTION

This program converts a Windows Vista (or later) event log
file into XML.

For more information on Vista event logs and future releases of this
package please see
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

# Version 1.0.4

use strict;
# use warnings;
# use diagnostics;

use Parse::Evtx;
use Parse::Evtx::Chunk;
use Carp::Assert;
use IO::File 1.14;


sub header {
	return "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\" ?>\n<Events>";
};

sub footer {
	return "</Events>\n";
};


# main program

my $fh = IO::File->new(shift, "r");
if (!defined $fh) {
	print "Unable to open file: $!\n";
	exit 1;	
}

assert(defined $fh);
my $file;
$file = Parse::Evtx->new('FH' => $fh);
if (!defined $file) {
    # if it's not a complete file, is it a chunk then?
    $file = Parse::Evtx::Chunk->new('FH' => $fh );
};
assert(defined $file);
binmode(STDOUT, ":utf8");
select((select(STDOUT), $|=1)[0]);

print header();
my $event = $file->get_first_event();
while (defined $event) {
	print $event->get_xml();
	$event = $file->get_next_event();
};
print footer();

$fh->close();
