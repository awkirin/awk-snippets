#!/bin/bash

domains=(
google.com
www.google.com
play.google.com
ogs.google.com
notebooklm.google.com

notebooklm.google

gstatic.com
www.gstatic.com
ssl.gstatic.com
fonts.gstatic.com

googleusercontent.com
lh3.googleusercontent.com
)

for d in "${domains[@]}"; do
#    echo "$d:"
    dig +short "$d"
done