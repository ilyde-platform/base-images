FROM ubuntu:18.04

LABEL maintainer="Ilyde <tony.wilson@hopenly.com>"

ENV DEBIAN_FRONTEND noninteractive

#create a Ubuntu User
RUN \
  groupadd -g 12574 ubuntu && \
  useradd -u 12574 -g 12574 -m -N -s /bin/bash ubuntu && \

  apt-get update -y && \
  apt-get -y install software-properties-common && \
  apt-get -y upgrade && \
  # CONFIGURE locales
  apt-get install -y locales && \
  locale-gen en_US.UTF-8 && \
  dpkg-reconfigure locales && \
  # INSTALL common
  apt-get -y install build-essential wget sudo curl apt-utils git vim python3-pip -y && \
  #Install jdk
  apt-get install openjdk-8-jdk -y && \
  update-alternatives --config java && \
  echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /home/ubuntu/.ilyde-defaults && \
  # ADD SSH start script for ssh'ing to run container in Ilyde <v4.0
  apt-get install -y openssh-server && \
  mkdir -p /scripts && \
  printf "#!/bin/bash\\nservice ssh start\\n" > /scripts/start-ssh && \
  chmod +x /scripts/start-ssh && \
  echo 'export PYTHONIOENCODING=utf-8' >> /home/ubuntu/.ilyde-defaults && \
  echo 'export LANG=en_US.UTF-8' >> /home/ubuntu/.ilyde-defaults && \
  echo 'export JOBLIB_TEMP_FOLDER=/tmp' >> /home/ubuntu/.ilyde-defaults && \
  echo 'export LC_ALL=en_US.UTF-8' >> /home/ubuntu/.ilyde-defaults && \
  locale-gen en_US.UTF-8 && \
  #Clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -Rf /tmp/*
    
ENV LANG en_US.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

###### Install R #####
ARG R_VERSION=4.0.2
ARG OS_IDENTIFIER=ubuntu-1804

# Install R
RUN wget https://cdn.rstudio.com/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_amd64.deb && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm r-${R_VERSION}_1_amd64.deb && \
# INSTALL R packages required by Ilyde
    R -e 'options(repos=structure(c(CRAN="http://cran.us.r-project.org"))); install.packages(c( "plumber","yaml", "shiny"))' && \
#    chown -R ubuntu:ubuntu /usr/local/lib/R/site-library && \
#Cleanup
    rm -rf /var/lib/apt/lists/* && \
    rm -Rf /tmp/*

######Install Python and Miniconda######

# https://repo.continuum.io/miniconda/
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH 
ENV MINICONDA_VERSION 4.7.12.1     
ENV MINICONDA_MD5 81c773ff87af5cfac79ab862942ab6b3
ENV PYTHON_VER 3.7


#set env variables so they are available in Ilyde jobs/workspaces
RUN \
    echo 'export CONDA_DIR=/opt/conda' >> /home/ubuntu/.ilyde-defaults && \
    echo 'export PATH=$CONDA_DIR/bin:$PATH' >> /home/ubuntu/.ilyde-defaults  && \
    echo 'export PATH=/home/ubuntu/.local/bin:$PATH' >> /home/ubuntu/.ilyde-defaults && \
    echo 'export PATH=/opt/code-server:$PATH' >> /home/ubuntu/.ilyde-defaults && \
    cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "${MINICONDA_MD5} *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    conda install python=${PYTHON_VER} && \
#make conda folder permissioned for ubuntu user
    chown ubuntu:ubuntu -R $CONDA_DIR && \
# Use Mini-conda's pip
    ln -s $CONDA_DIR/bin/pip /usr/bin/pip && \
    pip install --upgrade pip && \
# Use Mini-conda's python   
    ln -s $CONDA_DIR/bin/python /usr/local/bin/python && \
    ln -s $CONDA_DIR/anaconda/bin/python /usr/local/bin/python3  && \
#Set permissions
    chown -R ubuntu:ubuntu  $CONDA_DIR && \
###Install Ilyde Dependencies ####  
   $CONDA_DIR/bin/conda install -c conda-forge uWSGI==2.0.18

######### Install ILyde requirements ####################
RUN  apt-get update -y && apt-get -y install s3fs

RUN \
    wget https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod a+x mc && \
    mv ./mc /usr/bin

RUN apt-get install -y fuse libfuse-dev libxml2-dev

RUN pip install click==7.1.2 etcd3==0.12.0 grpc-interceptor==0.12.0 grpcio==1.34.0 minio==6.0.0

RUN pip install python-decouple==3.3 watchdog==0.10.4 grpcio-tools==1.34.0 mlflow==1.12.1 boto3==1.16.41 pika websockets==8.1

#### Installing Notebooks,Workspaces,IDEs,etc ####

# Clone in workspaces install scripts
# Add workspace configuration files
COPY workspace-configs/. /var/opt/workspaces

RUN  rm -rf /var/opt/workspaces/workspace-logos

RUN \
    mv /var/opt/workspaces/rstudio/.Rprofile /home/ubuntu/.Rprofile && \
    chown ubuntu:ubuntu /home/ubuntu/.Rprofile && \

# # # # #Install Rstudio from workspaces
    chmod +x /var/opt/workspaces/rstudio/install  && \
    /var/opt/workspaces/rstudio/install && \

# # # # # #Install Jupyterlab from workspaces
    chmod +x /var/opt/workspaces/Jupyterlab/install && \
    /var/opt/workspaces/Jupyterlab/install && \
 
# # # #Install Jupyter from workspaces
    chmod +x /var/opt/workspaces/jupyter/install && \
    /var/opt/workspaces/jupyter/install && \
    
#Required for VSCode
    apt-get update && \
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install libssl1.0-dev node-gyp nodejs -y && \
    pip install python-language-server autopep8 flake8 && \
    rm -rf /var/lib/apt/lists/* && \
    
# # #Install vscode from workspaces
    chmod +x /var/opt/workspaces/vscode/install && \
    /var/opt/workspaces/vscode/install && \

#Fix permissions so notebooks start
   chown -R ubuntu:ubuntu /home/ubuntu/.local/

#Provide Sudo in container
RUN echo "ubuntu    ALL=NOPASSWD: ALL" >> /etc/sudoers

# permissions for conda dir
RUN chown -R ubuntu:ubuntu  $CONDA_DIR

#Create Ilyde Working directory
RUN mkdir /ilyde && chown ubuntu:ubuntu -R /ilyde
WORKDIR /ilyde