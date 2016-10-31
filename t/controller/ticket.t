#!/usr/bin/env perl
use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

$ENV{MOJO_MODE} //= 'memory';

use FindBin;
require "$FindBin::Bin/../../maint-v5";

my $t = Test::Mojo->new;

##
## missing ticket
##
$t->get_ok('/tickets/0')->status_is(404);

##
## create ticket (fail)
##
$t->post_ok('/tickets' => json => {bad => 'ticket'})
  ->status_is(400);

##
## create ticket
##
my $res = $t->post_ok('/tickets' => json => {building => 'J',
                                             item => 'outside step',
                                             description => 'dangerous'})
  ->status_is(201)
  ->tx->res;

ok(my $ticket_id = $res->json('/ticket'), "ticket created");

##
## find ticket
##
$t->get_ok("/tickets/$ticket_id")
  ->status_is(200)
  ->json_is('/description' => 'dangerous');

done_testing;

