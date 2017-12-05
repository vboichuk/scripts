
Projpath=$1
REPOPATH=$2
mydir=$(dirname "$0")

if [ -z "$1" ]; then
    echo "[EE] Needed repository path"
    exit 1
fi

if [ -z "$2" ]; then
    echo "[EE] Needed repository name"
    exit 1
fi

cd $Projpath
if (($? > 0)); then
    exit 1;
fi

read -p "clone? (Y/y/Д/д/+) " -n 1 -r
echo ""   # (optional) move to a new line
if [[ $REPLY =~ ^[YyДд+]$ ]]; then
    echo "#####################################"
    echo "#               CLONE               #"
    echo "#####################################"

    # $REPOPATH is readed from config 
    git clone --recursive "${REPOPATH}"
fi

cd "$REPOPATH"

git reset --hard HEAD &&  git clean -df

# git checkout master
git pull
# git pull origin master

# for ITEM in `git submodule`
# do
#     if [ -d "$ITEM" ]; then
#         cd "$ITEM"
#         git checkout master
#         git pull origin master
#         cd ..
#     fi
# done
