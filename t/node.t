use Test::More;

BEGIN
   {
   plan tests => 12;
   chdir 't' if -d 't';
   use lib '../lib';
   use_ok ("Convert::Wiki::Node") or die("$@");
   };

my $c = 'Convert::Wiki::Node';
can_ok ($c, qw/
  new
  as_wiki
  _init
  error
  type
  /);

my $node = $c->new();
is (ref($node), $c);

is ($node->error(), '', 'no error yet');

is ($node->error('Foo'), 'Foo', 'Foo error');
is ($node->error(''), '', 'no error again');

#############################################################################
# wrong node type

$node = $c->new ( txt => 'Foo', type => 'foo' );
like ($node->error(), qr/Node type must be one of.* but is 'Foo'/, 'Foo not valid type');

#############################################################################
# variou snode types

$node = $c->new ( txt => 'Foo', type => 'head1' );
is ($node->as_wiki(), "== Foo ==\n\n", '== Foo ==');

$node = $c->new ( txt => 'Foo is a foo.', type => 'paragraph' );
is ($node->as_wiki(), "Foo is a foo.\n\n", 'Foo is a foo.');

$node = $c->new ( txt => 'Foo is a foo.', type => 'mono' );
is ($node->as_wiki(), " Foo is a foo.\n\n", ' Foo is a foo.');

$node = $c->new ( txt => 'Foo is a foo.', type => 'item' );
is ($node->as_wiki(), "* Foo is a foo.\n", '* Foo is a foo.');

$node = $c->new ( type => 'line' );
is ($node->as_wiki(), "----\n\n", 'ruler');

