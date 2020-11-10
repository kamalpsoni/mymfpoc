FROM ubuntu:16.04

#update and get pre-requisites
RUN apt-get update && apt-get install -y \
  open-cobol \
  gcc

#copy file to image
COPY helloworld.cbl /helloworld.cbl

#compile the code
RUN cobc -x -free -o helloworld helloworld.cbl

#run
CMD ["/helloworld"]
