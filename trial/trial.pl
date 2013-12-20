use strict;
use warnings;

use Web::Scraper;
use URI;

use LWP::UserAgent;
use HTTP::Request::Common;
use utf8;
use Encode 'encode';


use Data::Dumper::AutoEncode;
$Data::Dumper::AutoEncode::ENCODING = 'CP932';

my ($url, $uri, $res, $content, $scraper, $ua);
$ua = LWP::UserAgent->new;

# 品別国別表 輸入
print encode('ShiftJIS', '品別国別表 輸入を開く'), "\n";
$url = 'http://www.e-stat.go.jp/SG1/estat/OtherList.do?bid=000001008801&cycode=1';
$uri = new URI( $url );

$scraper = scraper {
    process '//*[@id="contents_main"]/form/table/tr[2]/td[3]/a', 'url' => '@href';   
};
$res = $scraper->scrape($uri);

print encode('ShiftJIS', '2013年1月のリンク取得'), "\n";
print $res->{url} ,"\n";
print encode('ShiftJIS', '貿易統計_全国分 品別国別表 輸入 月次 2013年1月 '), "\n";
$content = $ua->get( $res->{url} );

#第28類　2013年1月分 品別国別表 (輸入 1月：確報) ６部 28-38類
$scraper = scraper {
    process '//*[@id="contents_main"]/form/table/tr[8]/td[4]/a', 'url' => '@href';   
};

$res = $scraper->scrape($content);

print encode('ShiftJIS', '６部 28-38類のリンク取得'), "\n";
print $res->{url} ,"\n";
$res = $ua->get( $res->{url} );

print encode('ShiftJIS', 'CSVデータ取得'), "\n";
my $csv = $res->content;
my @lines = split("\n", $csv);

use Text::CSV;
my $p = Text::CSV->new;

my $header = shift @lines;
$p->parse($header);
my @header = $p->fields;


my @he = ();
for(@lines){
	$p->parse($_);
	my @e = $p->fields;
	next unless $e[2];
	$e[2] =~ s/'//g;
	next if $e[2] !~ /^280429100/;
	#print $e[2], " ", "\n";
	
	my $hash = {};
	for(my $i = 0; $i < scalar @header; $i++){		
		$hash->{ $header[ $i ] } = $e[$i];
	}

	push @he, $hash;
}


for my $d (@he){
	print $d->{Country}, ' : ';
	print $d->{ 'Quantity2-'.$_ },  $d->{ 'Unit2'}, ' | ' for (qw/Jan Feb Mar Apl May Jun Jul Aug Sep Oct Nov Dec/);
	print "\n";
}


#print Dumper( \@he);
#print eDumper( [@lines]); 
#print $content->as_string;


__END__

use LWP::UserAgent;
use HTTP::Request::Common;

my $ua = LWP::UserAgent->new;
my $content = $ua->get($url);


print $content->as_string;






__END__
use Web::Scraper;
use URI;

use Data::Dumper::AutoEncode;
$Data::Dumper::AutoEncode::ENCODING = 'CP932';



my $code = require 'code_data.pl';
#print eDumper($code); 

use Web::Scraper;

my $helium_code = '280429100';

#my $url = "http://www.customs.go.jp/toukei/srch/index.htm";
my $url = 'http://www.customs.go.jp/toukei/srch/index.htm?M=01&P=1,2,,,,,,,,1,0,2013,0,1,0,2,280429100,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,20';
my $uri = new URI( $url );

my $scraper = scraper {
    process '/', 'hydrogen[]' => 'TEXT';   

};

my $res = $scraper->scrape($uri);

print eDumper($res); 


__END__
 http://www.customs.go.jp/toukei/srch/index.htm?M=01&P=1,2,,,,,,,,1,0,2013,0,1,0,2,280429100,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,20
 http://www.customs.go.jp/toukei/srch/index.htm?M=01&P=1,2,,,,,,,,1,0,2013,0,2,0,2,280429100,,,,,,,,,,1,,,,,,,,,,,,,,,,,,,,,,20