FROM mjmg/centos-supervisor-base:latest

ENV MRO_VERSION 3.5.3


# Update System Image
RUN \
  dnf update -y && \
  dnf upgrade -y 
 

# Install Development Tools
RUN \
  dnf groupinstall -y 'Development Tools'


# Install R-core dependencies
RUN \
  dnf install -y --allowerasing libcurl
  #&& \
RUN \  
  dnf install -y java-11-openjdk-devel 
  #&& \
RUN \    
  dnf deplist R-core | awk '/provider:/ {print $2}' | sort -u | xargs dnf -y --allowerasing --skip-broken install  && \
RUN \    
  dnf erase -y openblas-Rblas libRmath


# Get Microsoft R Open
RUN \
  cd /tmp/ && \
  wget https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/microsoft-r-open-$MRO_VERSION.tar.gz && \
  tar -xvzf microsoft-r-open-$MRO_VERSION.tar.gz


# Unattended install of MRO
RUN \
  /tmp/microsoft-r-open/install.sh -a -u


# Setup default CRAN repo, otherwise default MRAN repo snapshot is used
# RUN \
#   echo "r <- getOption('repos'); r['CRAN'] <- 'https://cloud.r-project.org/'; options(repos = r);" > ~/.Rprofile


# Build packages with multiple threads
#RUN \
#  MAKE="make $(nproc)"

CMD "/bin/bash"
