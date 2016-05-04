This is EvtxParser, a parser framework for Microsoft Windows Vista 
event log files in their native binary (evtx) form.

Please see my blog postings at 
<http://computer.forensikblogde/en/topics/windows/vista_event_log/> 
to learn more about the new Windows Event Logging service and its file
format. Further information is also available from my presentation
for the 2007 Digital Forensics Research Conference (DFRWS):
- paper: http://www.dfrws.org/2007/proceedings/p65-schuster.pdf
- slides: http://www.dfrws.org/2007/proceedings/p65-schuster_pres.pdf


The parser still is in a proof-of-concept stage. I used it, and I am
still using it, to dive into the unknown of evtx files. The framework
consists of classes for overall structures like the file, chunks and single
records as well as classes for data types and syntactic elements of the 
binary XML which is used to describe an event.

If you want to help me to improve this program, then please report bugs 
of all sort, but especially any information about data types and tokens 
that still might be missing to: <bugs-evtxparser@forensikblog.de>. I much
appreciate your help and your comments.


The framework comes with three sample console applications, evtxdump.pl, evtxtemplates.pl, and evtxinfo.pl.

evtxdump.pl transforms a binary event log file into plain text XML. In 
contrary to the event logging service it can process single chunks, too.

evtxtemplates.pl doesn't resolve substitution instructions within an event 
record. Instead it prints some information about the XML template which is 
used in the process. The main purpose of this tool was to study the 
substitution mechanism.

evtxinfo.pl displays some information about the evtx file header and chunks.
It also calculates the individual CRC32 check sums.

This framework relies on the DateTime module, see
<http://search.cpan.org/dist/DateTime-0.36/lib/DateTime.pm>. Unfortunately 
this module does not ship with ActiveState Perl. However, Dave Rolsky 
provides this and some other modules in his alternate repository at 
<http://www.bribes.org/perl/ppmdir.html>.

On other platforms you may easily install any missing modules by means of
the CPAN shell:
$ perl -MCPAN -e shell
cpan> install Carp::Assert
cpan> install DateTime
cpan> install Digest::CRC
cpan> install Data::Hexify

In order to install scripts and the library, please run the following commands:

$ perl Makefile.pl
$ make
$ sudo make install


I distribute all of these programs and library files in the hope that they 
will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
Public License for more details.


I wish to thank the following people for their contribution to EvtxParser:
- Christopher Ahearn
- Harlan Carvey
- Michael Felber
- Adrian Forschner
- Kristinn Gudjonsson
- Rob Hulley
- Richard W. M. Jones
- Roberto De Vivo
- Mark Woan

Andreas Schuster