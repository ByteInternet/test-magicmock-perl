package Test::MagicMock::Patcher;
use strict;

use parent qw/Class::Accessor/;
Test::MagicMock::Patcher->mk_accessors(qw/name code orig/);

1;

sub new {
	my ($proto, $name, $code) = @_;
	my $package = ref($proto) || $proto;

	my $self = bless {}, $package;

	$self->name($name);
	$self->code($code);

	return $self;
}


sub start {
	my $self = shift;
	no strict qw/refs/;

	die("henk");

	$self->orig(*{$self->name}{CODE});
	*{$self->name} = $self->code;
}

sub stop {
	my $self = shift;
	no strict qw/refs/;
	#warn sprintf("Patcher for %s being stopped, restoring %s", $self->name, $self->orig);
	*{$self->name} = $self->orig;
}	

sub DESTROY {
	shift->stop();
}
