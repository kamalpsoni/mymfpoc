FROM microfocus/cobolserver:win_4.0_x86

#update and get pre-requisites
RUN apt-get update && apt-get install -y \
  docker load -i ./ibm-cics-tx-on-cloud-docker-image-10.1.0.0.tar.gz \
  gcc

#copy file to image
COPY helloworld.cbl /helloworld.cbl

#compile the code
RUN cobc -x -free -o helloworld helloworld.cbl

#run
CMD ["/helloworld"]
