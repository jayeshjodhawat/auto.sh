#-------------------------------------------------------------
#
#Remove "#" if need to install any of this tools
#
#--------------------------------------------------------------
#git clone https://github.com/Edu4rdSHL/findomain.git
#go get -u github.com/tomnomnom/assetfinder
#go get -v github.com/projectdiscovery/subfinder/cmd/subfinder
#apt-get install amass
#git clone https://github.com/blechschmidt/massdns.git
#git clone https://github.com/aboul3la/Sublist3r.git
#go get -u github.com/tomnomnom/httprobe
#go get github.com/tomnomnom/hacks/filter-resolved
#go get -u github.com/theblackturtle/fprobe
#git clone https://github.com/michenriksen/aquatone.git
#cd && curl --url https://raw.githubusercontent.com/tomnomnom/dotfiles/master/scripts/acao > cors.sh && mv cors.sh /usr/bin && cd /usr/bin && chmod +x cors.sh (for install script of CORS)
#NOTE:even after installing every tools listed above if the script didn't seems working it's probably becoz of amass try using it on the different terminal
#----------------------------------------------------------------------------------------------------------------------------------------------------------
mkdir ~/recondata/automatd/$1
mkdir ~/recondata/automatd/$1/findings
mkdir ~/recondata/automatd/$1/final
cd ~/recondata/automatd/$1/findings
echo "Amass Scanning started"
	amass enum --passive -d $1 -o ~/recondata/automatd/$1/findings/amass.txt
echo "Findomain Scanning started"
	findomain -t $1 -u ~/recondata/automatd/$1/findings/findomain.txt
echo "Assetfinder Scanning started"
	assetfinder --subs-only $1 > ~/recondata/automatd/$1/findings/asset.txt
echo "Subfinder Scanning started"
	subfinder -d $1 > ~/recondata/automatd/$1/findings/subfinder.txt
echo "Sublist3r Scanning started"
	python ~/tools/Sublist3r/sublist3r.py -v -t 15 -b -d $1 -o ~/recondata/automatd/$1/findings/sublist3r.txt
echo "Crt.sh Scanning started"
	curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee -a ~/recondata/automatd/$1/findings/crt.txt
	cat ~/recondata/automatd/$1/findings/crt.txt | rev | cut -d "."  -f 1,2,3 | sort -u | rev | tee -a ~/recondata/automatd/$1/findings/crtsh.txt
echo "Removing crt.txt "
	rm ~/recondata/automatd/$1/findings/crt.txt
echo "Certspotter Scanning started"
	curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep -w $1\$ | tee ~/recondata/automatd/$1/findings/certspotter.txt
echo "Moving into folder _Final_"
	cd ../~/recondata/automatd/$1/final
echo "Creating Allrootdomains.txt"
	cat ~/recondata/automatd/$1/findings/*.txt | rev | cut -d "."  -f 1,2,3 | sort -u | rev | tee -a ~/recondata/automatd/$1/findings/allrootdomains.txt 	
echo "Massdns Scanning started"
	massdns -r /usr/share/wordlists/resolvers.txt -t A -o S ~/recondata/automatd/$1/findings/allrootdomains.txt -w ~/recondata/automatd/$1/findings/massdns.txt
echo "Extracting subdomains from massdns.txt"
	sed 's/A.*//' ~/recondata/automatd/$1/findings/massdns.txt | sed 's/CN.*//' | sed 's/\..$//' > ~/recondata/automatd/$1/findings/Subdomain_mass.txt
echo "Removing massdns.txt" 
	rm ~/recondata/automatd/$1/findings/massdns.txt
echo "Plain massdns Scanning"
	massdns -r /usr/share/wordlists/resolvers.txt -w ~/recondata/automatd/$1/final/massdns-op.txt ~/recondata/automatd/$1/findings/all.txt
echo "\n\n[+] Checking for alive domains..\n"
	cat ~/recondata/automatd/$1/findings/allrootdomains.txt | sort | filter-resolved | httprobe -c 40 > ~/recondata/automatd/$1/final/alive.txt
echo "fprobe Scanning started"
	cat ~/recondata/automatd/$1/final/alive.txt | fprobe -c 40 -v | grep ":200," > ~/recondata/automatd/$1/final/fprobe200.txt
echo "Finding CNAME"
	cat  ~/recondata/automatd/$1/findings/allrootdomains.txt | xargs -n 1 -I{} host -t CNAME {} > ~/recondata/automatd/$1/final/CNAME.txt
echo "Scanning for CORS"
	cors.sh ~/recondata/automatd/$1/final/alive.txt > ~/recondata/automatd/$1/final/CORS.txt
echo "Aquatone Started"
	cat ~/recondata/automatd/$1/final/alive.txt | aquatone -scan-timeout 500 -screenshot-timeout 40000 -out ~/recondata/automatd/$1/final/$1
