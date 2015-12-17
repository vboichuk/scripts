cd "$(dirname "$0")"

if [ -z "$1" ]; then
	echo "[EE] Needed repository name"
	exit 1
fi

cd "$1"

echo "Core:" > "version.txt"
git log -1 --pretty=%B >> "version.txt"

for ITEM in `git submodule`
do
    if [ -d "$ITEM" ]; then
        cd "$ITEM"
        echo "${ITEM}:" >> "../version.txt"
        git log -1 --pretty=%B  >> "../version.txt"
        cd ..
    fi
done
