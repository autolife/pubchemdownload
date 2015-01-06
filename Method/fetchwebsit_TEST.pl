use Moose;
#requires "downloadpubchemid";
use Mojo::UserAgent;
use Data::Dumper;
use Mojo::UserAgent::CookieJar;
my $ua = Mojo::UserAgent->new();
my $browser='Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Maxthon/4.4.2.2000 Chrome/30.0.1599.101 Safari/537.36';

$ua->transactor->name($browser);
  my $cookie_jar = $ua->cookie_jar;
  $ua            = $ua->cookie_jar(Mojo::UserAgent::CookieJar->new);
my $url;
#https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/241/record/SDF/?response_type=save&record_type=3d
#https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/16222680/record/SDF/?response_type=save&record_type=2d
#一个是cid 一个是sid
#我们下载的必须是cid的。
$url='http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/175804/record/SDF/?response_type=save&record_type=2d';
my $tx = $ua->get($url);
my $file='1.sdf';
$tx->res->content->asset->move_to($file);
1;



#curl 
#--header "Host: pubchem.ncbi.nlm.nih.gov" 
#--header "User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:34.0) Gecko/20100101 Firefox/34.0" 
#--header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" 
#--header "Accept-Language: zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" 
#--header "Cookie: __utma=194752562.1892668515.1409822835.1420463059.1420463059.1; __utmz=194752562.1420463059.1.1.utmcsr=so.com|utmccn=(organic)|utmcmd=organic|utmctr=pubchem%2013721-39-6; ncbi_sid=95B61D5636CC6F31_0000SID; WebCubbyUser=63WBEEMMLB85ZU9B5NDK7DNWLR7Z98N2%3Blogged-in%3Dtrue%3Bmy-name%3Dautolife%3Bpersistent%3Dtrue%4095B61D5636CC6F31_0000SID; _ga=GA1.4.1892668515.1409822835; _ga=GA1.2.1892668515.1409822835; __atuvc=8%7C1" 
#--header "Connection: keep-alive" "https://pubchem.ncbi.nlm.nih.gov/summary/summary.cgi?sid=162226805&disopt=SaveSDF" 
#-o "SID_162226805.sdf" 
#-L


#wget 
#--header="Host: pubchem.ncbi.nlm.nih.gov" 
#--header="User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:34.0) Gecko/20100101 Firefox/34.0" 
#--header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" 
#--header="Accept-Language: zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" 
#--header="Cookie: __utma=194752562.1892668515.1409822835.1420463059.1420463059.1; __utmz=194752562.1420463059.1.1.utmcsr=so.com|utmccn=(organic)|utmcmd=organic|utmctr=pubchem%2013721-39-6; ncbi_sid=95B61D5636CC6F31_0000SID; WebCubbyUser=63WBEEMMLB85ZU9B5NDK7DNWLR7Z98N2%3Blogged-in%3Dtrue%3Bmy-name%3Dautolife%3Bpersistent%3Dtrue%4095B61D5636CC6F31_0000SID; _ga=GA1.4.1892668515.1409822835; _ga=GA1.2.1892668515.1409822835; __atuvc=8%7C1"
#--header="Connection: keep-alive" "https://pubchem.ncbi.nlm.nih.gov/summary/summary.cgi?sid=162226805&disopt=SaveSDF" 
#-O "SID_162226805.sdf"
#-c









__END__
sub downloadpubchemid
{
	my $pubchemid=shift;
	
	
	
	
	
}