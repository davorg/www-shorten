use Test::More tests => 6;

BEGIN { use_ok WWW::Shorten::NotLong };

my $re = qr!^ \Qhttp://\E ([\w]+) \Q.notlong.com\E/? $ !x;
my $code;
my $url = 'http://perl.dellah.org/WWW-Shorten-1.5.2.tar.gz';

diag "WWW::Shorten::NotLong ".WWW::Shorten::NotLong->VERSION();

{
    my $notlong = makeashorterlink( $url );

    ok ((defined $notlong and $notlong =~ $re),
	    'make it shorter'
       );

    $code = $1;

    is ( makealongerlink($notlong), $url, 'make it longer');

    is ( makealongerlink($code), $url, 'make it longer by Id');
}

{
    my ($notlong, $password) = makeashorterlink( $url );

    ok ( (defined $notlong and $notlong =~ $re
		and defined $password and $password =~ m!^ [a-z]+ $ !x),
	    "make it shorter, get password [$notlong, $password]"
       );
}

{
    $code = "spoon${code}x";
    $code = substr($code, -10);
    my ($notlong, $password) = makeashorterlink( $url, nickname => $code);

    ok ( ( defined $notlong and $notlong =~ $re
		and $1 eq $code
		and defined $password and $password =~ m!^ [a-z]+ $ !x),
	"make it shorter, with given code, and get password"
    );
}