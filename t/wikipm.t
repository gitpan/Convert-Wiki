use Test::More;

BEGIN
   {
   plan tests => 10;
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
  debug
  /);

#############################################################################
my $wiki = Convert::Wiki->new();

is (ref($wiki), 'Convert::Wiki');

is ($wiki->error(), '', 'no error yet');
is ($wiki->error('Foo'), 'Foo', 'Foo error');
is ($wiki->error(''), '', 'no error again');

#############################################################################
# debug mode

$wiki = Convert::Wiki->new( debug => 1 );

is ($wiki->debug(), 1, 'debug mode');

#############################################################################
# interlink option

$wiki = Convert::Wiki->new( interlink => [ 'foo', 'bar baz' ] );
is ($wiki->error(), '', 'interlink with list');

#############################################################################
# wrong options

$wiki = Convert::Wiki->new( ddebug => 1 );
like ($wiki->error(), qr/Unknown option 'ddebug'/, 'unknown option ddebug');

$wiki = Convert::Wiki->new( interlink => 1 );
like ($wiki->error(), qr/interlink.*needs a list of/, 'interlink needs list');


