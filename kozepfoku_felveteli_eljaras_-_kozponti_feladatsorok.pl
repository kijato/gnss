use strict;
use WWW::Mechanize;

my $url = "https://www.oktatas.hu/kozneveles/kozepfoku_felveteli_eljaras/kozponti_feladatsorok";
my $mech = WWW::Mechanize->new();

#$mech->proxy(['http','https'],'http://xxx.xxx.xxx.xxx:xxxx/');
print $mech->status()."\n";
$mech->get($url) || die "$!";
#die unless ($mech->success);
#print $mech->content;

#https://www.oktatas.hu/kozneveles/kozepfoku_felveteli_eljaras/kozponti_feladatsorok/2002_evi_irasbeli
#my @links = $mech->find_all_links( url_regex =>  qr/(20\d{2})_evi_irasbeli/i );

#https://www.oktatas.hu/kozneveles/kozepfoku_felveteli_eljaras/kozponti_feladatsorok/irasbeli2003ev
#my @links = $mech->find_all_links( url_regex =>  qr/irasbeli(20\d{2})ev/i );

#https://www.oktatas.hu/kozneveles/kozepfoku_felveteli_eljaras/kozponti_feladatsorok/2007evi_6_8osztalyos
#my @links = $mech->find_all_links( url_regex =>  qr/(20\d{2})evi_6_8osztalyos/i );

#https://www.oktatas.hu/kozneveles/kozepfoku_felveteli_eljaras/kozponti_feladatsorok/2004evi_9evfolyamra
my @links = $mech->find_all_links( url_regex =>  qr/(20\d{2})evi_9evfolyamra/i );
for my $link ( @links ) {
	my $url = $link->url_abs;
	print "Fetching $url ...\n";
	$mech->get($url);
	my @pdflinks = $mech->find_all_links( url_regex =>  qr/(.pdf|.doc)$/i );
	for my $pdflink ( @pdflinks ) {
		my $pdfurl = $pdflink->url_abs;
		$pdfurl =~ /(\d{4})/;
		my $ev = $1;
		my $pdffilename = $pdfurl;
		print "\t$pdffilename\n";
		$pdffilename =~ s[^.+/][];
		$mech->get($pdfurl, ':content_file' => "$ev-$pdffilename");
	}
}
