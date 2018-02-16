#!/bin/bash
#########################################################
#
#   Title
#
#   Created by Gregor Santer (gsantner), 2018
#   https://gsantner.net/
#
#########################################################


#Pfade
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTFILE=$(readlink -f $0)
SCRIPTPATH=$(dirname $SCRIPTFILE)
SCRIPTDIRPARENT="$(dirname "$SCRIPTDIR")"
argc=$#

#########################################################
cd "$SCRIPTDIR"
rm -rf doc-tutorial
mkdir doc-tutorial
cp ../gsantner-net/_drafts/2018-02-16-vplay-tutorial.md doc-tutorial/
cp -R ../gsantner-net/assets/blog/img/vplay-tutorial doc-tutorial/tutorial-assets

