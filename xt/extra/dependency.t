use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Test::Perl::Metrics::Lite/],
    style   => 'light';
ok_dependencies();
