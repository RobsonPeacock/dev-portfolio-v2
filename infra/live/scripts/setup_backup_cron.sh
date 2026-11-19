aws s3 cp s3://$BACKUP_SCRIPT_BUCKET_NAME/db_backup.sh ~/usr/local/bin/db_backup.sh
chmod +x ~/usr/local/bin/db_backup.sh

existing_cron_job=$(crontab -l 2>/dev/null | grep -F "db_backup.sh" || true)

if [ -z "$existing_cron_jobs"] then;
  (crontab -l 2>/dev/null; echo "0 2 * * 0 ~/usr/local/bin/db_backup.sh") | crontab -
  echo "Cron job added to run db_backup.sh at 2 AM every Sunday."
else
  echo "Cron job for db_backup.sh already exists. No changes made."
fi