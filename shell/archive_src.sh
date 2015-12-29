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


# --- получение номера текущей ревизии ------
MESSAGE=$(git log -1 --pretty=%B)
#echo "${MESSAGE}"
REVISION=$(grep -o "^[0-9]*" <<< $MESSAGE)
if [ ! "$REVISION" ]; then
	REVISION=$(git log -1 --pretty=format:"%h")
fi
#echo "${REVISION}"
cd ..
# -------------------------------------------

echo "#######################################"
echo "#               ARCHIVE               #"
echo "#######################################"

ARCHIVE_NAME="${REPO}-src@${REVISION}.zip"
echo "${ARCHIVE_NAME}"

zip -0 -X -r $ARCHIVE_NAME "${REPO}" \
    --exclude "*.DS_Store" \
    --exclude *.git*  \
    --exclude "${REPO}/tools/*" \
    --exclude "${REPO}/localization/*"
    
# --exclude "${REPO}/proj.win8.1-universal/*"    

exit 0

