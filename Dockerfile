FROM registry.access.redhat.com/ubi8/python-39:latest
USER 0
RUN mkdir -p /opt/bastion
COPY requirements.txt /opt/bastion
RUN  chown -R 1001:0 /opt/bastion

RUN dnf update -y --allowerasing
#install python requirements
RUN pip install --upgrade pip && \
    pip install -r /opt/bastion/requirements.txt

#azurecli repo
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm

#google repo
ADD google-cloud-cli.repo /etc/yum.repos.d/google-cloud-sdk.repo


RUN dnf install -y dnf-utils && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    dnf install -y terraform git vim curl jq azure-cli google-cloud-cli

RUN wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz" && \
    tar -xvf openshift-client-linux.tar.gz && \
     chmod u+x oc kubectl && \
     mv oc /usr/local/bin && \
     mv kubectl /usr/local/bin 

#install rosa-cli
RUN wget "https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/rosa-linux.tar.gz" && \
    tar -xvf rosa-linux.tar.gz && \
    chmod u+x rosa && \
    mv rosa /usr/local/bin

#install skupper-cli
RUN wget "https://github.com/skupperproject/skupper/releases/download/1.0.2/skupper-cli-1.0.2-linux-amd64.tgz" && \
    tar -xvf skupper-cli-1.0.2-linux-amd64.tgz && \
    chmod u+x skupper && \
    mv skupper /usr/local/bin

#install ibmcloud sdk
RUN wget "https://clis.cloud.ibm.com/install/linux" && \
    mv linux ibmcloud-setup && \
    chmod +x ibmcloud-setup && \
    sh ibmcloud-setup

#USER 1001
WORKDIR /opt/bastion
CMD ["sh", "-c", "tail -f /dev/null"]
