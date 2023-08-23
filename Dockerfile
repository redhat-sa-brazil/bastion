FROM registry.access.redhat.com/ubi9/python-39:latest
ARG TARGETPLATFORM
ARG BUILDPLATFORM
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
RUN dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm

#google repo
ADD google-cloud-cli.repo /etc/yum.repos.d/google-cloud-sdk.repo

RUN dnf install -y dnf-utils && \
    dnf install -y git vim jq azure-cli google-cloud-cli

RUN wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux-$BUILDPLATFORM.tar.gz" && \
    tar -xvf openshift-client-linux-$BUILDPLATFORM.tar.gz && \
     chmod u+x oc kubectl && \
     mv oc /usr/local/bin && \
     mv kubectl /usr/local/bin 

RUN wget "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-install-linux-$BUILDPLATFORM.tar.gz" && \
    tar -xvf openshift-install-linux-$BUILDPLATFORM.tar.gz && \
     chmod u+x openshift-install && \
     mv openshift-install /usr/local/bin

#install rosa-cli
RUN wget "https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/rosa-linux.tar.gz" && \
    tar -xvf rosa-linux.tar.gz && \
    chmod u+x rosa && \
    mv rosa /usr/local/bin

#USER 1001
WORKDIR /opt/bastion
CMD ["sh", "-c", "tail -f /dev/null"]
