use strict;
use warnings;

use Web::Scraper;
use Data::Dumper::AutoEncode;
use URI;
use Encode qw/encode/;

#binmode STDOUT, ':encoding(cp932)';
#$Data::Dumper::AutoEncode::ENCODING = 'CP932';

my $url = "http://www.customs.go.jp/tariff/2013_4/data/i201304j_28.htm";
my $uri = new URI( $url );

my $scraper = scraper {
   # process '/html/body/div[2]/table/tr[4]/td', 'head[]' => 'TEXT';

    process '/html/body/div[2]/table/tr[15]/td', 'hydrogen[]' => 'TEXT';   
    process '/html/body/div[2]/table/tr[17]/td', 'argon[]' => 'TEXT';
    process '/html/body/div[2]/table/tr[18]/td', 'other[]' => 'TEXT';
    process '/html/body/div[2]/table/tr[19]/td', 'other_he[]' => 'TEXT';
    process '/html/body/div[2]/table/tr[20]/td', 'other_ex_he[]' => 'TEXT';
    process '/html/body/div[2]/table/tr[21]/td', 'nitrogen[]' => 'TEXT';
    process '/html/body/div[2]/table/tr[22]/td', 'oxygen[]' => 'TEXT';
};

my $res = $scraper->scrape($uri);

while( my ($key, $val ) = each %$res ){
	my @a = splice @$val, 0, 3;
	push @a, ( pop @$val );
	$res->{$key} = [ @a ];
}

print eDumper($res); 

$res;