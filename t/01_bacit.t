use strict;
use warnings;
use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, 'lib');

use Test::Perl::Metrics::Lite;
#use Test::Perl::Metrics::Lite (-mccabe_complexity => 6, -loc => 5);

BEGIN {
    all_metrics_ok();
}
