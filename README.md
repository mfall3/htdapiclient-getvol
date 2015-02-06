HathiTrust Data API Client getvol.pl
====================================

This is a perl 2-legged oauth client that makes a request to the full HathiTrust Data API as documented at http://www.hathitrust.org/data_api. 

Replace OAUTH_CONSUMER_SECRET and OAUTH_CONSUMER_KEY with the keys you received from http://babel.hathitrust.org/cgi/kgs and MY_IP_ADDRESS by the IP address of server running this script.

It uses a hardcoded URL to and URL parameters to request an aggregate zip file of page images and text.