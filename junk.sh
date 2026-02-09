#!/bin/bash
# Version 1.1
#Name: Tawishi Dogra
#Uni: TD2746
#Advanced Programming: HW 1

# Directory where junked files are stored
readonly JUNKDIR=~/.junk

print_help(){
name=$(basename "$0")
cat << EOF
Usage: $name [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
EOF
}

#Add basic script structure and help function
if [ "$#" -eq 0 ]; then
print_help >&2
exit 1
fi

h=0
l=0
p=0

while getopts ":hlp" option; do
case "$option" in 
h)
h=1
;;
l)
l=1
;;
p)
p=1
;;
*)
printf "Error: Unknown option '-%s'.\n" "$OPTARG" >&2
print_help >&2
exit 1
;;
esac 
done

shift $((OPTIND-1))
# Validate that only one option is used at a time
total=$((h+l+p))

if [ "$total" -gt 1 ]; then
echo "Error: Too many options enabled." >&2
print_help >&2
exit 1
fi

if [ "$total" -ne 0 ] && [ "$#" -ne 0 ]; then
echo "Error: Too many options enabled." >&2
print_help >&2
exit 1
fi

if [ ! -d "$JUNKDIR" ]; then
mkdir -p "$JUNKDIR"
fi

if [ "$h" -eq 1 ]; then 
print_help
exit 0
fi

if [ "$l" -eq 1 ]; then
ls -lAF "$JUNKDIR"
exit 0
fi

if [ "$p" -eq 1 ]; then
rm -rf "${JUNKDIR:?}"/..?* "${JUNKDIR:?}"/.[!.]* "${JUNKDIR:?}"/* 2>/dev/null
exit 0
fi

for item in "$@"
do 
if [ ! -e "$item" ]; then
echo "Warning: '$item' not found." >&2
continue
fi
mv "$item" "$JUNKDIR"
done

exit 0
