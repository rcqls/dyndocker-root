FROM rocker/r-base:latest

MAINTAINER "Cqls Team"


## Install devtools R package and its dependencies
RUN apt-get update \
    && apt-get install -y libxml2-dev  libcurl4-openssl-dev libssl-dev \
    && install.r devtools

## Ruby Stuff

RUN apt-get install -y curl procps \
    && apt-get install -y git

ENV RUBY_MAJOR 2.1
ENV RUBY_VERSION 2.1.5

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get install -y bison ruby ruby-dev

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

## Pandoc

RUN apt-get install -y pandoc

## Ttm 

RUN mkdir -p /tmp/ttm

WORKDIR /tmp/ttm

RUN wget http://hutchinson.belmont.ma.us/tth/mml/ttmL.tar.gz

RUN tar xzvf ttmL.tar.gz

WORKDIR /tmp/ttm/ttmL

RUN mkdir -p /root/bin

ENV PATH /root/bin:$PATH

RUN ./ttminstall

RUN rm -fr /tmp/ttm

## R:		/dyndoc-library/R
ENV R_LIBS_USER /dyndoc-library/R



# cleanup package manager

RUN apt-get autoclean && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## the dyndoc projects folder

RUN mkdir -p /dyndoc-proj

VOLUME /dyndoc-proj

WORKDIR /dyndoc-proj



## END


