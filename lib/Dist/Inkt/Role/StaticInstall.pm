package Dist::Inkt::Role::StaticInstall;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.024';

use Moose::Role;
use Path::Tiny 'path';
use namespace::autoclean;

has no_static_install => (is => 'ro', default => sub { !!0 });

before Build_MakefilePL => sub
{
	my $self = shift;
	
	return if $self->no_static_install;

	return if $self->needs_conflict_check_code;
	return if $self->needs_optional_features_code;
	return if $self->sourcefile->child('meta/DYNAMIC_CONFIG.PL')->exists;
	return if $self->sourcefile->child('bin')->exists;
	return if $self->sourcefile->children( qr/\.(h|c|xs)$/ );
	
	$self->log('Distribution seems suitable for static install');
	
	$self->metadata->{x_static_install} //= 1;
};

1;
