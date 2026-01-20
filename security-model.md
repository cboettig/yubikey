

Work
====

- Public GitHub - most active research as open source.
- University-managed enterprise systems: Google email, Google Docs. 


Credentials
-----------

- MFA all accounts to yubikey hardware keys.
- SSH keys for remote machines: Only on yubikey
 

### Developer credentials


#### S3 Keys

- NRP systems
    as env vars and rclone conf on k8s secrets

NRP k8s credential - local credential + 2FA via UC Berkeley login.





Personal
========



# Local Vault: 

- see one-time setup in `secure-volume.sh`.  
- Then source vault.sh (or `mv vault.sh ~/.local/bin/vault`)


Secure Vault Documentation
File: ~/secure_vault.img (20GB Encrypted Container) Mount: /mnt/secure_folder Auth: FIDO2 (YubiKey) or Password (Fallback)

1. Daily Usage

To open/close the vault, run `vault`, touch key on prompt. 

Recovery: backupt key, or password.

2. Emergency Recovery
If your YubiKey is lost or damaged, use your backup password.

Unlock with Password (omit --token-only`)



# This ignores the YubiKey and forces a password prompt

Header Backup (Critical Safety): If the LUKS header gets corrupted, you lose data even with the password. Create a header backup and store it externally:

```bash
sudo cryptsetup luksHeaderBackup ~/secure_vault.img --header-backup-file header-backup.img
```

add backup key:

```bash
sudo systemd-cryptenroll --fido2-device=auto --fido2-with-client-pin=no ~/secure_vault.img
```

view active keys:

```bash
sudo cryptsetup luksDump ~/secure_vault.img
# Look for 'Slots':
# 0: luks2 (Password)
# 1: systemd-fido2 (YubiKey 1)
# 2: systemd-fido2 (YubiKey 2)
```

