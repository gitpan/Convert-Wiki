#############################################################################
# (c) by Tels 2004. Part of Convert::Wiki
#
# represents a text paragraph node
#############################################################################

package Convert::Wiki::Node::Para;

use 5.006001;
use strict;
use warnings;

use Convert::Wiki::Node;

use vars qw/$VERSION @ISA/;

@ISA = qw/Convert::Wiki::Node/;

$VERSION = '0.02';

#############################################################################

sub _init
  {
  my ($self,$args) = @_;

  $self->SUPER::_init($args);

  $self->{txt} .= "\n\n";

  $self;
  }

1;
__END__

=head1 NAME

Convert::Wiki::Node::Para - Represents a text paragraph node

=head1 SYNOPSIS

	use Convert::Wiki::Node::Para;

	my $para = Convert::Wiki::Node->new( txt => 'Foo is a foobar.', type => 'para' );

	print $para->as_wiki();

=head1 DESCRIPTION

A C<Convert::Wiki::Node::Para> represents a normal text paragraph.

=head1 EXPORT

None by default.

=head1 SEE ALSO

L<Convert::Wiki::Node>.

=head1 AUTHOR

Tels L<http://bloodgate.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Tels

This library is free software; you can redistribute it and/or modify
it under the terms of the GPL. See the LICENSE file for more details.

=cut
