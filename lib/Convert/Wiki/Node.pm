#############################################################################
# (c) by Tels 2004.
#
#############################################################################

package Convert::Wiki::Node;

use 5.006001;
use strict;
use warnings;

use vars qw/$VERSION/;

$VERSION = '0.02';

#############################################################################

sub new
  {
  my $class = shift;

  my $args = $_[0];
  $args = { @_ } if ref($args) ne 'HASH';
  
  my $self = bless {}, $class;

  # XXX TODO check arguments
 
  if (defined $args->{type})
    { 
    my $type = ucfirst($args->{type});
    $type = 'Para' if $type eq 'Paragraph';

    if ($type =~ /(\d)\z/)
      {
      # convert XX9 => XX (for Head1 etc)
      $args->{level} = abs($1 || 1);
      $type =~ s/\d\z//;
      }

    $self->error('Node type must be one of Head, Item, Mono, Line or Para but is \'' . $type . "'") and return $self
      unless $type =~ /^(Head|Item|Line|Mono|Para)\z/;

    $class .= '::' . $type;
    $self = bless $self, $class;	# rebless
    }

  if ($class ne __PACKAGE__)
    {
    my $pm = $class; $pm =~ s/::/\//g;	# :: => /
    $pm .= '.pm';
    require $pm;			# XXX not very portable I am afraid
    }

  $self->_init($args);
  }

sub _init
  {
  # generic init, override in subclasses
  my ($self,$args) = @_;

  foreach my $k (keys %$args)
    {
    $self->{$k} = $args->{$k};
    }
  
  $self->{error} = '';
  $self->{txt} = '' unless defined $self->{txt};

  $self->{txt} =~ s/\n+\z//;		# remove trailing newline
  $self->{txt} =~ s/^\n+//;		# remove newlines at start

  $self;
  }

sub as_wiki
  {
  my $self = shift;

  # For paragraphs. For others, will be overwritten in subclass.
  $self->{txt} . "\n\n";
  }

sub error
  {
  my $self = shift;

  $self->{error} = $_[0] if defined $_[0];
  $self->{error};
  }

sub type
  {
  my $self = shift;

  my $type = ref($self); $type =~ s/.*:://;		# only last part
  lc($type);						# head, para, node etc
  }

1;
__END__

=head1 NAME

Convert::Wiki::Node - Represents a node (headline, paragraph etc) in a text

=head1 SYNOPSIS

	use Convert::Wiki::Node;

	my $head = Convert::Wiki::Node->new( txt => 'About Foo', type => 'head1' );
	my $text = Convert::Wiki::Node->new( txt => 'Foo is a foobar.', type => 'paragraph' );

	print $head->as_wiki(), $text->as_wiki();

=head1 DESCRIPTION

A C<Convert::Wiki::Node> represents a node (headline, paragraph etc) in a
text. All the nodes together represent the entire document.

=head1 METHODS

=head2 error()

	$last_error = $cvt->error();

	$cvt->error($error);			# set new messags
	$cvt->error('');			# clear error

Returns the last error message, or '' for no error.

=head2 as_wiki()

	my $txt = $node->as_wiki();

Return the contents of the node as wiki code.

=head2 type()

	my $type = $node->type();

Returns the type of the node as string.
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
