#############################################################################
# (c) by Tels 2004.
#
#############################################################################

package Convert::Wiki::Node;

use 5.006001;
use strict;
use warnings;

use vars qw/$VERSION/;

$VERSION = '0.01';

#############################################################################

sub new
  {
  my $class = shift;

  my $args = $_[0];
  $args = { @_ } if ref($args) ne 'HASH';

  # XXX TODO check arguments
 
  if (defined $args->{type})
    { 
    my $type = ucfirst($args->{type});
    $type = 'Para' if $type eq 'Paragraph';
  
    $class .= '::' . $type;
    if ($class =~ /(\d)\z/)
      {
      # convert XX9 => XX (for Head1 etc)
      $args->{level} = abs($1 || 1);
      $class =~ s/\d\z//;
      }
    }

  if ($class ne __PACKAGE__)
    {
    my $pm = $class; $pm =~ s/::/\//g;	# :: => /
    $pm .= '.pm';
    require $pm;			# XXX not very portable I am afraid
    }

  my $self = bless {}, $class;

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
  $self->{txt} . "\n";
  }

sub error
  {
  my $self = shift;

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
