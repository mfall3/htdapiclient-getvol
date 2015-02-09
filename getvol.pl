#!/usr/bin/env perl
=head1 NAME

getvol.pl

=head1 DESCRIPTION

This is a perl 2-legged oauth client that makes a request to
the full HathiTrust Data API as documented at http://www.hathitrust.org/data_api. 

Replace OAUTH_CONSUMER_SECRET and OAUTH_CONSUMER_KEY (below) 
with the keys you received from http://babel.hathitrust.org/cgi/kgs and 
MY_IP_ADDRESS by the IP address of server running this script.

It uses a hardcoded URL to and URL parameters to request an aggregate zip file of page images and text.

=head1 SYNOPSIS

At the Unix command line:

  % cd /path/to/getvol.pl/directory
  % chmod u+x getvol.pl

then:

  enter http://yourhost/path_to_client/getvol.pl?id=uc2.ark:/13960/t7fr00z97&filename=ark%2B%3D13960%3Dt7fr00z97.zip into a web browser or

  % curl 'http://yourhost/path_to_client/getvol.pl?id=uc2.ark:/13960/t7fr00z97&filename=ark%2B%3D13960%3Dt7fr00z97.zip' > ark+\=13960\=t7fr00z97.zip

If the resulting file is not a valid zip file, then rename it to error.html and view the file in a browser or text editor.

=cut

use strict;
use warnings;

use CGI qw/:standard/;
use OAuth::Lite::Consumer;
use OAuth::Lite::AuthMethod;

my $cgi = CGI->new();
my $id = $cgi->CGI::param('id');
my $filename = $cgi->CGI::param('filename');
$filename = "volume.zip" unless defined $filename;

my $access_key = 'OAUTH_CONSUMER_KEY';    # replace with your access_key
my $secret_key = 'OAUTH_CONSUMER_SECRET'; # replace with your secret_key
my $ip_address = 'MY_IP_ADDRESS';         # replace with the IP address of your server

my $request_url = "https://babel.hathitrust.org/cgi/htd/aggregate/$id";

my $consumer = OAuth::Lite::Consumer->new
  (
   consumer_key    => $access_key,
   consumer_secret => $secret_key,
   auth_method     => OAuth::Lite::AuthMethod::URL_QUERY,
  );

my $response = $consumer->request
  (
   method  => 'GET',
   url     => $request_url,
   params  => {
               v => '2',
               ip => $ip_address,
              },
  );

my $success = $response->is_success;

if ($success){
    print $cgi->header(-type => 'application/zip', -status => $response->status_line, -attachment => $filename);
    print $response->content;
}
else {
    print $cgi->header(-type => 'text/html', -status => $response->status_line -attachment => "error.html");
    print "<p><b>Error: " . $response->content . "</b><br/>";
}

exit ($success ? 0 : 1);
