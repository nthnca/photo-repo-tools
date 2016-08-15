# Photo Repository Tools

Basically I am paranoid about my photos. I want to easily be able to verify all
the files are intact and easily incrementally back up my files to simple
storage mechanisms like Google Drive or Amazon S3. Obviously the size and
number of photos, plus the desire to be able to move them around, delete them
without really deleting them, and edit them all make this a little more
challenging.

As such I have ended up settling on using git to manage my photos. Generally
people don't think it works well for large, binary files, but it seems to work
perfectly for my needs.

The tools here are what make this system work well for me.


# Set up photo repository

- git init
- git config core.compression 0
- git config core.bigFileThreshold 1m
- mkdir ARCHIVE/pack/
- echo "../../ARCHIVE/" .git/objects/info/alternatives


## Directory Structure

- .git/ - GIT repo that contains all the image files
- .git/objects/pack/ - Pack files. Created by running ‘git gc’
- .git/objects/info/alternates - Points to ARCHIVE/pack/
- ARCHIVE/pack/ - Pack files (this is what I back up to Google Drive)


## Add files to the photo repository

- Dump files off SD card and move JPGs into their own directory
- Run name-photos
- git add *.jpg; git commit -m "Temp commit"
- Do initial pass, deleting all the photos I know I don't want
- git commit -a --amend


## Create a new pack file

- git reflog expire --expire=all --all
- git gc (to merge everything into one pack file)
- git prune
- rename the pack file to something like 01-YEAR-SHA1
- move the pack file to the ARCHIVE directories
- add a .keep file
- upload .pack file to backup system


## Restore (from pack files):

Pack files should be named <COUNT>-<YEAR>-<SHA1>

- To verify shasum *.pack
- To find the commits that a given pack file contains:
  - ./bin/list-commits pack/*.pack
- To generate the index and keep files for a pack file:
  - ./bin/generate
- git fsck
