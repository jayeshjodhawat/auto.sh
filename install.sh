#!/bin/bash

mkdir ~/Broly
chmod +x auto.sh
cp auto.sh /usr/bin
echo "auto.sh Ready to use"
mkdir ~/Broly/findomain
mkdir ~/recondata
mkdir ~/recondata/automatd
cp pwords.txt ~/Broly
#-------------------------------------------------------------#
echo "Copying JSfileScanner.sh > /usr/bin" #(By dark_warlord14) https://twitter.com/dark_warlord14?s=20 You can find the article related to this script here https://securityjunky.com/scanning-js-files-for-endpoint-and-secrets/ 
cp JSfileScanner.sh /usr/bin
#----------------------------------------------------------#
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt install snapd


sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y jq
sudo apt-get install -y ruby-full
sudo apt-get install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
sudo apt-get install -y python-setuptools
sudo apt-get install -y libldns-dev
sudo apt-get install -y python3-pip
sudo apt-get install -y python-pip
sudo apt-get install -y python-dnspython
sudo apt-get install -y git
sudo apt-get install -y rename
sudo apt-get install -y xargs

echo "installing bash_profile aliases from recon_profile"
git clone https://github.com/nahamsec/recon_profile.git
cd recon_profile
cat bash_profile >> ~/.bash_profile
source ~/.bash_profile
cd ~/tools/
echo "done"



install go
if [[ -z "$GOPATH" ]];then
echo "It looks like go is not installed, would you like to install it now"
PS3="Please select an option : "
choices=("yes" "no")
select choice in "${choices[@]}"; do
        case $choice in
                yes)

					echo "Installing Golang"
					wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
					sudo tar -xvf go1.13.4.linux-amd64.tar.gz
					sudo mv go /usr/local
					export GOROOT=/usr/local/go
					export GOPATH=$HOME/go
					export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
					echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile
					echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile			
					echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile	
					source ~/.bash_profile
					sleep 1
					break
					;;
				no)
					echo "Please install go and rerun this script"
					echo "Aborting installation..."
					exit 1
					;;
	esac	
done
fi
#----------------------------------------------------------#
echo "Now installing important Tools"
cd ~/Broly
echo "Istalling Amass"
snap install amass #(By Danielmiessler) https://twitter.com/DanielMiessler?s=20 | https://twitter.com/jeff_foley?s=20 | https://twitter.com/owaspamass?s=20
echo "Installing assetfinder"
go get -u github.com/tomnomnom/assetfinder #(By Tomnomnom) https://twitter.com/TomNomNom?s=20
echo "Installing CSP"
go get -u github.com/edoverflow/csp #(By Tomnomnom) https://twitter.com/TomNomNom?s=20
echo "Installing Subfinder"
go get -v github.com/projectdiscovery/subfinder/cmd/subfinder #(By projectdiscovery)
echo "Cloning Massdns"
git clone https://github.com/blechschmidt/massdns.git #(By blechschmidt) 
echo "Installing Sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git #(By aboul3la) https://twitter.com/aboul3la?s=20
echo "Installing Httporbe"
go get -u github.com/tomnomnom/httprobe #(By Tomnomnom) https://twitter.com/TomNomNom?s=20
echo "Installing Filter-Resolved"
go get github.com/tomnomnom/hacks/filter-resolved #(By Tomnomnom) https://twitter.com/TomNomNom?s=20
echo "Installing fprobe"
go get -u github.com/theblackturtle/fprobe #By(theblackturtle)
echo "Installing Aquatone"
go get github.com/michenriksen/aquatone #(BY michenriksen) https://twitter.com/michenriksen?s=20
echo "Cloning Linkfinder"
git clone https://github.com/dark-warlord14/LinkFinder #(By GerbenJavado) https://twitter.com/gerben_javado?s=20
echo "Cloning acao"
curl --url https://raw.githubusercontent.com/tomnomnom/dotfiles/master/scripts/acao > cors.sh && mv cors.sh /usr/bin && cd /usr/bin && chmod +x cors.sh #(By Tomnomnom) https://twitter.com/TomNomNom?s=20
#------------------------------------------------------------#
apt install wget -y
pip install py-altdns #(By infosec_au) https://twitter.com/infosec_au?s=20 
#------------------------------------------------------------#
echo "Installing Findomain"
cd ~/Broly/findomain*
sudo wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux -O findomain
chmod +x findomain
#-------------------------------------------------------------#
echo "Installing Sublist3r"
cd ~/Broly/Sublist3r*
pip install -r requirements.txt
echo "done"
#-------------------------------------------------------------#
echo "Installing Massdns"
cd ~/Broly/massdns*
make 
cp /lists/resolvers.txt /usr/share/wordlists/resolvers.txt
#-------------------------------------------------------------#
echo "Installing Linkfinder"
cd ~/Broly/LinkFinder*
pip3 install -r requirements.txt
python3 setup.py install
#-------------------------------------------------------------#
echo "Copying Every Go tools in /usr/bin"
cd
cp ~/Broly/massdns*/bin/massdns /usr/bin
cp ~/Broly/findomain*/findomain /usr/bin/
cp ~/go/bin/httprobe /usr/bin
cp ~/go/bin/fprobe /usr/bin
cp ~/go/bin/aquatone /usr/bin
cp ~/go/bin/assetfinder /usr/bin
cp ~/go/bin/subfinder /usr/bin
cp ~/go/bin/filter-resolved /usr/bin
echo "Installation Completed,You are Good to Go ;)"
echo 'Please add your ""securitytrails_key"" in /usr/bin/auto.sh'
