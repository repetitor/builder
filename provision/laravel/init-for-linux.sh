#!/bin/bash

# if you should change the EOL from LF to CRLF in all .sh files in the directory and subdirectories
#
#
# signs:
# Bash script and /bin/bash^M: bad interpreter: No such file or directory"
# Windows Docker Error - standard_init_linux.go:211: exec user process caused "no such file or directory"
#  for file in `find ${worker_path}/provision -name "*.sh"`; do     sed -i -e 's/\r$//' $file;   done
for file in `find \. -name "*.sh"`; do
  sed -i -e 's/\r$//' $file;
done
