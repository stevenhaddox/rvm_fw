#!/bin/bash

# Function to extract most file types
function extract () {
  if [ $# -lt 1 ]
  then
    echo "Usage : $0 filename_with_path"
    return 1
  fi
  if [ -f $1 ] ; then
    local filename="$(basename "${1}")"
    cd $(dirname "${1}")
    case $filename in
      *.tar.bz2)  tar xjf $1    ;;
      *.tar.gz)   tar xzf $1    ;;
      *.tar.xz)   tar Jxf $1    ;;
      *.bz2)      bunzip2 $1    ;;
      *.rar)      unrar x $1    ;;
      *.gz)       gunzip $1     ;;
      *.tar)      tar xf $1     ;;
      *.tbz2)     tar xjf $1    ;;
      *.tgz)      tar xzf $1    ;;
      *.zip)      unzip $1      ;;
      *.Z)        uncompress $1 ;;
      *.7z)       7z x $1       ;;
      *)          echo "don't know how to extract '$1'..." && return 1 ;;
    esac
  else
    echo "'$filename is not a valid file!"
    return 1
  fi
}

# Function to compress most file types
function compress () {
  if [ $# -lt 2 ]
  then
    echo "Usage : $0 target_filename_with_path extracted_folder"
    return 1
  fi
  if [ -f $1 ] ; then
    local filename="$(basename "${1}")"
    cd $(dirname "${1}")
    # Remove the file to be created if it already exists
    if [ -e "${filename}" ]
    then
      rm "${filename}"
    fi
    case $filename in
      *.tar.bz2)  tar -cjf $1 $2 ;;
      *.tar.gz)   tar -czf $1 $2 ;;
      *.tar.xz)   tar -cJf $1 $2 ;;
      *.bz2)      bzip2 $2       ;;
      *.rar)      rar a $1 $2    ;;
      *.gz)       gzip $2        ;;
      *.tar)      tar -cf $1 $2  ;;
      *.tbz2)     tar -cjf $1 $2 ;;
      *.tgz)      tar -czf $1 $2 ;;
      *.zip)      zip -r $1 $2   ;;
      *.Z)        compress $2    ;;
      *.7z)       7z a $1 $2     ;;
      *)          echo "don't know how to compress '$1'..." && return 1 ;;
    esac
  else
    echo "'$filename' is not a valid compression type!"
    return 1
  fi
}
