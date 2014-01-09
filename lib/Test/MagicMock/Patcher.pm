package Test::MagicMock::Patcher;
use strict;

use parent qw/Class::Accessor/;
Test::MagicMock::Patcher->mk_accessors(qw/name code orig calls/);

1;

sub new {
	my ($proto, $name, $code) = @_;
	my $package = ref($proto) || $proto;

	my $self = bless {}, $package;

	$self->name($name);
	$self->code($code);
	$self->calls([]);

	return $self;
}

###
# Top-level functions
###

# sub calls {}

sub call_count {
	my $self = shift;
	return scalar @{$self->calls};
}

###
# Stopper, starter
###

sub _wrap_code {
	my $self  = shift;
	my $code  = $self->code;
	my $calls = $self->calls;
	
	my $wrapper = sub {
		my $arguments = \@_;
		push @{$calls}, $arguments;
		return $code->();
	};

	return $wrapper;
}

sub start {
	my $self = shift;
	no strict qw/refs/;

	$self->orig(\&{$self->name});
	*{$self->name} = $self->_wrap_code();

	return $self;
}

sub stop {
	my $self = shift;
	no strict qw/refs/;
	*{$self->name} = $self->orig;

	return $self;
}	

sub DESTROY {
	shift->stop();
}
