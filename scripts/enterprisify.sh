#!/bin/bash

GREEN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Script directory: ${script_dir}"
rubies_dir=$( cd "$( dirname "${script_dir}/../public/rubies/." )" && pwd )
echo "Rubies directory: ${rubies_dir}"
cd ${script_dir}

# Import common files to delete that fail clamav or McAfee virus scans
IFS=$'\r\n' GLOBIGNORE='*' :; flagged_files=($(cat ${script_dir}/../config/flagged_files.txt))

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
    printf "\r\n\r\n"
    dirpath=$(dirname "${file}")
    filename="$(basename "${file}")"
    echo "Filename: ${filename}"
    echo "File: ${file}"
    cd "${dirpath}"
    start_spinner "Backing up..."
      sleep 0.5
      cp "$filename" "${filename}.bak"
    stop_spinner $?
    start_spinner "Extracting ${filename}..."
      sleep 0.5
      file_args=("${filename}")
      extract "${file_args[@]}" >/dev/null 2>&1
    stop_spinner $?
    extracted_dir=$(ls -tdr */ | tail -n1)
    if [ -z "${extracted_dir}" ]; then
      printf "${RED}Extracted directory not found, skipping to next ruby...${NC}"
      continue
    fi
    # Determine if any files need to be deleted
    start_spinner "Removing files flagged by McAfee Enteprise or ClamAV..."
      sleep 0.5
      flagged_files_present=0
      for flagged_file in ${flagged_files[@]} ; do
        if [ -f "${rubies_dir}/${flagged_file}" ] ; then
          flagged_files_present=1
          rm "${rubies_dir}/${flagged_file}"
          #printf "\r\n  ${RED}Removing flagged file: ${NC}${flagged_file}"
        fi
      done
    stop_spinner $?
    if [ ${flagged_files_present} -eq 0 ] ; then
      start_spinner "No files removed, restoring backup..."
        sleep 0.5
        mv "${filename}.bak" "${filename}"
      stop_spinner $?
    else
      printf "${GREEN}Flagged files removed${NC}\r\n"
      start_spinner "Repackaging file..."
        sleep 0.5
        file_args=("${file}" "${extracted_dir}")
        compress "${file_args[@]}"
      stop_spinner $?
    fi
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

# Display changed ruby files

exit 0
