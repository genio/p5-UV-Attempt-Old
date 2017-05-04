use 5.008;
use ExtUtils::MakeMaker 7.12;

WriteMakefile(
    NAME              => 'UV',
    VERSION_FROM      => 'lib/UV.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {'ExtUtils::MakeMaker' => '7.12'}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/UV.pm', # retrieve abstract from module
    AUTHOR            => 'Chase Whitener <cwhitener@(none)>',
    LICENSE           => 'perl',
    CCFLAGS           => '-Wall -std=c99',
    OPTIMIZE          => '-O3',
    LIBS              => ['-luv'], # e.g., '-lm'
    DEFINE            => '-I ../..', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    XSMULTI           => 1,
);
