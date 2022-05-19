FROM registry.access.redhat.com/ubi8/python-39:1-51
USER 0
RUN mkdir -p /opt/bastion
COPY requirements.txt /opt/bastion
RUN  chown -R 1001:0 /opt/bastion

#Install requirements and awscli
RUN pip install --upgrade pip && \
    pip install -r /opt/bastion/requirements.txt

#Install requirements and azurecli
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

RUN echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/azure-cli.repo
RUN echo -e "[google-cloud-cli]\nname=Google Cloud CLI\nbaseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=0\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg\nhttps://packages.cloud.google.com/yum/doc/rpm-package-key.gpg"| tee /etc/yum.repos.d/google-cloud-sdk.repo


RUN dnf install -y dnf-utils && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    dnf install -y terraform git vim curl jq azure-cli

RUN wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz" && \
    tar -xvf openshift-client-linux.tar.gz && \
     chmod u+x oc kubectl && \
     mv oc /usr/local/bin && \
     mv kubectl /usr/local/bin 

USER 1001
WORKDIR /opt/bastion
CMD ["sh", "-c", "tail -f /dev/null"]
