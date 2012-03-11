use strict;
use warnings;
use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, 't', 'lib');

use Test::Perl::Metrics::Lite;

BEGIN {
    all_metrics_ok();
}
