#!/bin/sh
#
# MIT License
#
# Copyright (c) 2026 gounix
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#
echo Starting builder version: Development-version

if [ X${GIT_HOST} = X ]; then
	echo variable GIT_HOST not set
	exit 1
fi
if [ X${GIT_PROJECT} = X ]; then
	echo variable GIT_PROJECT not set
	exit 1
fi
if [ X${GIT_USER} = X ]; then
	echo variable GIT_USER not set
	exit 1
fi
if [ X${GIT_SUBDIR} = X ]; then
	echo variable GIT_SUBDIR not set
	exit 1
fi
if [ X${GIT_SSH_KEY} = X ]; then
	echo variable GIT_SSH_KEY not set
	exit 1
fi
if [ X${GIT_TAG} = X ]; then
	echo variable GIT_TAG not set
	# optional
fi
if [ X${REGISTRY_HOST} = X ]; then
	echo variable REGISTRY_HOST not set
	exit 1
fi
if [ X${REGISTRY_AUTHENTICATED} = X ]; then
	echo variable REGISTRY_AUTHENTICATED not set
	exit 1
fi

if [ X${REGISTRY_AUTHENTICATED} = Xtrue ]; then
	if [ X${REGISTRY_USER} = X ]; then
		echo variable REGISTRY_USER not set
		exit 1
	fi
	if [ X${REGISTRY_PASSWORD} = X ]; then
		echo variable REGISTRY_PASSWORD not set
		exit 1
	fi
fi

echo all variables set
echo GIT_HOST=$GIT_HOST
echo GIT_PROJECT=$GIT_PROJECT
echo GIT_USER=$GIT_USER
echo GIT_SUBDIR=$GIT_SUBDIR
echo GIT_SSH_KEY=$GIT_SSH_KEY
echo GIT_TAG=$GIT_TAG
echo REGISTRY_USER=$REGISTRY_USER
echo REGISTRY_PASSWORD=XXXXXXX
echo REGISTRY_HOST=$REGISTRY_HOST
echo REGISTRY_AUTHENTICATED=$REGISTRY_AUTHENTICATED

if [ X${REGISTRY_AUTHENTICATED} = Xtrue ]; then
	echo buildah login
	echo ${REGISTRY_PASSWORD} | buildah login ${REGISTRY_HOST} --username ${REGISTRY_USER} --password-stdin
fi

cp ~/.ssh2/${GIT_SSH_KEY} ~/.ssh/${GIT_SSH_KEY}
chmod 0600 ~/.ssh/${GIT_SSH_KEY}
ls -l ~/.ssh

echo get ssh key from  $GIT_HOST
ssh-keyscan -p 22 $GIT_HOST > ~/.ssh/known_hosts
ssh-keygen -H

cd /tmp
echo clone git repo ${GIT_USER}@${GIT_HOST}:${GIT_PROJECT}
git clone ${GIT_USER}@${GIT_HOST}:${GIT_PROJECT} builddir

cd /tmp/builddir
if [ X${GIT_TAG} != X ]; then
	echo checking out git tag $GIT_TAG
	git checkout $GIT_TAG
fi

cd /tmp/builddir/${GIT_SUBDIR}
make
