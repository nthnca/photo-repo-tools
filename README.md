# Photo Repository Tools

Tools for managing my git based photo repository.

Over the years our family has collected a decent sized collection of photos.
The size, number, concern of corruption, or loss of the photos makes it a
little awkward to keep them backed up and validated so we don’t accidentally
lose them.

## Directory Structure

FamilyPhotos/

- .git/ - GIT repo that contains all the image files.
- .git/objects/pack/ - Pack files. Created by running ‘git gc’.
- .git/objects/info/alternates - Points to ARCHIVE/pack/.
- ARCHIVE/pack/ - Pack files. (This is what really needs to be backed up.)
- ARCHIVE/other/ - Backups of .git and bin/.git.
- <YEAR>-<CAMERA>-<EXTRA>/ - Directories that store the various images.


## Work Flows

Create a new pack file

- git gc - to merge everything into one pack file.
- rename the pack file to something like <COUNT>-<YEAR>-<SHA1>
- move the pack files to the ARCHIVE directories.
- (git reflog expire --expire=all --all)  maybe with --rewrite ??
- git prune


## Restore (from pack files):

Pack files should be named <COUNT>-<YEAR>-<SHA1>

- To verify shasum *.pack
- To find the commits that a given pack file contains:
  - ./bin/list-commits pack/*.pack
- To generate the index and keep files for a pack file:
  - ./bin/generate
- git fsck

Notes:
- jpeginfo -c  # Check for corrupted jpeg files.
- rsync -rtv …
- identify -verbose /usr/share/backgrounds/WildWheat_by_Brian_Burt.jpg | grep
"exif:"
- exiftool -DateTimeOriginal+='0:0:100 0:0' SCAN_1232.jpg
- exiftool -DateTimeOriginal='1995:1:1 5:06' SCAN_1232.jpg
- X=0; for x in `ls -v`; do exiftool -DateTimeOriginal+="0:0:$X 0:0" $x;
X=$((X+1)); done

