import os
from uuid import uuid5, NAMESPACE_URL, UUID


def gen_version_uuid(version_name: str) -> str:
    """Generate unique ID from version name

    Use UUID5 / NAMESPACE_URL with prefix `uuid5-`

    Args:
        version_name (str): version name

    Returns:
        str: generated unique ID
    """
    ver_uuid: UUID = uuid5(NAMESPACE_URL, version_name)
    ver_id: str = f"uuid5-{ver_uuid}"
    return ver_id


build_version = os.getenv("build_version")
version_uuid = gen_version_uuid(build_version)

CFG = """menuentry "YYYY.MM.DD-HHMM-rolling" --id uuid5-00000000-0000-0000-0000-000000000000 {
    set boot_opts="boot=live rootdelay=5 noautologin net.ifnames=0 biosdevname=0 vyos-union=/boot/YYYY.MM.DD-HHMM-rolling"
    if [ "${console_type}" == "ttyS" ]; then
        set console_opts="console=${console_type}${console_num},${console_speed}"
    else
        set console_opts="console=${console_type}${console_num}"
    fi
    # load rootfs to RAM
    if [ "${boot_toram}" == "yes" ]; then
        set boot_opts="${boot_opts} toram"
    fi
    if [ "${bootmode}" == "pw_reset" ]; then
        set boot_opts="${boot_opts} ${console_opts} init=/usr/libexec/vyos/system/standalone_root_pw_reset"
    elif [ "${bootmode}" == "recovery" ]; then
        set boot_opts="${boot_opts} ${console_opts} init=/usr/bin/busybox init"
    else
        set boot_opts="${boot_opts} ${console_opts}"
    fi
    linux "/boot/YYYY.MM.DD-HHMM-rolling/vmlinuz" ${boot_opts}
    initrd "/boot/YYYY.MM.DD-HHMM-rolling/initrd.img"
}
grub/grub.cfg.d/vyos-versions/"""
CFG = CFG.replace("YYYY.MM.DD-HHMM-rolling", build_version).replace(
    "uuid5-00000000-0000-0000-0000-000000000000", version_uuid
)

os.system("tar -xzpvf ../../../../data/grub.tar.gz -C p6/boot/")
with open(
    f"p6/boot/grub/grub.cfg.d/vyos-versions/{build_version}.cfg", "w", encoding="utf-8"
) as f:
    f.write(CFG)
with open(
    "p6/boot/grub/grub.cfg.d/20-vyos-defaults-autoload.cfg", "r+", encoding="utf-8"
) as f:
    defaults_autoload = f.read()
    f.seek(0)
    defaults_autoload = defaults_autoload.replace(
        "uuid5-00000000-0000-0000-0000-000000000000", version_uuid
    )
    f.write(defaults_autoload)
