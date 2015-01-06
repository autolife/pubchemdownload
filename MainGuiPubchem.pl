#!/usr/bin/perl -w
use utf8;
use strict;

use lib './';

use strict;
use warnings;

use Data::Dumper;
use Win32::GUI();
use Encode qw(decode encode  find_encoding  decode_utf8 from_to  _utf8_on _utf8_off  is_utf8);
use Encode::CN;
use Win32::GUI qw(DT_RIGHT DT_LEFT DT_CENTER DT_VCENTER);
use Win32::GUI::Grid qw(GVS_DATA);
use Method::DownloadCid qw(test_add downcid);


####test
#print &test_add(1,2);
#&downcid('10034346','2d'); #input parameters: cid,tyep('2d','3d')[option]
##########

#如何关闭mojo的调试模式????

my $desktop     = Win32::GUI::GetDesktopWindow();  #获得显示屏信息
my $x           = Win32::GUI::Width($desktop);     #显示屏长度 928
my $y           = 0.9 * (Win32::GUI::Height($desktop)); #显示屏宽度1280

#print  $x,"/",$y;

my @colors = ([7,102,198],  #知乎蓝
              [255,255,255],#文本白
							);
							
my @fonts = (
  Win32::GUI::Font->new(                   #标题字体
    -name => 'Arial',
    -size => 20,
    -bold => 1,
   
  ),          
  Win32::GUI::Font->new(                   #中字体
    -name   => 'Arial',
    -size   => 14,
    -italic => 1,
  ),
    Win32::GUI::Font->new(                   #小字体
    -name   => 'Arial',
    -size   => 12,
    -italic => 1,
  ),
);

my $DOS = Win32::GUI::GetPerlWindow();
Win32::GUI::Hide($DOS);

###################图形界面中的一些变量    #######################
my $mh=700;
my $butx=110;
my $buty=40;
my $but_size=[$butx,$buty];
my $textx=270;
my $texty=40;
my $text_size=[$textx,$texty];
my $beginx=55;
my $label_x=55;
my $left=55;
my $left2=170;
my $label_size=[250,30];
my $beginy=100;
my $topy=$beginy;
my $indexy=50;

######################
#需要传递的外部变量
my($cidfile);


######################


##################sub 转码###############################
my $showtext;

sub showcode
{
	my $text=$_[0];
	#my $text="CAS下载器";#我默认是936gbk是乱码
#print $text;#说明是utf-8编码

  my $showtextt=decode_utf8($text);
$showtextt=encode('gbk', $showtextt); #win32 gui中默认采用的是gbk编码
	
	return $showtextt;
	
}


#创建一个主窗口
my $main_window = new Win32::GUI::Window(
                                    '-title'  => 'PubChem',
                                    '-name'   => 'Window',
                                    '-left'   => 400,
                                    '-top'    => 200,
                                    '-width'  => 520,
                                    '-height' => $mh,
                                     -minsize=>[520,$mh],
                                    -maxsize=>[520,$mh],
                                   );
                                   
#在底部创建联系方式，宣传语言
my $contact_y=$mh-60;
$main_window->AddLabel
(
-text=>'Contact: 744891290@qq.com',
-pos=>[280,$contact_y],
-font=>$fonts[2],
);


#创建标题
$showtext=&showcode("pubchem 下载器");
$main_window->AddLabel(
        -name => 'L1',
        -font =>$fonts[0],
      -align=>'center',
    #-valign => "center",
        -pos  => [50,5],
        -size => [400,40],
    
     -background => [7,102,198], ###蓝色
   #  -bandborders => 1,
   #  -visible =>1,
    
);

$main_window->AddLabel(
        -name => 'L2',
        -font =>$fonts[0],
      -align=>'center',
    #-valign => "center",   #这个用不了太可惜了
        -pos  => [50,15],
        -size => [400,40],
        -text => $showtext,
     -background => [7,102,198], ###蓝色
   #  -bandborders => 1,
   #  -visible =>1,
    
);


####
###### 创建一个label，来容纳主体部分#############
###### 可以注释这个部分       ##################
$main_window->AddLabel(
        -name => 'CAS',

        -pos  => [50,85],
        -size => [400,530],
     #-frame => black/gray/white/etched/none
     -frame => 'etched',
     -fill =>'white',
        -sunken   => 1,# (default 0)
    # -background =>'red', ###蓝色
     -bandborders => 1,
     -visible =>1,
    
);
##################################################

######创建小标题 cid 号码文件:

$showtext=&showcode('cid 号码文件:');   
$main_window->AddLabel(
        -name => 'fieldcas',
        -font =>$fonts[0],
      -align=>'left',
    #-valign => "center",
        -pos  => [$label_x,$beginy],
        -size => $label_size,
        -text => $showtext,
    #    -background => $colors[1], ###
   #  -bandborders => 1,
   #  -visible =>1,
    
);  

####创建浏览文件的按钮
$topy+=$indexy;
$main_window->AddButton(
                   -name   => 'selectfile',
                   -left   => $left,
                   -top    => $topy,
                   -text   => 'SelectCidFile:',
                    -size=> $but_size,
                    -font =>$fonts[2]
                 
               
                  ); 
sub selectfile_Click             #应该是回调函数自动执行的
{
  
     my $filee= Win32::GUI::GetOpenFileName(
                                  -owner    => $main_window,
                                  -title    => "Select  cas file",
                               
                                
                                 )  or die "can't get open";

#     print Dumper($filee);  
#     print "$filee\n";
     $cidfile=$filee;
     $main_window->cidtext->Text($cidfile);
    # return $file;                       
    return 1;


}  
##################创建一个文本，自动填充cid文件的路径################

 $main_window->AddTextfield(
                   -name   => 'cidtext',
                   -left   => $left2,
                   -top    => $topy,
                   -text   => "cid file path",
                   -size => $text_size,
                   -font =>$fonts[1],

               
                  );
                  
#############################################################

#################### 创建一个文本框 用来存放cid号码
#################### 在文本框右侧怎么添加一个进度，方便查看？？？
$topy+=$indexy+10;
$showtext=
"选择存放cid号码的文件\r\n
或者直接把cid号码粘贴\r\n
到这个文本框里\r\n
一行一个cid号码\r\n
覆盖这里的文字";

$showtext=&showcode($showtext);  
my $fixedtext=$showtext;
 $main_window->AddTextfield(
                   -name   => 'cids',
                   -left   => $left2-55,
                   -top    => $topy,
                   -text   => $showtext,
                   -width => $text_size->[0],
                   -height=>180,
                   -font =>$fonts[1],
                    -multiline=>1,                #开启多行模式
                   -hscroll=> 1,               #开启垂直方向的进度模式
							    -vscroll   => 1,
							    -autohscroll => 1,
							    -autovscroll => 1,
							    -keepselection => 1 ,
                  );



###label下载目录
$topy+=$indexy+150;
$showtext=showcode('下载目录:');
$main_window->AddLabel(
        -name => 'fielddir',
        -font =>$fonts[0],
         -align=>'left',
    #-valign => "center",
        -top=> $topy,
        -left=>$left,
        -size =>$label_size,
        -text => $showtext,
     #   -background => $colors[1],
   #  -background => [7,102,198], ###蓝色
   #  -bandborders => 1,
   #  -visible =>1,
    
); 
####选择下载目录
############增加选择下载目录的按钮###################
$topy+=$indexy;

 $main_window->AddButton
(
	
	
   -name   => 'selectdir',
   -left   => $left,
   -top    => $topy,
   -text   => 'SelectDir:',
   -size => $but_size,

	
);

######增加填充目录路径的文本fonts

 $main_window->AddTextfield(
                   -name   => 'dirpath',
                   -left   => $left2,
                   -top    => $topy,
                   -text   => "download dir",
                   -size=> $text_size,
                   -font =>$fonts[1],
                  );
                  
###################添加事件函数

sub selectdir_Click
{

      my $Dir = Win32::GUI::BrowseForFolder (
                        -title     => "Select download directory",
                        #-directory => $Directory,
                        -folderonly => 1,
                        );

     $main_window->dirpath->Text($Dir);
    # return $file;                       
    return 1;

	
	
}










#####################################################
###添加下载按钮
################添加一个下载按钮
$topy+=$indexy;
$main_window->AddButton
(
	
	
   -name   => 'download',
   -left   => $left+100,
   -top    => $topy,
   -text   => 'DownLoad',
   -size=> [200,50],

);

#进度条
$topy+=$indexy+20;
my $progressbar =
  $main_window->AddProgressBar(
                          -left   => $left,
                          -top    => $topy,
                          -width  => 390,
                          -height => 30,
                           -background=>[0,0,85],
                          -smooth => 1,
                         );
                         
$progressbar->Show(0);  #hide progressbar,执行下载程序的时候再显示进度条
$progressbar->Show(1);  #show progressbar

######################添加下载click按钮，执行的回调函数
             
#$main->MessageBox


sub download_Click
{
	my $cidfile;
	my $downdir;
	my $cidtext;
	my @cids;
	
	

	
	####判断是否定义下载目录
	
	if($main_window->dirpath->Text() eq 'download dir')
	{
		
			
		$main_window->MessageBox("please specify the download dir");  #弹出对话框
		return 1;
		
		
	}
	else
	{
		$downdir=$main_window->dirpath->Text();
		$downdir=$downdir.'/';
	}
	
	
		##判断cid文件是否存在 文本框中是否是cid号码
	if( $main_window->cidtext->Text()  eq "cid file path")   
	{
		#print "please slect a file\n";
	#	$main_window->MessageBox($fixedtext );
		if($main_window->cids->Text() eq $fixedtext)   #怎么检测文本是否变化
		{
		$main_window->MessageBox("please select cid file path");  #弹出对话框
		return 1;
	  }
	  else
	  {
	  	my $text=$main_window->cids->Text();
	  	@cids=$text=~/(\d+)/g;
	  	
	  }
	}
	else
	{
		$cidfile=$main_window->cidtext->Text();
		open FH,$cidfile;
		@cids=<FH>;
		chomp(@cids);
		
		
	}
	
	my $numofmol=@cids;
 	        $progressbar->Show(0);
        $progressbar->Show(1);
        $progressbar->SetRange( 0, $numofmol );
        for ( 1 .. $numofmol ) {
            my $cid  = $cids[ $_ - 1 ];
           
            &downcid($cid,$downdir); #第一个参数是cid，第二个参数是下载目录，第三个参数是type
            Win32::GUI::DoEvents();    ###这一句话是什么意思？
            $progressbar->SetStep(1);
            $progressbar->StepIt();
         #   Win32::Sleep(1000);
        }
	
	

	
	return 1;
	

	
}
     

$main_window->Show();
Win32::GUI::Dialog();
#Win32::GUI::Show($DOS);


__END__
my $theListBox = $main_window->AddListbox(
    -name     => "TheListBox",
    -text     => "&The List Box",
    -top      => $topy,
    -left     => 15,
    -height   => 120,
    -width    => 120,
    -multisel => 0,
);
$theListBox->InsertItem('0');
$theListBox->InsertItem('1');
$theListBox->InsertItem('2');
$theListBox->InsertItem('3');
$theListBox->InsertItem('4');
$theListBox->InsertItem('5');
$theListBox->InsertItem('6');
$theListBox->InsertItem('7');