#!/bin/bash

# Check if a domain argument is provided
if [ -z "$1" ]; then
  echo "Usage: ./script.sh <domain>"
  exit 1
fi

domain="$1"

# Run subfinder, assetfinder, findomain, knockpy.py, and github-subdomains.py, and redirect their output to a file
(
  subfinder -d "$domain"
  assetfinder -subs-only "$domain"
  findomain -t "$domain" 
  crobat -s "$domain"
) | sort | uniq > subdomain.txt

echo -e "${green}All tools have finished running. The output is saved in subdomain.txt${reset}"
Filter live domains(){
	echo -e "${green}Filter live domains using httpx..${reset}"
cat subdomain.txt | httpx -silent | grep "$domain" | tee livesubdomain.txt 
cat livesubdomain.txt | waybackurls | httpx -silent -sc -title | tee httpx-hosts.txt 
cat httpx-hosts.txt | grep 200 | grep "$domain" | cut -d' ' -f1 | tee hosts-200.txt 
cat httpx-hosts.txt | grep 404 | grep "$domain" | cut -d' ' -f1 | tee hosts-404.txt 
cat httpx-hosts.txt | grep 301 | grep "$domain" | cut -d' ' -f1 | tee hosts-301.txt 
cat httpx-hosts.txt | grep 403 | grep "$domain" | cut -d' ' -f1 | tee hosts-403.txt 
cat httpx-hosts.txt | grep 302 | grep "$domain" | cut -d' ' -f1 | tee hosts-302.txt
}
get_interesting(){
	echo -e "${green}find interesting data in site...${reset}"
cat httpx-hosts.txt | gf interestingEXT | grep -viE '(\.(js|css|svg|png|jpg|woff))' | qsreplace -a | httpx -mc 200 -silent | awk '{ print $1}' > interesting.txt
}

#echo "Live domains have been filtered and saved in live_domains.txt."
