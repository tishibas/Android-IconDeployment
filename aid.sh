#!/usr/bin/env bash


#    Copyright 2014 Takashi Ishibashi
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.


SRC='https://google.github.io/material-design-icons/'
MATERIALS_HTML='/tmp/.materials'
ICON_LIST='/tmp/.icon_list'
RES='app/src/main/res'
DRAWABLE="${RES}/drawable"

INKSCAPE=`which inkscape`
CURL=`which curl`
MV=`which mv`
PERL=`which perl`
GREP=`which grep`
SED=`which sed`


usage(){
    echo "Usage: ./aid.sh [-c color] [-p project_dir] icon_name" 1>&2
    echo 'Example: ./aid.sh -c white -p project/path done' 1>&2
    exit 1
}

check_dir(){
    local PROJECT_DIR=$(cd $1; pwd)
    if [ ! -e ${PROJECT_DIR}/${DRAWABLE} ]; then
        echo "Error: wrong parameter $1" 1>&2
        usage
        exit 1
    fi
}

if [ -z $INKSCAPE ]; then
    echo "Please install inkscape"
    exit 1
fi

if [ -z $CURL ]; then
    echo "Please install curl"
    exit 1
fi

PROJECT_DIR='.'
while getopts "c:p:h" OPT
do
    case $OPT in 
        "c" ) COLOR="$OPTARG"
            ;;
        "p" ) PROJECT_DIR="${OPTARG%/}"
            check_dir $PROJECT_DIR
            ;;
        "h" ) usage
            ;;
        \? ) usage
            ;;
    esac
done


if [ $PROJECT_DIR = '.' ]; then
    DRAWABLE_DIR=${PROJECT_DIR}/${DRAWABLE}
    if [ ! -e $DRAWABLE_DIR ]; then
        echo "Error: specify project" 1>&2
        usage
        exit 1
    fi
else 
    DRAWABLE_DIR=${PROJECT_DIR}/${DRAWABLE}
fi

shift $((OPTIND - 1))
ICON=$1

$CURL -s $SRC > $MATERIALS_HTML
cat $MATERIALS_HTML | $PERL -nle 'if($_=~/^<div><img src=.\.\/(.*\.svg).><br>(.*)<\/div>$/){print "$1"}' > $ICON_LIST

ICON_SVG="ic_${ICON}_24px.svg"

EXIST_FLG=`cat $ICON_LIST | $GREP $ICON_SVG | wc -l`

if [ $EXIST_FLG -ne 1 ]; then
    echo "wrong icon name"
    exit 1
fi

ICON_PATH=`cat $ICON_LIST | $GREP $ICON_SVG`
ICON_URL=$SRC$ICON_PATH

echo "Downloading $ICON svg ..."
if ! $CURL -s -o /tmp/$ICON_SVG -O $ICON_URL; then
    echo "Error: wrong paramter $ICON" 1>&2
    exit 1
fi

$SED -i -e "s/\(path d=.*\)\(\/>$\)/\1 fill=\"$COLOR\"\2/" /tmp/$ICON_SVG
$SED -i -e "s/\(fill=\"none\"\) \(fill=\"$COLOR\"\)/\1/" /tmp/$ICON_SVG

echo "Converting svg to png ..."
$INKSCAPE -z -e ic_${ICON}_32px.png -w 32 -h 32 /tmp/$ICON_SVG >> /dev/null
$INKSCAPE -z -e ic_${ICON}_48px.png -w 48 -h 48 /tmp/$ICON_SVG >> /dev/null
$INKSCAPE -z -e ic_${ICON}_64px.png -w 64 -h 64 /tmp/$ICON_SVG >> /dev/null


if [ -d ${DRAWABLE_DIR}-mdpi ]; then
    $MV ic_${ICON}_32px.png ${DRAWABLE_DIR}-mdpi/ic_${ICON}.png
fi
if [ -d ${DRAWABLE_DIR}-hdpi ]; then
    $MV ic_${ICON}_48px.png ${DRAWABLE_DIR}-hdpi/ic_${ICON}.png
fi
if [ -d ${DRAWABLE_DIR}-xhdpi ]; then
    $MV ic_${ICON}_64px.png ${DRAWABLE_DIR}-xhdpi/ic_${ICON}.png 
fi

echo "success!"
