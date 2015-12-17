
Projpath=$1
REPO=$2
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

    # Загрузка конфига
    source $mydir/config.cfg
    if (($? > 0)); then
        echo "Error 1"
        exit 1
    fi
    # $PEPOPATH is readed from config 
    git clone --recursive "${PEPOPATH}:${REPO}"
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
