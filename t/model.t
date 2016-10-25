#!/usr/bin/env perl
use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Data::Dumper;

$ENV{MOJO_MODE} //= 'memory';

use FindBin;
require "$FindBin::Bin/../maint-v5";

my $t     = Test::Mojo->new;  ## loads and initializes the whole app and model
my $model = $t->app->model;   ## just a handle to the model chosen by the app

##
## missing ticket
##
my $ticket = $model->find_ticket(1);
is( undef, $ticket, "no ticket found");

like($model->error->{error}, qr(not found)i, "ticket not found");

##
## add a new ticket
##
my $uniq = int rand(9999);
my $ticket_id = $model->create_ticket({building    => "H",
                                       item        => "west hall, north end wallboard",
                                       description => "doesn't change",
                                       expectation => "should be $uniq"});

like($ticket_id, qr(^\d+$), "ticket id created");

##
## round trip
##
$ticket = $model->find_ticket($ticket_id);
is($ticket->{expectation}, "should be $uniq", "new ticket found");

done_testing;
