package Test::MagicMock;
use strict;

use parent qw/Class::Accessor/;
use Test::MagicMock::Patcher;


Test::MagicMock->mk_accessors(qw/package mocks/);


sub new {
	my ($proto, $packagename) = @_;
	my $class = ref($proto) || $proto;

	my $self = bless {}, $class;
	   $self->package($packagename);
	   $self->mocks({});

	return $self;
}


sub mock {
	my ($self, $name, $code) = @_;
	my $fullname = sprintf("%s::%s", $self->package, $name);

	if ($self->mocks->{$name}) {
		die("Cannot mock '$fullname' twice, sorry.");
	}

	my $patcher = Test::MagicMock::Patcher->new($fullname, $code);
	   $patcher->start();

	$self->mocks->{$name} = $patcher;
}

1;
