#############################################################################
# (c) by Tels 2004.
#
#############################################################################

package Convert::Wiki;

use 5.006001;
use strict;
use warnings;

use vars qw/$VERSION/;

$VERSION = '0.02';

use Convert::Wiki::Node;

#############################################################################

sub new
  {
  my $class = shift;

  my $self = bless {}, $class;

  my $args = $_[0];
  $args = { @_ } if ref($args) ne 'HASH';

  $self->clear();
  $self->_init($args);
  }

sub _init
  {
  my ($self,$args) = @_;

  $self->{interlink} = [];			# default none
  foreach my $k (keys %$args)
    {
    if ($k !~ /^(interlink|debug)\z/)
      {
      $self->error ("Unknown option '$k'");
      }
    $self->{$k} = $args->{$k};
    }
  
  if (ref($self->{interlink}) ne 'ARRAY')
    {
    $self->error ("Option 'interlink' needs a list of phrases");
    }

  $self;
  }

sub clear
  {
  my $self = shift;
  
  $self->{error} = '';
  $self->{nodes} = [];
  $self;
  }

sub from_txt
  {
  my ($self,$txt) = @_;

  $self->clear();

  #########################################################################
  # Stage 0: global normalization

  # convert "\n \n" to "\n\n"
  $txt =~ s/\n\s+\n/\n\n/;

  # convert "foo:\nbah" to "foo:\n\nbah"
  $txt =~ s/:\s*\n/:\n\n /g;

  # remove leading \n:
  $txt =~ s/^\n+//g;

  # remove leading lines:
  $txt =~ s/^\s*[=_-]+\n+//;

  # take the text, recognize parts at it's beginning until we no longer have
  # anything left
  my ($opt);
  my $tries = 0;
  while ((length($txt) > 0) && ($tries++ < 16))
    {

    #########################################################################
    # Stage 1: local normalization
 
    # remove superflous newlines
    $txt =~ s/^\n+//;
    
    # remove "=========" and similiar stray delimiters
    $txt =~ s/^[=]+\n+//;
   
    #########################################################################
    # Stage 2: conversion to internal format

    $opt = undef;						# reset

    if ($self->{debug})
      {
      $txt =~ /^(.*)/; print STDERR "Text start is now: '$1'\n";
      }
   
    # "Foo\n===" looks like a headline
    if ($txt =~ s/^(.+)\n[=-]+\n+//)
      {
      $opt = { txt => $1, type => 'head1' };
      }
    # '-----' or '_____' to rulers
    elsif ($txt =~ s/^[-_]+\n//)
      {
      $opt = { type => 'line' };
      }
    # "1. Foo\n" looks like a bullet
    elsif ($txt =~ s/^([\d\.]+) (.+)\n//)
      {
      $opt = { txt => $2, name => $1, type => 'item' };
      }
    # "* Foo\n" looks like a bullet
    elsif ($txt =~ s/^(\s*[*+-](\s+(.|\n)+?))(\n\n|\n\s+[*+-])/$4/)
      {
      my $t = $1;
      $t =~ s/^\s*[*+-]\s+//;		# "- Foo" => "Foo"
      $t =~ s/\n\s+/\n/g;		# "\n Boo" => "\nBoo"

      $t =~ s/\s+\z//g;			# remove trailing space
      $t =~ s/\n/ /g;			# remove newlines entirely

      $opt = { txt => $t, type => 'item' };
      }
    # " Foo\n" looks like a monospaced text
    elsif ($txt =~ s/^[\s]\s+(((.+)\n){1,})//)
      {
      my $t = $1;
      $t =~ s/\n\s+/\n/g;		# "\n Boo" => "\nBoo"

      $opt = { txt => $t, type => 'mono' };
      }
    # Also: "$ Foo\n" and "# bah" look like a monospaced text
    elsif ($txt =~ s/^([\$\#])\s+(((.+)\n){1,})//)
      {
      my $t = "$1 $2";
      $t =~ s/\n\s+/\n/g;		# "\n Boo" => "\nBoo"

      $opt = { txt => $t, type => 'mono' };
      }
    # "Foo\n" looks like a text
    elsif ($txt =~ s/^([^\s]((.+)\n){1,})//)
      {
      $opt = { txt => $1, type => 'para' };
      }
    
    if (defined $opt)
      { 
      $tries = 0;
      if ($self->{debug})
        {
        require Data::Dumper;
        print STDERR Data::Dumper::Dumper($opt);
        }
      $opt->{interlink} = $self->{interlink};
      push @{$self->{nodes}}, Convert::Wiki::Node->new( $opt );
      }
    }
  if ($tries > 0)
    {
    # something was left over
    }
 
  $self; 
  }

sub as_wiki
  {
  my $self = shift;

  my $wiki = '';
  foreach my $node (@{$self->{nodes}})
    {
    $wiki .= $node->as_wiki();
    }
  $wiki;
  }

sub error
  {
  my $self = shift;

  $self->{error} = $_[0] if defined $_[0];
  $self->{error};
  }

sub debug
  {
  my $self = shift;

  $self->{debug};
  }

1;
__END__

=head1 NAME

Convert::Wiki - Convert HTML/POD/txt from/to Wiki code

=head1 SYNOPSIS

	use Convert::Wiki;

	my $wiki = Convert::Wiki->new();
	
	$wiki->from_txt ( $txt );
	die ("Error: " . $wiki->error()) if $wiki->error;
	print $wiki->as_wiki();

	$wiki->from_html ( $html );
	die ("Error: " . $wiki->error()) if $wiki->error;
	print $wiki->as_wiki();

	# clear the object manually
	$wiki->clear();
	$wiki->add_txt ( $txt );
	die ("Error: " . $wiki->error()) if $wiki->error;
	print $wiki->as_wiki();

=head1 DESCRIPTION

C<Convert::Wiki> converts from various formats to various Wiki formats.

Input can come as HTML, POD or plain TXT (like it is written in many READMEs).
The data will be converted to an internal, node based format and can then be
converted to Wikicode as used by many wikis like the Wikipedia.

=head1 METHODS

=head2 new()

	$cvt = Convert::Wiki->new();

Creates a new conversion object. It takes an optional list of options. The
following are valid:

	debug		if set, will enable some debug outputs
	interlink	a list of phrases, that if found in a paragraph,
			are turned into links (into the same Wiki)

=head2 error()

	$last_error = $cvt->error();

	$cvt->error($error);			# set new messags
	$cvt->error('');			# clear error

Returns the last error message, or '' for no error.

=head2 debug()

	$debugmode = $cvt->debug();		# true or false

Returns true if the debug mode is enabled.

=head2 clear()

	$cvt->clear();

Clears the conversion object by resetting the last error and
throwing away all internally stored nodes. There is usually
no need to do this manually, except if you want to reuse
a conversion object with the C<add> methods.

=head2 from_txt()

	$cvt->from_txt();

Clears the object via L<clear()> and then converts the given text
to the internal format.

=head2 as_txt()

	$cvt->as_wiki();

Returns the internally stored contents in wiki code.

=head2 EXPORT

None by default.

=head1 SEE ALSO

L<http://en.wikipedia.org/>, L<Pod::Simple::Wiki>.

=head1 AUTHOR

Tels L<http://bloodgate.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Tels

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
