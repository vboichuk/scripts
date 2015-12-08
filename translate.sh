#!/bin/sh

# установить terminal-notifier
# sudo gem install terminal-notifier

# вывести сообщение
# terminal-notifier -message "Script Complete"

# получить текст из буффера обмена
# $(pbpaste)

YELLOW='\033[0;33m'
NC='\033[0m' # No Color

TEXT=$(pbpaste) # "The pipeline would start at the Russkaya compressor station near Anapa. In February 2015, Gazprom chief Alexei Miller and Turkish Minister of Energy and Natural Resources Taner Yildiz announced that the landing point in Turkey would be Kıyıköy, a village in the district of Vize in Kırklareli Province at northwestern Turkey. According to Gazprom, pipe-laying works will start immediately when the landing point in Turkey is decided. Two pipe-laying ships are already located in the Black Sea."

TRANSLATED=$(wget -U "Mozilla/5.0" -qO - "https://translate.google.com/translate_a/single?client=t&sl=auto&tl=ru&hl=ru&dt=bd&dt=ex&dt=ld&dt=md&dt=qc&dt=rw&dt=rm&dt=ss&dt=t&dt=at&ie=UTF-8&oe=UTF-8&otf=2&srcrom=1&ssel=0&tsel=0&kc=3&tk=519592|450115&q=$(echo "${TEXT}" | sed "s/[\"'<>]//g")&sl=auto&tl=ru" 	  )

echo $YELLOW 

# CROP ONLY
# RESULT=$(echo $TRANSLATED | awk -F"],," '{print $1}' )
# echo "${RESULT}"
# echo "  "

# CROP AND REPLACE ,"whatevercharacters" to ''
# RESULT=$(echo $TRANSLATED | awk -F"],," '{print $1}' | sed 's/\,\"[^\"]*\"//g' )
# echo "${RESULT}"
# echo "  "

RESULT=$(echo $TRANSLATED | awk -F"],," '{print $1}' | sed 's/\,\"[^\"]*\"//g' | sed -e 's/[0-9\,]*[]\"\[]//g' )
echo "${RESULT}"

echo $NC

terminal-notifier -message "${RESULT}" -title "Перевод";