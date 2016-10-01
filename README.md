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

# Basic usage

## `photo-init`

This creates a git repository in your current working directory, sets a couple
of configuration settings that optimizes the git repository for storing
photographs, and creates the ARCHIVE directory.

## `photo-pack`

Run this at any point when you want to create an incremental backup of
everything you have commited to your git repository. The new .pack file will be
placed in ARCHIVE/pack/

The pack files are named as <ARG1>-<YEAR-MONTH>-<COMMIT-SHA1>-<PACK-SHA1>.pack
where ARG1 is the first argument given to photo-pack, YEAR-MONTH is the current
year and month, COMMIT-SHA1 is the sha1 of the most recent commit, and the
PACK-SHA1 is the SHA1 of the pack file itself.

## `photo-index`

You use this command if you ever want to restore your photos from your backup.
The steps would be:

- `photo-init`: to create your repository you are restoring things into.
- copy all your backed up pack files into `ARCHIVE/pack/`
- `photo-index`: this will re-generate all the .idx files for your pack files.
- `git reset --hard COMMIT-SHA1`: this should restore everything. The
  COMMIT-SHA1 you use is from the most recent pack file you have.


# Other stuff

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
