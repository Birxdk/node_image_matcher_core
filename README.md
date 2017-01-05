# Base docker image for pHash and node.js 
Only building the core image needed to use pHash in docker and node.js.

It includes node.js phash wrapper (https://github.com/aaronm67/node-phash) which is built at the end.

**Dependencies**
To make pHash work, following libraries must be installed on the machine which will be handled in the docker build script:
`CImg` 
`mpg123`
`libsndfile`
`libsamplerate`
`pHash`

All these libs are included in the libs folder as they failed during the docker build or are not available using apt-get anymore.
Its included in the libs folder here.

Since this is for image matching only the installation of phash will have these flags added to the build command.
`--enable-video-hash=no --enable-audio-hash=no LDFLAGS='-lpthread'` 

**Docker**
Build
`docker build -t image_matcher_core .`