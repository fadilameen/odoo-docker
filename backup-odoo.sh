#!/bin/bash

# Variables

CONTAINER_ID="odoo-docker-setup_odoo_main_1"

DB_CONTAINER_ID="odoo-docker-setup_db-main_1"

HOST_PATH="/home/cybrosys/odoo-docker-setup/backup"

CONTAINER_PATH=""

FILESTORE_BACKUP_NAME="odoo_filestore_backup_$(date +%Y-%m-%d_%H-%M-%S)"

DB_BACKUP_NAME="odoo_db_backup_`date +%Y-%m-%d"_"%H_%M_%S`.sql"


# Database Backup

docker exec -t $DB_CONTAINER_ID pg_dumpall -c -U odoo18-main > $HOST_PATH/$DB_BACKUP_NAME
echo "db backup complete"

# Filestore Backup

sudo docker exec -it --user root $CONTAINER_ID tar -cvzf $CONTAINER_PATH/$FILESTORE_BACKUP_NAME.tar.gz -C /var/lib odoo
# sudo docker exec -it --user root $CONTAINER_ID tar -cvzf /odoo_backup_test_2.tar.gz -C /var/lib odoo


sudo docker cp $CONTAINER_ID:$CONTAINER_PATH/$FILESTORE_BACKUP_NAME.tar.gz $HOST_PATH
# sudo docker cp $CONTAINER_ID:odoo_backup_test_2.tar.gz $HOST_PATH

# Optional: Remove old backups, keeping last 3

# find $HOST_PATH -type f -name '*.tar.gz' -mtime +3 -exec rm {} \\\\;

# find $HOST_PATH -type f -name '*.sql' -mtime +3 -exec rm {} \\\\;

echo "Backup completed successfully!"
