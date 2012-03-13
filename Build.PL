use strict;
use warnings FATAL => 'all';
use Module::Build;

my $class = Module::Build->subclass(
    class => 'My::Builder',
    code => q{
        sub ACTION_docs {
            use Pod::Readme;
            use Pod::Select;
            
            my $self = shift;
            
            podselect({ -output => 'README.pod' },
                'lib/Test/Perl/Metrics/Lite.pm');
            
            my $parser = Pod::Readme->new();
            $parser->parse_from_file('README.pod', 'README');
            
            return $self->SUPER::ACTION_docs;
        }
    }
);

my $build = $class->new(
    name        => 'Test-Perl-Metrics-Lite',
    module_name => 'Test::Perl::Metrics::Lite',
    dist_author          => 'Dann',
    dist_version_from    => 'lib/Test/Perl/Metrics/Lite.pm',
    license              => 'perl',
    recursive_test_files => 1,
    dynamic_config       => 0,
    build_requires       => { 
        'Test::More' => '0.88' 
    },
    configure_requires   => { 
        'Module::Build' => '0.38' 
    },
    requires             => {
        'perl'                => '5.008001',
        'Perl::Metrics::Lite' => '0.08',
        'List::MoreUtils'     => '0',
    },
    no_index    => { 'directory' => [ 'inc', 't', 'xt' ] },
    test_files => ( -d '.git' || $ENV{RELEASE_TESTING} ) ? 't/ xt/' : 't/',
    create_readme  => 1,
    create_license => 1,
    meta_merge     => {
        resources => { 
            'repository' => 'http://github.com/dann/p5-test-perl-metrics-lite'
        }
    },
);
$build->create_build_script();
