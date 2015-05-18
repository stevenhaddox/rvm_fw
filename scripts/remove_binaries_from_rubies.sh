#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Script directory: ${script_dir}"
rubies_dir=$( cd "$( dirname "${script_dir}/../public/rubies/." )" && pwd )
echo "Rubies directory: ${rubies_dir}"
cd ${script_dir}

source ${script_dir}/spinner.sh
start_spinner "Loading dependencies..."
  sleep 0.5
  source "${script_dir}/compress_utils.sh"
stop_spinner $?

start_spinner "Backing up rubies..."
  sleep 0.5
  # Cleanup rubies.bak
  if [ -d "${rubies_dir}.bak" ]; then
    rm -rf "${rubies_dir}.bak"
  fi
  # Cleanup .bak files
  find ${rubies_dir} -type f -name "*.bak" -exec rm -f {} \;
  # Backup rubies dir
  cp -r "${rubies_dir}" "${rubies_dir}.bak"
stop_spinner $?

shopt -s globstar
for file in ${rubies_dir}/**/* ; do
  if [ -f "$file" ]; then
    printf "\r\n"
    printf "\r\n"
    dirpath=$(dirname "${file}")
    filename="$(basename "${file}")"
    echo "Filename: $filename"
    echo "File: ${file}"
    cd "${dirpath}"
    start_spinner "Backing up..."
    sleep 0.5
    cp "$filename" "${filename}.bak"
    stop_spinner $?
    start_spinner "Extracting ${filename}..."
      sleep 0.5
      extract "$file" >/dev/null 2>&1
    stop_spinner $?
    extracted_dir=$(ls -tdr */ | tail -n1)
    if [ -z "${extracted_dir}" ]; then
      printf "${RED}Extracted directory not found, skipping to next ruby...${NC}"
      continue
    fi
    start_spinner "Removing .dat binaries..."
      sleep 0.5
      find "./${extracted_dir}" -type f -name "*.dat" -exec rm -f {} \;
    stop_spinner $?
    start_spinner "Repackaging file..."
      sleep 0.5
      compress "${file}" "${extracted_dir}"
    stop_spinner $?
    start_spinner "Cleaning up..."
      sleep 0.5
      # Remove extracted files (based upon last created directory)
      rm -rf "${extracted_dir}"
      # Remove backup file: ${filename}.bak
      if [ -e "${filename}.bak" ]
      then
        rm "${filename}.bak"
      fi
    stop_spinner $?
    # Reset before the next ruby
    cd "${script_dir}"
  fi
done

exit 0
