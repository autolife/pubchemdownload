package Method::DownloadCid;
use Moose;
use Exporter;
use Mojo::UserAgent;
use base qw(Exporter);
use vars qw(@EXPORT);
@EXPORT = qw(test_add downcid);    #Moose 中导出函数竟然也只能用EXPORT
sub test_add  
#希望这个函数能倒出来use Method::DownloadCid qw(test_add);
{
	my ($num1,$num2)=@_;
	my $resu=$num1+$num2;
	
	return $resu;
	
}


sub downcid
{
##https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/16222680/record/SDF/

	my $cid=shift;
	my $downdir=shift;
		$downdir=$downdir?$downdir:'';
	my $type=shift;
	$type=$type?$type:'2d';
	my $url='http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/'.$cid.'/record/SDF/?response_type=save&record_type='.$type;
	my $ua = Mojo::UserAgent->new();
  my $browser='Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Maxthon/4.4.2.2000 Chrome/30.0.1599.101 Safari/537.36';
  $ua->transactor->name($browser);
	
	my $tx = $ua->get($url);
  my $file=$downdir.$cid.'.sdf';

  $tx->res->content->asset->move_to($file);
	return 1;
}
1;

