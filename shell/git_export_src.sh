cd "$(dirname "$0")"

if [ -z "$1" ]; then
	echo "[EE] Needed repository name"
	exit 1
fi

REPO="$1"

read -p "clone? (Y/y/Д/д/+) " -n 1 -r
echo ""   # (optional) move to a new line
if [[ $REPLY =~ ^[YyДд+]$ ]]; then
    echo "#####################################"
    echo "#               CLONE               #"
    echo "#####################################"
    git clone --recursive git@git.333by.com:"$REPO"
fi


cd "$REPO"

# REV=`git rev-list --count HEAD`
# REV="${REV//[[:space:]]/}"
REV=543

echo "Core:" > "version.txt"
git log -1 --pretty=%B >> "version.txt"

for ITEM in `git submodule`
do
    if [ -d "$ITEM" ]; then
        cd "$ITEM"
        git checkout master
        git pull origin master
        echo "${ITEM}:" >> "../version.txt"
        git log -1 --pretty=%B  >> "../version.txt"
        cd ..
    fi
done

echo "#####################################"
echo "#               CLEAR               #"
echo "#####################################"

read -p "clear? (Y/y/Д/д/+) " -n 1 -r
echo ""   # (optional) move to a new line
if [[ $REPLY =~ ^[YyДд+]$ ]]; then
    # CLEAR
    for ITEM in `git submodule`
    do
        if [ -d "$ITEM" ]; then
            rm -rf "$ITEM"/.git*
        fi
    done
    rm -rf .git*
fi

read -p "Pause. You can remove unnecessary files..." -n 1 -r
echo ""

echo "#######################################"
echo "#               ARCHIVE               #"
echo "#######################################"

cd ..

zip -0 -X -r "${REPO}-src.r${REV}.zip" "${REPO}" \
    --exclude "*.DS_Store" --exclude *.git*

exit 0

