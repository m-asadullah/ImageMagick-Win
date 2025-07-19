@echo off

call .github\build\windows\find-bash.cmd

%BASH% -c "./clone-repositories.sh --imagemagick6"
