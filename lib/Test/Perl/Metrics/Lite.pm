package Test::Perl::Metrics::Lite;
use strict;
our $VERSION = '0.01';

use Test::More ();
use Perl::Metrics::Lite;

my %METRICS_ARGS;

my $TEST = Test::Builder->new;

sub import {
    my ( $self, %args ) = @_;

    my $caller = caller;
    {
        no strict 'refs';    ## no critic qw(ProhibitNoStrict)
        *{ $caller . '::all_metrics_ok' } = \&all_metrics_ok;
    }

    $TEST->exported_to($caller);

    $args{'-mccabe_complexity'} = 10 unless $args{'-mccabe_complexity'};
    $args{'-loc'}               = 60 unless $args{'-loc'};
    %METRICS_ARGS               = %args;

    return 1;
}

sub all_code_files {
    my @dirs = @_;
    if ( not @dirs ) {
        @dirs = _starting_points();
    }
    return \@dirs;
}

sub _starting_points {
    return -e 'blib' ? 'blib' : 'lib';
}

sub all_metrics_ok {
    my %param = @_;
    Test::More::plan('no_plan');

    my @dirs = @_;
    if ( not @dirs ) {
        @dirs = _starting_points();
    }
    my $files = all_code_files(@dirs);

    my $analysis = _analyze_metrics($files);
    my $ok       = _all_files_metric_ok( $analysis->sub_stats );
    return $ok;
}

sub _analyze_metrics {
    my $libs     = shift;
    my $analzyer = Perl::Metrics::Lite->new;
    my $analysis = $analzyer->analyze_files(@$libs);
    return $analysis;
}

sub _all_files_metric_ok {
    my $sub_stats = shift;
    my $ok        = 1;
    foreach my $file_path ( keys %{$sub_stats} ) {
        my $sub_metrics = $sub_stats->{$file_path};
        $ok &= _all_sub_metrics_ok($sub_metrics);
    }
    return $ok;
}

sub _all_sub_metrics_ok {
    my $sub_metrics = shift;
    my @rows = ();
    my $ok   = 1;
    foreach my $sub_metric ( @{$sub_metrics} ) {
        $ok &= _sub_metric_ok($sub_metric);
    }
    return $ok;
}

sub _sub_metric_ok {
    my $sub_metric = shift;
    my $ok         = 1;
    $ok &= _sub_loc_ok($sub_metric);
    $ok &= _sub_cc_ok($sub_metric);
    return $ok;
}

sub _sub_cc_ok {
    my $sub_metric = shift;

    my $cc = $sub_metric->{mccabe_complexity};
    if ( $cc > $METRICS_ARGS{mccabe_complexity} ) {
        $TEST->ok( 1, $sub_metric->{name} . " cc is ok" );
        return 1;
    }
    else {
        $TEST->ok( 0, $sub_metric->{name} . " is too complex" );
        return 0;
    }
}

sub _sub_loc_ok {
    my $sub_metric = shift;

    my $sloc = $sub_metric->{lines};
    if ( $sloc > $METRICS_ARGS{loc} ) {
        $TEST->ok( 1, $sub_metric->{name} . " sloc is ok" );
        return 1;
    }
    else {
        $TEST->ok( 0, $sub_metric->{name} . " loc is too long!: ${sloc}" );
        return 0;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::Perl::Metrics::Lite - Use Perl::Metrics::Lite in test programs

=head1 SYNOPSIS

Basic usage:

  use Test::Perl::Metrics::Lite;
  all_metrics_ok();

You can change the metrics threshold.

  use Test::Perl::Metrics::Lite -mccabe_complexity => 6 -loc => 50;
  all_metrics_ok();

=head1 DESCRIPTION

Test::Perl::Metrics::Lite wraps the Perl::Metrics::Lite 
engine in a  convenient subroutine suitable for test programs 
written using the Test::More framework

This makes it easy to integrate metrics enforcement into the build process. =head1 SOURCE AVAILABILITY


This source is in Github:

  http://github.com/dann/p5-test-perl-metrics-lite

=head1 AUTHOR

Dann E<lt>techmemo@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
