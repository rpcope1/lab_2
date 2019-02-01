#!/usr/bin/env bash
# Author: Robert Cope
# Date: 1/30/2019
set -eu

SEARCH_FILE="regex_practice.txt"
# Assume that a well formed phone number is of the form XXX-XXX-XXXX or (XXX)-XXX-XXXX
# and has ten digits
PHONE_NUMBER_REGEX="^(\(([0-9]{3})\)|([0-9]{3}))\-?([0-9]{3})\-?([0-9]{4})$"
# Alternatively we could allow omission of the area code
ALT_PHONE_NUMBER_REGEX="^(\(([0-9]{3})\)|([0-9]{3}))?\-?([0-9]{3})\-?([0-9]{4})$"
THREE_OH_THREE_REGEX="^(\(303\)|303)\-?([0-9]{3})\-?([0-9]{4})$"

EMAIL_REGEX="^\S+\@[0-9A-z\-]+(\.[0-9A-z\-]+)+$"
GEOCITIES_EMAIL_REGEX="^\S+\@geocities\.com$"

error()
{
  >&2 echo "Error: $1"
  exit 1
}

main(){
    if [[ $# -ne 1 ]]; then
        error "Required command line parameters: [final_regex]"
    fi
    FINAL_REGEX=$1
    echo "Enter a regular expression for grep: "
    read regularExpression
    echo "Enter a file to scan: "
    read readFile
    if [[ ! -f ${readFile} ]] ; then
        error "File ${readFile} does not exist! Aborting..."
    fi
    grep -E "${regularExpression}" "${readFile}"
    echo "Scanning ${SEARCH_FILE}..."
    NUM_PHONE_NUMBERS=$(grep -E "${PHONE_NUMBER_REGEX}" "${SEARCH_FILE}" | wc -l)
    echo "Number of phone numbers: ${NUM_PHONE_NUMBERS}"
    NUM_EMAIL_ADDRESSES=$(grep -P "${EMAIL_REGEX}" "${SEARCH_FILE}" | wc -l)
    echo "Number of email addresses: ${NUM_EMAIL_ADDRESSES}"
    echo "Finding 303 area code phone numbers..."
    grep -P "${THREE_OH_THREE_REGEX}" "${SEARCH_FILE}" > phone_results.txt
    echo "Finding non-geocities emails..."
    grep -P "${EMAIL_REGEX}" "${SEARCH_FILE}" | grep -v -P "${GEOCITIES_EMAIL_REGEX}" "-" > email_results.txt
    grep -E "${FINAL_REGEX}" "${SEARCH_FILE}" > command_results.txt
}

main $@
