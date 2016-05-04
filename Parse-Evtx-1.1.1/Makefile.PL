use ExtUtils::MakeMaker;
WriteMakefile (
    NAME => "Parse::Evtx",
    VERSION_FROM => "lib/Parse/Evtx.pm",
    PREREQ_PM => {
        "Carp::Assert" => 0,
        "Data::Hexify" => 0,
        "DateTime" => 0,
        "Digest::CRC" => 0,
    },
    EXE_FILES => [
        "scripts/evtxdump.pl", 
        "scripts/evtxinfo.pl", 
        "scripts/evtxtemplates.pl",
    ],
);
