FROM registry.access.redhat.com/ubi8/python-39

USER 0
RUN mkdir -p /opt/redhat/automacao
COPY requirements.txt /opt/redhat/ 
RUN chown -R 1001:0 /opt/redhat

#Install requirements and awscli
RUN pip install --upgrade pip && \
    pip install -r /opt/redhat/requirements.txt

#Install requirements and azurecli
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc

RUN echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/azure-cli.repo

RUN dnf install -y dnf-utils && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    dnf install -y terraform git vim curl jq maven azure-cli

RUN wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz" && \
    tar -xvf openshift-client-linux.tar.gz && \
    chmod u+x oc kubectl && \
    mv oc /usr/local/bin && \
    mv kubectl /usr/local/bin 

RUN git clone https://github.com/keycloak/keycloak-benchmark.git 

#USER 1001
WORKDIR /opt/redhat

#ADD . rh-ansible-aws



CMD ["sh", "-c", "tail -f /dev/null"]
