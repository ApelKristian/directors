#! /bin/bash

#call this comment on the VPS:
# wget -O - https://raw.githubusercontent.com/ApelKristian/directors/main/setup.sh | bash

#wait for all processes to finish
tail --pid=$pid -f /dev/null

#basic stuff
sudo apt-get install build-essential -y
sudo apt --fix-broken install -y && sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y
sudo apt-get install libcurl4-openssl-dev libssl-dev libxml2-dev libgit2-dev libpq-dev -y

#install R
sudo apt update -qq
sudo apt install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

sudo apt install --no-install-recommends r-base -y

#install R packages
sudo add-apt-repository ppa:c2d4u.team/c2d4u4.0+
sudo apt install --no-install-recommends r-cran-tidyverse -y

sudo R -e 'install.packages("httr2")'
sudo R -e 'install.packages("lubridate")'
sudo R -e 'install.packages("urltools")'
sudo R -e 'install.packages("cronR")'

#install RStudio Server
sudo apt-get install gdebi-core -y
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.07.2-576-amd64.deb
sudo gdebi rstudio-server-2022.07.2-576-amd64.deb

#add user for Rstudio Server
adduser defuser
usermod -aG sudo defuser

#install docker
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker defuser



#go manual from here
