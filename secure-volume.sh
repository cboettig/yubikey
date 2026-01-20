# 1. Ensure everything is closed
sudo umount /mnt/secure_folder
sudo cryptsetup close my_secret

# 2. DELETE the old file completely
rm ~/secure_vault.img

# 3. Create a fresh 1GB file
fallocate -l 20G ~/secure_vault.img

# 4. Format it (You will be asked to type 'YES' in all caps)
# Set a backup password that you can remember.
sudo cryptsetup luksFormat ~/secure_vault.img

# 5. Open and format the filesystem
sudo cryptsetup open ~/secure_vault.img my_secret
sudo mkfs.ext4 /dev/mapper/my_secret
sudo cryptsetup close my_secret

# 6. Enroll yubikey
sudo systemd-cryptenroll --fido2-device=auto --fido2-with-user-verification=no --fido2-with-client-pin=no ~/secure_vault.img
sudo cryptsetup open --token-only --verbose ~/secure_vault.img my_secret

