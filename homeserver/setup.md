# Homeserver setup

## Proxmox server

Drives

- Drive A - system drive
- Drive B - storage drive, raid 6

VMs

- Windows 10

### Drive B setup

This drive will behave as a NAS.

Make sure proxmox is up to date.

Go to node/Disks and click Initialize Disk with GPT.


    # ssh to proxmox

    # You should see the storage drive with the following command
    # /dev/sdb or similar. Gonna use /dev/sdb for this guide.
    fdisk -l

    fdisk /dev/sdb
    # Type 'n'
    # Accept the default partition number and starting sector.
    # Accept the default ending sector to use the entire disk.
    # Type 'w' to write changes and exit.

    apt-get install ntfs-3g
    mkfs.ntfs -f /dev/sdb1
    
    mkdir /mnt/storage
    mount /dev/sdb1 /mnt/storage

    # Add samba share folder to storage
    mkdir /mnt/storage/shared

    apt-get install samba

    nano /etc/samba/smb.conf

    # Add the following in there
        [global]
            server min protocol = SMB3
        [shared]
            path = /mnt/driveB/shared_folder
            read only = no
            guest ok = yes  # or no
    
    # If you chose no to guests then you will need a samba user to access the shared folder
    smbpasswd -a <username>

    # Restart samba service to load changes
    systemctl restart smbd