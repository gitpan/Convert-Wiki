#############################################################################
# (c) by Tels 2004.
#
# represents a headline node
#############################################################################

package Convert::Wiki::Node::Head;

use 5.006001;
use strict;
use warnings;

use Convert::Wiki::Node;

use vars qw/$VERSION @ISA/;

@ISA = qw/Convert::Wiki::Node/;
$VERSION = '0.01';

#############################################################################

sub _init
  {
  my ($self,$args) = @_;

  $self->{level} ||= 1; 

  $self->SUPER::_init($args);
  }

sub as_wiki
  {
  my $self = shift;

  my $p = '=' x ($self->{level} + 1);		# level 1: ==

  # "== Foo ==\n"
  $p . ' ' . $self->{txt} . ' ' . $p . "\n";
  }

1;
__END__

=head1 NAME

Convert::Wiki::Node::Head - Represents a headline node

=head1 SYNOPSIS

	use Convert::Wiki::Node::Head;

	my $head = Convert::Wiki::Node->new( txt => 'About Foo', type => 'head1' );

	print $head->as_wiki();

=head1 DESCRIPTION

A C<Convert::Wiki::Node::Head> represents a headline node in a text.

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
