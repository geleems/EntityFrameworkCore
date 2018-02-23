#!/bin/bash

EFCorePath=~/Projects/EFCore
LocalMasterBranch=dev
DevelopmentBranch=development

cd $EFCorePath
git checkout $LocalMasterBranch
git remote add aspnet/EntityFrameworkCore https://github.com/aspnet/EntityFrameworkCore
git remote add geleems/EntityFrameworkCore https://github.com/geleems/EntityFrameworkCore
git fetch aspnet/EntityFrameworkCore
git fetch geleems/EntityFrameworkCore
git rebase aspnet/EntityFrameworkCore/$LocalMasterBranch

git checkout $DevelopmentBranch
git rebase $LocalMasterBranch
