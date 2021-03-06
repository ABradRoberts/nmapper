#!/bin/bash

# This is my typical strategy for scanning boxes I'm pentesting.
# I find this generally gives me all the information I need.

if [ $# -lt 2 ]; then
        echo "Usage: $0 <ipaddress> <outfile>"
        exit 1
fi

TARGET=$1
OUTFILE=$2

echo "####################"
echo "# ----- FAST ----- #"
echo "####################"
nmap -Pn -F $TARGET -o $OUTFILE.fast
echo ""

echo "#####################"
echo "# ----- NORMAL -----#"
echo "#####################"
nmap -Pn $TARGET -o $OUTFILE.normal
echo ""

echo "###################"
echo "# ----- ALL ----- #"
echo "###################"
nmap -Pn -p- --max-retries 1 $TARGET -o $OUTFILE.all -v
echo ""

PORTS=$(get_ports $OUTFILE.all)

echo "#######################"
echo "# ----- ALL sVsC -----#"
echo "#######################"
nmap -Pn -sV -sC -p $PORTS $TARGET -oA $OUTFILE.all.sVsC
echo ""

echo "########################"
echo "# ----- ALL SAFE ----- #"
echo "########################"
nmap -Pn --script safe $PORTS $TARGET -oA $OUTFILE.all.safe
echo ""

echo "Done."
