use Test::More;

BEGIN
   {
   plan tests => 4;
   chdir 't' if -d 't';
   use lib '../lib';
   use_ok ("Convert::Wiki") or die($@);
   };

can_ok ("Convert::Wiki", qw/
  new
  clear
  from_txt
  as_wiki
  error
  /);
my $wiki = Convert::Wiki->new();

is (ref($wiki), 'Convert::Wiki');

is ($wiki->error(), '', 'no error yet');

