#cloud-config
package_update: true
package_upgrade: true
packages:
  - curl
  - gnupg
  - lsb-release

runcmd:
  - curl -sL https://aka.ms/InstallAzureCLIDeb | bash
  - az login --identity
  - mkdir -p /data
  - az storage blob download \
      --account-name ${storage_account} \
      --container-name ${container_name} \
      --name ${blob_name} \
      --file /data/vm-data.zip \
      --auth-mode login
  - echo "✓ Downloaded ${blob_name} → /data/vm-data.zip ($(du -h /data/vm-data.zip | cut -f1))"
