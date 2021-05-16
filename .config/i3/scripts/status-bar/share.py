#!/usr/bin/env python
#
# Status bar script for printing the amount of gigabytes free in the
#   network share, assuming it's mounted to /mnt/tank/share/documents.
#
# IP of server that we're mounting storage from.
server_ip = "10.0.0.4"
# Location of mounted sorage in local filesystem.
mount_path = "/mnt/tank/storage/documents"
# Name of systemd automount unit for checking if filesystem is mounted.
systemd_unit = "mnt-tank-storage-documents.automount"
# Whether to print "free" next to gigabytes free.
verbose = True
# Whether to display percentage used of network share.
# This is not useful on ZFS datasets, for example.
show_percent = False
# Display in gigabytes or terabytes. The value you provide will also
#   be used in the output.
unit = "G"
# Emoji U+1F5C4 🗄️
icon = "🗄️"
# When free space drops below this amount, color the output in red.
# Units are in whatever "unit" is above.
alert_thresh = 1000

import subprocess

import psutil


def check_server():
    # Check whether server is reachable.
    server = subprocess.run(
        "ping -c 1 " + server_ip + " &>/dev/null", shell=True, check=True
    )
    if server.returncode != 0:
        raise Exception("Server not reachable!")


def check_mount():
    # Check whether filesystem is mounted.
    mounted = subprocess.run(
        [
            "systemctl",
            "is-active",
            "--quiet",
            "--type=automount",
            systemd_unit,
        ],
        check=True,
    )
    if mounted.returncode != 0:
        raise Exception("Filesystem not mounted!")


def main():
    check_server()
    check_mount()

    # Get free space in bytes.
    disk = psutil.disk_usage(mount_path)
    disk_bytes = disk.free

    disk_perc = disk.percent
    if disk_perc >= 1:
        disk_perc = round(disk_perc)

    # Convert to terabytes.
    if unit in ("T", "t", "TB", "Tb", "tb", "tB", "terabytes", "Terabytes"):
        disk_bytes_t = disk_bytes / (1024 ** 4)
        disk_bytes_t = round(disk_bytes_t, 2)
        disk_bytes_converted = disk_bytes_t
    # Convert to gigabytes.
    elif unit in ("G", "g", "GB", "Gb", "gb", "gB", "gigabytes", "Gigabytes"):
        disk_bytes_g = disk_bytes / (1024 ** 3)
        disk_bytes_g = round(disk_bytes_g)
        disk_bytes_converted = disk_bytes_g
    else:
        raise Exception("The 'unit' variable has an incorrect value!")

    output = icon + str(disk_bytes_converted) + unit
    # Print in color if the remaining space exceeds the threshold.
    print_color = bool(disk_bytes_converted <= alert_thresh)

    if verbose:
        free = "free"
    else:
        free = ""
    output = output + " " + free

    if show_percent:
        print(output + " (" + str(disk_perc) + "%)")
    else:
        print(output)

    # The i3bar protocol uses the third line of the output to specify.
    #   color: https://github.com/vivien/i3blocks#format
    if print_color:
        print("\n#F11712")


if __name__ == "__main__":
    main()
