FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y git \
                       wget \
                       vim \
                       unzip && \

    # Setup Terraform 
    cd /usr/local/bin && \
    wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip && \
    unzip terraform_0.11.10_linux_amd64.zip && \
    rm -f terraform_0.11.10_linux_amd64.zip && \

    # Setup Packer
    cd /usr/local/bin && \
    wget https://releases.hashicorp.com/packer/1.4.0/packer_1.4.0_linux_amd64.zip && \
    unzip packer_1.4.0_linux_amd64.zip && \
    rm -f packer_1.4.0_linux_amd64.zip
