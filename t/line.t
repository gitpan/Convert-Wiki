use Test::More;

BEGIN
   {
   plan tests => 5;
   chdir 't' if -d 't';
   use lib '../lib';
   use_ok ("Convert::Wiki::Node::Line") or die("$@");
   };

my $c = 'Convert::Wiki::Node::Line';
can_ok ($c, qw/
  new
  as_wiki
  /);

my $node = $c->new();
is (ref($node), $c);

is ($node->error(), '', 'no error yet');

is ($node->as_wiki(), "----\n\n", 'line');

