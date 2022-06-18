#!/bin/bash

if [ ! $# -eq 1 ]; then
  echo "usage: $0 FILE"
  exit 1
fi

file="$1"
problem="${file%.*}"
extension="${file##*.}"

case $extension in
  c)
    language="C"
    ;;
  pl)
    language="Prolog"
    ;;
  py)
    language="Python 3"
    ;;
  *)
    echo "Couldn't deduce the language of file $file."
    exit 1
esac

if [ -f ".kattisrc" ]; then
  kattisrc=".kattisrc"
elif [ -f "$HOME/.kattisrc" ]; then
  kattisrc="$HOME/.kattisrc"
else
  echo "No .kattisrc in current directory, or in home directory."
  echo "To download a .kattisrc file, please visit https://open.kattis.com/download/kattisrc."
  exit 1
fi

# \s match whitespace
# \K omit match
# .* match until end of line
kattis_username=`grep --perl-regexp --only-matching 'username:\s\K.*' $kattisrc`
kattis_token=`grep --perl-regexp --only-matching 'token:\s\K.*' $kattisrc`
kattis_login_url=`grep --perl-regexp --only-matching 'loginurl:\s\K.*' $kattisrc`
kattis_submit_url=`grep --perl-regexp --only-matching 'submissionurl:\s\K.*' $kattisrc`
kattis_submission_url=`grep --perl-regexp --only-matching 'submissionsurl:\s\K.*' $kattisrc`

login_output=$(curl\
  --cookie-jar .cookies\
  --user-agent "kattis-cli-submit"\
  --form script="true"\
  --form user="$kattis_username"\
  --form token="$kattis_token"\
  "$kattis_login_url"
)

if [ ! $? -eq 0 ]; then
  echo "Failed to log into $kattis_login_url."
  exit 1
fi

submit_output=$(curl\
  --cookie .cookies\
  --form script="true"\
  --form submit="true"\
  --form submit_ctr="2"\
  --form language="$language"\
  --form problem="$problem"\
  --form sub_file[]=@$file\
  "$kattis_submit_url"
)

if [ ! $? -eq 0 ]; then
  echo "Failed to submit $source_file to $kattis_submit_url."
  exit 1
fi

submission_id=$(echo $submit_output | grep --perl-regexp --only-matching 'Submission ID:\s\K.*[^.]')
open "$kattis_submission_url/$submission_id"

if [ ! $? -eq 0 ]; then
  echo "Couldn't open $kattis_submission_url/$submission_id."
  exit 1
fi
