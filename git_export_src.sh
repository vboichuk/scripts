cd "$(dirname "$0")"

if [ -z "$1" ]; then
	echo "[EE] Needed repository name"
	exit 1
fi

REPO="$1"

PEPOPATH="git@your.path.com"

git clone --recursive $PEPOPATH:"$REPO"
cd "$REPO"

REV=`git rev-list --count HEAD`
REV="${REV//[[:space:]]/}"

git log -1 --pretty=%B

for ITEM in `git submodule`
do
    if [ -d "$ITEM" ]; then
        cd "$ITEM"
        git checkout master
        git pull origin master
        git log -1 --pretty=%B
        cd ..
        rm -rf "$ITEM"/.git*
    fi
done

rm -rf .git*

cd ..

# read -p "Pause. You can remove unnecessary files..." -n 1 -r
# echo ""

zip -0 -X -r "$REPO"-src\@r"$REV".zip "$REPO" \
    --exclude "*.DS_Store"

