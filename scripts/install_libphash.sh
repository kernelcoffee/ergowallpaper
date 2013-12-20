#!/bin/sh

# tested with Fedora19 and Centos 6.3

USER=`whoami`
version='pHash-0.9.6'
format='.tar.gz'
url='http://phash.org/releases/'
sha1='26f4c1e7ca6b77e6de2bdfce490b2736d4b63753'

# check for root
if [ $USER != 'root' ]
then
    echo 'exec as root'
    exit
fi

yum install libsndfile libsndfile-devel unzip libsamplerate libsamplerate-devel mpg123 mpg123-devel ImageMagick-devel ImageMagick

wget -N http://hivelocity.dl.sourceforge.net/project/cimg/CImg-1.5.6.zip
unzip CImg-1.5.6.zip
cp CImg-1.5.6/CImg.h /usr/local/include

wget -N $url$version$format
tar -xvf $version$format
cd $version
CXXFLAGS='-lphtread'
./configure --enable-video-hash=no --disable-debug --enable-shared --disable-pthread
make -j8 && make install
echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf && ldconfig
