#############################################################################
# (c) by Tels 2004.
#
#############################################################################

package Convert::Wiki;

use 5.006001;
use strict;
use warnings;

use vars qw/$VERSION/;

$VERSION = '0.01';

use Convert::Wiki::Node;

#############################################################################

sub new
  {
  my $class = shift;

  my $self = bless {}, $class;

  my $args = $_[0];
  $args = { @_ } if ref($args) ne 'HASH';

  $self->{error} = '';
  $self->_init($args);
  }

sub _init
  {
  my $self = shift;

  $self;
  }

sub clear
  {
  my $self = shift;
  
  $self;
  }

sub from_txt
  {

  }

sub as_wiki
  {
  }

sub error
  {
  my $self = shift;
  
  $self->{error};
  }

1;
__END__

=head1 NAME

Convert::Wiki - Convert HTML/POD/txt from/to Wiki code

=head1 SYNOPSIS

	use Convert::Wiki;

	my $wiki = Convert::Wiki->new();

=head1 DESCRIPTION

=head2 EXPORT

None by default.

=head1 SEE ALSO

=head1 AUTHOR

Tels L<http://bloodgate.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Tels

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
