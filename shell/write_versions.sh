
Projpath=$1
REPO=$2

if [ -z "$1" ]; then
    echo "[EE] Needed repository path"
    exit 1
fi

if [ -z "$2" ]; then
    echo "[EE] Needed repository name"
    exit 1
fi

cd $Projpath/$REPO
if (($? > 0)); then
    exit 1;
fi

echo "Core:" > "version.txt"

git log -1 --pretty=format:'[%h] - %s (%cd) [%an]' --date=format:'%d.%m.%Y %H:%M' >> "version.txt"

for ITEM in `git submodule`
do
    if [ -d "$ITEM" ]; then
        cd "$ITEM"
        echo "\n${ITEM}:" >> "../version.txt"
        echo $(git log -1 --pretty=format:'[%h] - %s (%cd) [%an]' --date=format:'%d.%m.%Y %H:%M')  >> "../version.txt"
        cd ..
    fi
done
