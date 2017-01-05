# docker build -t image_matcher_core .

FROM node:6.8.0

RUN mkdir -p /usr/src/image_matcher_core
RUN mkdir -p /usr/src/image_matcher_core/libs
WORKDIR /usr/src/image_matcher_core

LABEL vendor=BirxLabs

# apt-get fails getting this package so included it manually
COPY ./libs/libusb-1.0-0_1.0.19-1_amd64.deb /usr/src/image_matcher_core/libs
RUN dpkg -i ./libs/libusb-1.0-0_1.0.19-1_amd64.deb

ADD ./libs/libsndfile-1.0.27.tar.gz /usr/src/image_matcher_core/libs
RUN cd /usr/src/image_matcher_core/libs/libsndfile-1.0.27 \
	&& ./configure \ 
	&& make \
	&& make install

ADD ./libs/libsamplerate-0.1.8.tar.gz /usr/src/image_matcher_core/libs
RUN cd /usr/src/image_matcher_core/libs/libsamplerate-0.1.8 \
	&& ./configure \ 
	&& make \
	&& make install

ADD ./libs/mpg123-1.15.1.tar.bz2 /usr/src/image_matcher_core/libs
RUN cd /usr/src/image_matcher_core/libs/mpg123-1.15.1 \
	&& ./configure \ 
	&& make \
	&& make install

RUN apt-get update \
	&& apt-get install -y  --no-install-recommends --fix-missing cimg-dev

ADD ./libs/pHash-0.9.6.tar.gz /usr/src/image_matcher_core/libs
RUN cd /usr/src/image_matcher_core/libs/pHash-0.9.6 \
	&& ./configure --enable-video-hash=no --enable-audio-hash=no LDFLAGS='-lpthread'\
	&& make \
	&& make install


# Install and build the nodejs pHash wrapper
COPY ./libs/node/ /usr/src/image_matcher_core/libs
RUN npm i /usr/src/image_matcher_core/libs/node-phash -g

RUN ldconfig

# Lets do some house cleaning
RUN rm -rf /usr/src/image_matcher_core/libs

ENV version 1.0.0
