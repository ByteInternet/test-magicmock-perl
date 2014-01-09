package T::MagickMock;
use base qw/Test::Class/;

use Test::Most;
use Test::MagicMock;
use F::SimplePackage;

1;

sub test_magicmock_mock_returns_mocksub_object : Test(1) {
	my $fs = Test::MagicMock->new("F::SimplePackage");
	my $mock = $fs->mock('croak', sub { return 1; });

	ok($mock->isa("Test::MagicMock::Patcher"));
}

sub test_magicmock_mocks_simplefunction : Test(1) {
	my $fs = Test::MagicMock->new("F::SimplePackage");
        my $mock = $fs->mock('croak', sub { return 1; });

	F::SimplePackage::croak();
	ok(1); # survived
}

sub test_magicmock_mock_ends_at_end_of_lexical_scope : Test(2) {
	{ # scope
		my $fs = Test::MagicMock->new("F::SimplePackage");
		my $mock = $fs->mock('croak', sub { return 1; });

		F::SimplePackage::croak();

		ok(1); # survived
	}

	dies_ok(sub { F::SimplePackage::croak() }, "function is still mocked after mock scoped ended");
}

sub test_magicmock_mock_mocks_one_sub_only_once : Test(2) {
	my $fs = Test::MagicMock->new("F::SimplePackage");
	my $mock = $fs->mock('croak', sub { return 1; });

	dies_ok(sub { $fs->mock('croak', sub { return 1; })}, "mocking twice should die with an error, but did not");
}

sub test_magicmock_mock_mocks_nonexistant_sub : Test(2) {
	{
		my $fs = Test::MagicMock->new("F::SimplePackage");
		$fs->mock('nonexistant', sub { return 1; });
		F::SimplePackage::nonexistant();
	}

	dies_ok(sub { F::SimplePackage::nonexistant(); }, "call should result in die");
	
}

sub test_magicmock_mock_mocks_two_subs : Test(2) {
	my $fs = Test::MagicMock->new("F::SimplePackage");
	$fs->mock('croak', sub { return 1; });
	$fs->mock('nonexistant', sub { return 1; });

	F::SimplePackage::croak();
	F::SimplePackage::nonexistant();
}
