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
    git clone --recursive git@git.yourrepository.com:"$REPO"
fi

cd "$REPO"

git checkout master
git pull origin master

for ITEM in `git submodule`
do
    if [ -d "$ITEM" ]; then
        cd "$ITEM"
        git checkout master
        git pull origin master
        cd ..
    fi
done
