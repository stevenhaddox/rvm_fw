#!/bin/bash

# Function to extract most file types
function extract () {
  local args_array=( "$@" )
  local file="${args_array[0]}"

  if [ $# -lt 1 ]
  then
    echo "Usage : $0 \"filename\""
    return 1
  fi

  if [ -f "${file}" ] ; then
    case $file in
      *.tar.bz2)  tar xjf    "${file}" ;;
      *.tar.gz)   tar xzf    "${file}" ;;
      *.tar.xz)   tar Jxf    "${file}" ;;
      *.bz2)      bunzip2    "${file}" ;;
      *.rar)      unrar x    "${file}" ;;
      *.gz)       gunzip     "${file}" ;;
      *.tar)      tar xf     "${file}" ;;
      *.tbz2)     tar xjf    "${file}" ;;
      *.tgz)      tar xzf    "${file}" ;;
      *.zip)      unzip      "${file}" ;;
      *.Z)        uncompress "${file}" ;;
      *.7z)       7z x       "${file}" ;;
      *)          echo "don't know how to extract '${file}'..." && return 1 ;;
    esac
  else
    echo "'$file is not a valid file!"
    return 1
  fi
}

# Function to compress most file types
function compress () {
  local args_array=( "$@" )
  local file="${args_array[0]}"
  local extracted_dir="${args_array[1]}"

  if [ $# -lt 2 ]
  then
    echo "Usage : $0 \"target_filename\" \"extracted_directory\""
    return 1
  fi
  if [ -f "${file}" ] ; then
    # Remove the file to be created if it already exists
    if [ -e "${file}" ]
    then
      rm "${file}"
    fi
    case $file in
      *.tar.bz2)  tar -cjf $file $extracted_dir ;;
      *.tar.gz)   tar -czf $file $extracted_dir ;;
      *.tar.xz)   tar -cJf $file $extracted_dir ;;
      *.bz2)      bzip2          $extracted_dir ;;
      *.rar)      rar a    $file $extracted_dir ;;
      *.gz)       gzip           $extracted_dir ;;
      *.tar)      tar -cf  $file $extracted_dir ;;
      *.tbz2)     tar -cjf $file $extracted_dir ;;
      *.tgz)      tar -czf $file $extracted_dir ;;
      *.zip)      zip -r   $file $extracted_dir ;;
      *.Z)        compress       $extracted_dir ;;
      *.7z)       7z a     $file $extracted_dir ;;
      *)          echo "don't know how to compress '${file}'..." && return 1 ;;
    esac
  else
    echo "'$file' is not a valid compression type!"
    return 1
  fi
}
