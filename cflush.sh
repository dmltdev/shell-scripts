#!/bin/bash

cflush() {
  # Get memory usage before clearing cache (specifically buff/cache)
  before_cache=$(free | grep "Mem:" | awk '{print $6}')

  # Clear page cache
  sudo sync
  echo "Clearing page cache..."
  sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'

  # Clear dentries and inodes
  sudo sync
  echo "Clearing dentries and inodes..."
  sudo sh -c 'echo 2 > /proc/sys/vm/drop_caches'

  # Clear page cache, dentries, and inodes
  sudo sync
  echo "Clearing page cache, dentries, and inodes..."
  sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

  # Get memory usage after clearing cache (specifically buff/cache)
  after_cache=$(free | grep "Mem:" | awk '{print $6}')

  # Calculate the cleared memory (in KB)
  cleared_cache=$((before_cache - after_cache))

  # Convert KB to human-readable format (MB/GB)
  cleared_readable=$(echo "$cleared_cache" | awk '
    { if ($1 > 1024*1024) {printf "%.2f GB\n", $1 / (1024*1024)} 
    else if ($1 > 1024) {printf "%.2f MB\n", $1 / 1024} 
    else {printf "%d KB\n", $1}}')

  echo "Cache cleared: $cleared_readable"
}


