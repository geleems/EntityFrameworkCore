cd \Projects\EFCore

call git remote add aspnet/EntityFrameworkCore https://github.com/aspnet/EntityFrameworkCore
call git remote add geleems/EntityFrameworkCore https://github.com/geleems/EntityFrameworkCore
call git fetch aspnet/EntityFrameworkCore
call git fetch geleems/EntityFrameworkCore

call git checkout dev
call git rebase aspnet/EntityFrameworkCore/dev
call git push -f

call git checkout development
call git rebase dev
call git push -f

call git checkout dev