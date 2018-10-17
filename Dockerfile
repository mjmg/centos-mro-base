FROM mjmg/centos-supervisor-base:latest

ENV MRO_VERSION 3.5.1


# Update System Image and install EPEL
RUN \
  yum update -y && \
  yum upgrade -y && \
  yum install -y epel-release


# Install Development Tools
RUN \
  yum groupinstall -y 'Development Tools'


# Install R-core dependencies
RUN \
  yum install -y java-1.8.0-openjdk-headless && \
  yum deplist R-core | awk '/provider:/ {print $2}' | sort -u | xargs yum -y install && \
  yum erase -y openblas-Rblas libRmath


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
