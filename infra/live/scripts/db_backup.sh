#!/bin/bash
set -euo pipefail

eval $(aws ssm get-parameters \
    --name "/prod/backend/dev_portfolio_pg_user" \
    "/prod/backend/dev_portfolio_db_name" \
    "/prod/backend/dev_portfolio_db_backup_bucket_name" \
    --with-decryption \
    | jq -r '.Parameters[] | "export \(.Name | split("/") | last | ascii_upcase)=\(.Value | @sh)"')

container_id=$(docker ps --filter "name=^/backend-db-1$" --format "{{.ID}}")

date=$(date +"%d-%m-%Y")

docker exec $container_id pg_dump -U $DEV_PORTFOLIO_PG_USER -d $DEV_PORTFOLIO_DB_NAME \
  | gzip > ~/backup-$date.sql.gz

aws s3 cp ~/backup-$date.sql.gz s3://$DEV_PORTFOLIO_DB_BACKUP_BUCKET_NAME/backup-$date.sql.gz

files_count=$(aws s3 ls s3://$DEV_PORTFOLIO_DB_BACKUP_BUCKET_NAME/ | wc -l)

if [ $files_count -ge 5 ]; then
  oldest_file=$(aws s3 ls s3://$DEV_PORTFOLIO_DB_BACKUP_BUCKET_NAME/ | sort | head -n 1 | awk '{print $4}')
  aws s3 rm s3://$DEV_PORTFOLIO_DB_BACKUP_BUCKET_NAME/$oldest_file
  echo "Deleted oldest backup file: $oldest_file"
fi

rm ~/backup-$date.sql.gz
echo "Backup completed and uploaded to S3: backup-$date.sql.gz"