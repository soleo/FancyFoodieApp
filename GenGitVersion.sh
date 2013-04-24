#!/bin/sh

#  GenGitVersion.sh
#  fancy
#
#  Created by Xinjiang Shao on 4/23/13.
#  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
git=/usr/bin/git
version=`$git describe --always`
echo "#define GIT_VERSION \"$version\"" > InfoPlist.h
touch fancy/fancy-Info.plist