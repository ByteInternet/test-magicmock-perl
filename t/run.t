#!/usr/bin/env perl

use lib 'lib/';
use lib 't/tests/';
use lib 't/fixture/';

*STDOUT = \*STDIN;

use Test::Class;

use T::MagicMock;
use T::MagicMock::Patcher;

Test::Class->runtests();
