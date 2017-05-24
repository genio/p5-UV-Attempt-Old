use ExtUtils::MakeMaker 7.12;

WriteMakefile(
    NAME              => 'UV',
    VERSION_FROM      => 'lib/UV.pm',
    ABSTRACT_FROM     => 'lib/UV.pm',
    AUTHOR            => 'Chase Whitener <capoeirab@cpan.org>',
    LICENSE           => 'perl',
    CCFLAGS           => '-Wall -std=c99',
    OPTIMIZE          => '-O3',
    LIBS              => ['-luv'], # e.g., '-lm'
    DEFINE            => '-I ../.. -D_POSIX_C_SOURCE=200112', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    # OBJECT            => '$(O_FILES)',
    XSMULTI           => 1,
    MIN_PERL_VERSION  => "5.014",
    CONFIGURE_REQUIRES => {
        "ExtUtils::MakeMaker" => "7.12"
    },
    PREREQ_PM => {
        "Carp" => 0,
        "Exporter" => 0,
        "strict" => 0,
        "warnings" => 0,
    },
    TEST_REQUIRES => {
        "ExtUtils::MakeMaker" => "7.12",
        "Test::More" => "0.94"
    },
);
