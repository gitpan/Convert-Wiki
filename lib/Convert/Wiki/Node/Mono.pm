#############################################################################
# (c) by Tels 2004. Part of Convert::Wiki
#
# represents monospaced text blocks (aka <pre>)
#############################################################################

package Convert::Wiki::Node::Mono;

use 5.006001;
use strict;
use warnings;

use Convert::Wiki::Node;

use vars qw/$VERSION @ISA/;

@ISA = qw/Convert::Wiki::Node/;

$VERSION = '0.02';

#############################################################################

sub as_wiki
  {
  my $self = shift;

  # " Foo bar is baz.\n Baz.\n"
 
  my $txt = $self->{txt};

  $txt =~ s/\n/\n /g;

  ' ' . $txt . "\n\n";
  }

1;
__END__

=head1 NAME

Convert::Wiki::Node::Mono - Represents a monospaced text block

=head1 SYNOPSIS

	use Convert::Wiki::Node::Mono;

	my $para = Convert::Wiki::Node->new( txt => 'Foo is a foobar.', type => 'mono' );

	print $para->as_wiki();		# print something like " Foo is a foorbar\n"

=head1 DESCRIPTION

A C<Convert::Wiki::Node::Mono> represents an monospaced textblock.

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
