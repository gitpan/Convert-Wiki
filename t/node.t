use Test::More;

BEGIN
   {
   plan tests => 6;
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

#############################################################################

$node = $c->new ( txt => 'Foo', type => 'head1' );
is ($node->as_wiki(), "== Foo ==\n", '== Foo ==');

$node = $c->new ( txt => 'Foo is a foo.', type => 'paragraph' );
is ($node->as_wiki(), "Foo is a foo.\n", 'Foo is a foo.');

