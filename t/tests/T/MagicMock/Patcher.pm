package T::MagicMock::Patcher;
use base qw/Test::Class/;

use Test::Most;
use Test::MagicMock::Patcher;
use F::SimplePackage;

1;


sub test_patcher_replaces_sub_with_given_code : Test(1) {
	my $patcher = Test::MagicMock::Patcher->new('F::SimplePackage::croak', sub { return 1; })->start();
	my $ret     = F::SimplePackage::croak();
	is($ret, 1);
}

sub test_patcher_returns_original_code_on_stop : Test(1) {
	my $patcher = Test::MagicMock::Patcher->new('F::SimplePackage::croak', sub { return 1; })->start();
	   $patcher->stop();

	dies_ok(sub { F::SimplePackage::croak() }, "original function should be restored on stop");
}

sub test_patcher_returns_original_code_when_destroyed : Test(1) {
	my $patcher = Test::MagicMock::Patcher->new('F::SimplePackage::croak', sub { return 1; })->start();

	undef $patcher;

	dies_ok(sub { F::SimplePackage::croak() }, "original function should be restored on patcher destroy");
}

sub test_patcher_stores_original_code_in_orig_field : Test(1) {
	my $orig    = *F::SimplePackage::croak{CODE};
	my $patcher = Test::MagicMock::Patcher->new('F::SimplePackage::croak', sub { return 1; })->start();

	is($patcher->orig, $orig);
}

sub test_patcher_stores_calls : Test(1) {
	my $patcher = Test::MagicMock::Patcher->new('F::SimplePackage::croak', sub { return 1; })->start();

	F::SimplePackage::croak("argument");

	my $calls = $patcher->calls();

	is_deeply($calls, [["argument"]]);
}

sub test_patcher_stores_call_count : Test(2) {
	my $patcher = Test::MagicMock::Patcher->new('F::SimplePackage::croak', sub { return 1; })->start();

	F::SimplePackage::croak("argument");
	is($patcher->call_count(), 1);

	F::SimplePackage::croak("argument");
	is($patcher->call_count(), 2);
}
