#!/bin/bash

# NamePictures.sh *.JPG
#
# Rename photos in a way that is more meaningful and less likely to colide when
# you are using multiple cameras. {DATE}-{TIME}-{CAMERA}-{ORIGINAL_NAME}.jpg
# Example: 20150130-124140-GF1-P1234567.jpg

TMP_POSTFIX=id_tmp
TMP_CAMERA_NAMES=map.$TMP_POSTFIX

if [ $# -gt 0 ]; then
  echo "Running in test mode."
  TEST="Dry run: "
fi

# You will want to add your camera names to this map.
cat << EOF > $TMP_CAMERA_NAMES
DMC-GX7=GX7
DMC-LX3=LX3
EOF

# Processing the files in batches of 4 seems to be 2-4 times faster, moving to
# larger batches doesn't make much improvement, and eventually much worse.
COUNT=0
MAX_PROCESSES=4
for file in *.jpg; do
  echo "Processing $file ..."

  if [ ! -e "$file.$TMP_POSTFIX" ]; then
    # Get EXIF data for the image. Get more info using -verbose.
    identify -format '%[EXIF:*]' "$file" > "$file.$TMP_POSTFIX" &
  fi

  COUNT=$((COUNT+1))
  if [ $COUNT -eq $MAX_PROCESSES ]; then
    wait
    COUNT=0
  fi
done

# Wait for all background processes to complete.
wait

# Do the actual renaming.
for file in *.jpg; do
  ID_FILE="$file.$TMP_POSTFIX"
  DATE=`grep $exif:DateTimeOri < "$ID_FILE" | cut -b 23- | tr ' ' - | tr -d :`
  MODEL_TMP=`grep $exif:Model < "$ID_FILE" | cut -b 12-`
  MODEL_RES=$(grep $MODEL_TMP map.id_tmp)
  MODEL=${MODEL_RES#*=}

  if [ "$MODEL" = "" ]; then
    echo "The model type '$MODEL_TMP' wasn't recognized."
    exit 1
  fi

  NAME="${file%.*}.jpg"
  NAMEX="$DATE-$MODEL-$NAME"
  echo "${TEST}mv $file $NAMEX"
  if [ -z "$TEST" ]; then
    mv "$file" "$NAMEX"
    # Clean up the left over permissions from the fat32 file system.
    chmod -x "$NAMEX"
  fi
done

# Clean up.
rm -f *."$TMP_POSTFIX"
