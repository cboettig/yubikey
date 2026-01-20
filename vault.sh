#!/bin/bash

vault() {
    # --- Configuration ---
    local IMG="$HOME/secure_vault.img"
    local MAP="my_secret"
    local MNT="/mnt/secure_folder"
    # ---------------------

    # Check if mapped device exists
    if [ -e "/dev/mapper/$MAP" ]; then
        # --- LOCKING ---
        echo "🔒 Locking vault..."
        
        # Unmount if currently mounted
        if mountpoint -q "$MNT"; then
            sudo umount "$MNT"
        fi
        
        # Close the encrypted container
        if sudo cryptsetup close "$MAP"; then
            echo "✅ Vault secured."
        else
            echo "❌ Error: Could not close. Is a file still open?"
        fi

    else
        # --- UNLOCKING ---
        echo "🔓 Opening vault..."
        
        # 1. Open via FIDO2 (Token Only)
        # This will trigger the prompt/touch logic you verified manually
        if sudo cryptsetup open --token-only "$IMG" "$MAP"; then
            
            # 2. Mount
            if [ ! -d "$MNT" ]; then sudo mkdir -p "$MNT"; fi
            sudo mount "/dev/mapper/$MAP" "$MNT"
            
            # 3. Ensure Ownership
            # Runs every time to ensure you never get 'Permission Denied'
            sudo chown "$USER":"$USER" "$MNT"
            
            echo "✅ Vault mounted at $MNT"
        else
            echo "❌ Unlock failed."
        fi
    fi
}


vault
