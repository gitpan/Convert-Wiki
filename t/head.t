use Test::More;

BEGIN
   {
   plan tests => 6;
   chdir 't' if -d 't';
   use lib '../lib';
   use_ok ("Convert::Wiki::Node::Head") or die("$@");
   };

my $c = 'Convert::Wiki::Node::Head';
can_ok ($c, qw/
  new
  as_wiki
  /);

my $node = $c->new();
is (ref($node), $c);

is ($node->error(), '', 'no error yet');

is ($node->as_wiki(), "==  ==\n\n", 'empty headline');

$node = $c->new( txt => 'Foo' );
is ($node->as_wiki(), "== Foo ==\n\n", '== Foo ==');

