sudo rsync -amvxx --dry-run --no-links --exclude "/tmp/*" --exclude "/root/*" / persist/ | rg -v "^skipping|/$"
