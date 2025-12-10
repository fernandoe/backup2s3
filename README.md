# backup2s3

Execute MySQL or MongoDB backups to S3-compatible storage (AWS S3, MinIO, etc.)

## Environment Variables

The following environment variables are required to configure the backup:

```bash
export BUCKET=my-backup-bucket
export AWS_ACCESS_KEY_ID=your-access-key-here
export AWS_SECRET_ACCESS_KEY=your-secret-key-here
export S3_ENDPOINT=storage.example.com
export ENVIRONMENT=production
export DB_HOST=mysql.example.com
export DB_USERNAME=backup_user
export DB_PASSWORD=secure_password
export DB_DATABASE=my_database
```

### S3-Compatible Storage

This tool works with:
- **AWS S3**: Use region-specific endpoints (e.g., `s3-us-west-2.amazonaws.com`)
- **MinIO**: Use your MinIO server address (e.g., `storage.example.com`)
- **Other S3-compatible services**: Set the appropriate endpoint

## MySQL Backup

- Image: mysql:8.0.33-debian

### Usage

```bash
docker run -e BUCKET=my-backup-bucket \
  -e AWS_ACCESS_KEY_ID=your-access-key \
  -e AWS_SECRET_ACCESS_KEY=your-secret-key \
  -e S3_ENDPOINT=storage.example.com \
  -e DB_HOST=mysql.example.com \
  -e DB_USERNAME=backup_user \
  -e DB_PASSWORD=secure_password \
  -e DB_DATABASE=my_database \
  registry.codigoaberto.io/backup2s3:latest
```
