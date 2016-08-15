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

- `git init`
- `git config core.compression 0`
- `git config core.bigFileThreshold 1m`
- `mkdir -p ARCHIVE/pack/`
- `echo "../../ARCHIVE/" > .git/objects/info/alternates`


## Directory Structure

- `.git/` - git repo that contains all the image files
- `.git/objects/pack/` - pack files, created by running `git gc`
- `.git/objects/info/alternates` - points to `ARCHIVE/pack/`
- `ARCHIVE/pack/` - pack files, these are what are backed up to Google Drive


## Add files to the photo repository

- dump files off SD card and move JPGs into their own directory
- run `name-photos`
- `git add *.jpg; git commit -m "Temp commit"`
- do initial pass, deleting unwanted photos
- `git commit -a --amend`


## Create a new pack file

- `git reflog expire --expire=all --all`
- `git gc` - merges everything into one pack file
- `git prune`
- there should be a pack file in `.git/objects/pack/`
- if file is relatively small
  - just upload it to backup site
- if it is big enough, I usually wait until 3-4 GB, then
  - rename the pack file to something like `XX-YEAR-COMMIT-SHA1`
  - move it to `ARCHIVE/pack/`
  - create an empty file with the same name but `.keep` instead of `.pack`
  - upload it to backup site


## Restore (from pack files):

- copy all the backup pack files into `ARCHIVE/pack/`
- `generate-index`
- `git fsck`
- `git reset --hard COMMIT`
