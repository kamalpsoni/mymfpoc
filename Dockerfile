# Copyright (C) Micro Focus 2018. All rights rese

FROM rhel7/rhel:latest
#FROM ubuntu:16.04
 # PRODUCT_VERSION is product version associated w
 # SETUP_EXE is the build-arg name for the name of
 # ACCEPTEULA is the build-arg name for the accept
 # MFLICFILE is the build-arg name for the license

ARG PRODUCT_VERSION=4.0.00
ARG SETUP_EXE=setup_cobol_server_for_docker_4.0_redhat_x64
ARG ACCEPTEULA
ARG LOGFILE=COBOLServer4.0.log
ARG MFLICFILE

ARG ESADM_UID=500
ARG ESADM_GID=500
ARG ESADM_USER=esadm
ARG ESADM_SHELL=/bin/bash

LABEL vendor="Micro Focus" \
      com.microfocus.name="COBOL Server" \
      com.microfocus.version="$PRODUCT_VERSION" \
      
      com.microfocus.eula.url="https://supportline.microfocus.com/licensing/agreements.aspx" \
      com.microfocus.is-base-image="true"
      

ENV MFPRODBASE=/opt/microfocus/VisualCOBOL
ENV MFLICBASE=/var/microfocuslicensing

# install ed and pax, as these are a pre-req for 
# note: disablerepo is used to avoid "HTTPS Error
RUN yum --disablerepo=rhel-7-server-rt-beta-rpms -y install ed pax 
##RUN apt-get --disablerepo=rhel-7-server-rt-beta-rpms

# copy the installer from the local machine to th
COPY ${SETUP_EXE} /tmp/${SETUP_EXE}

# Create user esadm
RUN groupadd -f -g $ESADM_GID $ESADM_USER && \
    useradd -u $ESADM_UID -g $ESADM_GID -m -s $ES

# ensure the setup exe has execute permissions an
RUN chmod +x ./tmp/${SETUP_EXE} && \
   
    (/tmp/$SETUP_EXE -${ACCEPTEULA} -ESadminID=$ESADM_USER || (echo ${LOGFILE} contains && touch ${LOGFILE} && cat ${LOGFILE} && exit 1)) && \
    rm -f tmp/${SETUP_EXE} && \
    echo "$MFPRODBASE/lib" >>/etc/ld.so.conf && \
    ldconfig

# install a license and remove the license file
COPY ${MFLICFILE} /tmp/
RUN cd /tmp && $MFLICBASE/bin/MFLicenseAdmin -ins
#
# clean up for containers that use -network:host
#
RUN  $MFLICBASE/bin/clean_guid_file
