#!/usr/bin/env bash
set -e

if [ "$POSTGRES_DATABASES" = "" ]; then
  echo "POSTGRES_DATABASES is not set. Exiting."
  exit 0
fi

echo "$POSTGRES_DATABASES" | tr ',' '\n' | while read -r db; do
  db=$(echo "$db" | xargs)
  [ "$db" = "" ] && continue
  echo "Creating database: $db"
  db_exists=$(psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='$db'")
  if [ "$db_exists" != "1" ]; then
    psql -U "$POSTGRES_USER" -c "CREATE DATABASE \"$db\";"
  else
    echo "Database $db already exists, skipping."
  fi
done
