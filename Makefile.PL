use 5.008;
use ExtUtils::MakeMaker 7.12;

WriteMakefile(
    NAME              => 'UV',
    VERSION_FROM      => 'lib/UV.pm',
    PREREQ_PM         => {'ExtUtils::MakeMaker' => '7.12'}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/UV.pm',
    AUTHOR            => 'Chase Whitener <capoeirab@cpan.org>',
    LICENSE           => 'perl',
    CCFLAGS           => '-Wall -std=c99',
    OPTIMIZE          => '-O3',
    LIBS              => ['-luv'], # e.g., '-lm'
    DEFINE            => '-I ../..', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    XSMULTI           => 1,
);
