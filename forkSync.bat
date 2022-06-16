@echo off
git.exe pull --progress -v --no-rebase "upstream" master
git.exe push
pause