#!/bin/bash

# make all sh-files in the directory and subdirectories executable
function make_sh_files_executable(){
  for file in `find \. -name "*.sh"`; do
    chmod +x $file
  done
}

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  make_sh_files_executable
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  make_sh_files_executable
elif [[ "$OSTYPE" == "msys" ]]; then
	echo "Lightweight Shell and GNU utilities compiled for Windows (part of MinGW)."
	echo "'winpty' can help you) e.g. winpty docker-compose exec laravel_service /tmp/runFirstTime.sh"
elif [[ "$OSTYPE" == "cygwin" ]]; then
	echo "POSIX compatibility layer and Linux environment emulation for Windows"
elif [[ "$OSTYPE" == "win32" ]]; then
  # I'm not sure this can happen.
	echo "win32"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  echo "freebsd"
else
  echo "Unknown OS"
fi

# change the EOL from LF to CRLF (windows -> linux)
for file in `find \. -name "*.sh"`; do
  sed -i -e 's/\r$//' $file;
done
