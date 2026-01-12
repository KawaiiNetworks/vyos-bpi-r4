# vyos-bpi-r4

This project is a personal learning project, mainly aimed at porting the VyOS to the BPI-R4 board for use.

Project dependencies:

-   [vyos-1x](https://github.com/vyos/vyos-1x)
-   [vyos-build](https://github.com/vyos/vyos-build)
-   [vyos-arm64-build](https://github.com/huihuimoe/vyos-arm64-build)
-   [vyos-arm64-autobuild](https://github.com/KawaiiNetworks/vyos-arm64-autobuild)
-   [BPI-Router-Linux](https://github.com/frank-w/BPI-Router-Linux)
-   [u-boot for banana pi](https://github.com/frank-w/u-boot)

This board is sponsored by [LCPU](https://github.com/lcpu-club).

## Prepare the build environment

```bash
git clone https://github.com/KawaiiNetworks/vyos-bpi-r4
cd vyos-bpi-r4
git checkout 6.18-bpi-r4

docker run -it --privileged --sysctl net.ipv6.conf.lo.disable_ipv6=0 -v $(pwd):/vyos -w /vyos ghcr.io/kawaiinetworks/vyos-bpi-r4:builder bash
```

In the container (we assume that the current user is not root):

```bash
export PROJECT_ROOT=$(pwd)

sudo apt update
# sudo apt-get install -y gcc-aarch64-linux-gnu u-boot-tools bc make gcc ccache libc6-dev libncurses5-dev libssl-dev bison flex device-tree-compiler libelf-dev kmod libdw-dev libdebuginfod-dev systemtap-sdt-dev libunwind-dev libslang2-dev libperl-dev python3-dev python3 llvm-dev libzstd-dev libnuma-dev libbabeltrace-ctf-dev libcapstone-dev libpfm4-dev libtraceevent-dev libtracefs-dev default-jdk clang binutils-dev libcap-dev libbpf-dev asciidoc xmlto u-boot-tools

git clone https://github.com/huihuimoe/vyos-arm64-build
cd $PROJECT_ROOT/vyos-arm64-build
git clone https://github.com/vyos/vyos-build
```

## Patch and build vyos-1x

Note: Many steps in this script are excerpted from huihuimoe/vyos-arm64-build GitHub workflows.

```bash
bash scripts/patch-and-build-vyos-1x.sh
```

## Build All

```bash
bash scripts/build-all.sh
```

Finally we get 2 img.gz and a tar.gz after build.

## How to USE

Note: I set fixed local mac address for eth3/4/5/6 in the dtsi file because VyOS use mac address to identify interfaces. If you want to use your own mac address, please use `set interface ethernet ethX mac xx:xx:xx:xx:xx:xx` to change it after first boot.

VyOS supports 2.4G/6G wifi6.

a example configuration:

```vbash
edit interface
set wireless wlan0 capabilities he antenna-pattern-fixed
set wireless wlan0 capabilities he beamform multi-user-beamformer
set wireless wlan0 capabilities he beamform single-user-beamformee
set wireless wlan0 capabilities he beamform single-user-beamformer
set wireless wlan0 capabilities he bss-color '13'
set wireless wlan0 capabilities he channel-set-width '81'
set wireless wlan0 capabilities ht 40mhz-incapable
set wireless wlan0 capabilities ht channel-set-width 'ht20'
set wireless wlan0 capabilities ht channel-set-width 'ht40-'
set wireless wlan0 capabilities ht channel-set-width 'ht40+'
set wireless wlan0 capabilities ht short-gi '20'
set wireless wlan0 capabilities ht short-gi '40'
set wireless wlan0 capabilities ht stbc rx '2'
set wireless wlan0 capabilities ht stbc tx
set wireless wlan0 channel '11'
set wireless wlan0 disable
set wireless wlan0 hw-id 'xx:xx:xx:xx:xx:xx'
set wireless wlan0 mac 'yo:ur:ma:c0:ad:dr'
set wireless wlan0 mgmt-frame-protection 'required'
set wireless wlan0 mode 'ax'
set wireless wlan0 physical-device 'phy0'
set wireless wlan0 security wpa cipher 'CCMP'
set wireless wlan0 security wpa cipher 'CCMP-256'
set wireless wlan0 security wpa cipher 'GCMP'
set wireless wlan0 security wpa cipher 'GCMP-256'
set wireless wlan0 security wpa mode 'wpa3'
set wireless wlan0 security wpa passphrase 'password'
set wireless wlan0 ssid 'BPI-R4-2.4G'
set wireless wlan0 stationary-ap
set wireless wlan0 type 'access-point'
set wireless wlan1 capabilities ht 40mhz-incapable
set wireless wlan1 capabilities ht channel-set-width 'ht20'
set wireless wlan1 capabilities ht channel-set-width 'ht40-'
set wireless wlan1 capabilities ht channel-set-width 'ht40+'
set wireless wlan1 capabilities ht short-gi '20'
set wireless wlan1 capabilities ht short-gi '40'
set wireless wlan1 capabilities ht stbc rx '2'
set wireless wlan1 capabilities ht stbc tx
set wireless wlan1 capabilities vht antenna-count '3'
set wireless wlan1 capabilities vht antenna-pattern-fixed
set wireless wlan1 capabilities vht beamform 'multi-user-beamformer'
set wireless wlan1 capabilities vht beamform 'single-user-beamformee'
set wireless wlan1 capabilities vht beamform 'single-user-beamformer'
set wireless wlan1 capabilities vht center-channel-freq freq-1 '50'
set wireless wlan1 capabilities vht channel-set-width '2'
set wireless wlan1 channel '36'
set wireless wlan1 enable-bf-protection
set wireless wlan1 hw-id 'xx:xx:xx:xx:xx:xx'
set wireless wlan1 mac 'yo:ur:ma:c0:ad:dr'
set wireless wlan1 mgmt-frame-protection 'required'
set wireless wlan1 mode 'ac'
set wireless wlan1 physical-device 'phy0'
set wireless wlan1 security wpa cipher 'CCMP'
set wireless wlan1 security wpa cipher 'CCMP-256'
set wireless wlan1 security wpa cipher 'GCMP'
set wireless wlan1 security wpa cipher 'GCMP-256'
set wireless wlan1 security wpa mode 'wpa3'
set wireless wlan1 security wpa passphrase 'password'
set wireless wlan1 ssid 'BPI-R4-5G'
set wireless wlan1 stationary-ap
set wireless wlan1 type 'access-point'
set wireless wlan2 capabilities he antenna-pattern-fixed
set wireless wlan2 capabilities he beamform multi-user-beamformer
set wireless wlan2 capabilities he beamform single-user-beamformee
set wireless wlan2 capabilities he beamform single-user-beamformer
set wireless wlan2 capabilities he bss-color '13'
set wireless wlan2 capabilities he center-channel-freq freq-1 '15'
set wireless wlan2 capabilities he channel-set-width '134'
set wireless wlan2 capabilities ht 40mhz-incapable
set wireless wlan2 capabilities ht channel-set-width 'ht20'
set wireless wlan2 capabilities ht channel-set-width 'ht40-'
set wireless wlan2 capabilities ht channel-set-width 'ht40+'
set wireless wlan2 capabilities ht short-gi '20'
set wireless wlan2 capabilities ht short-gi '40'
set wireless wlan2 capabilities ht stbc rx '2'
set wireless wlan2 capabilities ht stbc tx
set wireless wlan2 channel '5'
set wireless wlan2 enable-bf-protection
set wireless wlan2 hw-id 'xx:xx:xx:xx:xx:xx'
set wireless wlan2 mac 'yo:ur:ma:c0:ad:dr'
set wireless wlan2 mgmt-frame-protection 'required'
set wireless wlan2 mode 'ax'
set wireless wlan2 physical-device 'phy0'
set wireless wlan2 security wpa cipher 'CCMP'
set wireless wlan2 security wpa cipher 'CCMP-256'
set wireless wlan2 security wpa cipher 'GCMP'
set wireless wlan2 security wpa cipher 'GCMP-256'
set wireless wlan2 security wpa mode 'wpa3'
set wireless wlan2 security wpa passphrase 'password'
set wireless wlan2 ssid 'BPI-R4-6G'
set wireless wlan2 stationary-ap
set wireless wlan2 type 'access-point'
```

## Upgrade VyOS Version

Go to the latest release page https://github.com/KawaiiNetworks/vyos-bpi-r4/releases/latest

Then download the vyos-YYYY.MM.DD-HHMM-rolling.tar.gz

unpack it to /lib/live/mount/persistence/boot and change /lib/live/mount/persistence/boot/vyos.txt to the new version.

copy `/lib/live/mount/persistence/boot/OLD/rw/opt/vyatta/etc/config` to `/lib/live/mount/persistence/boot/NEW/rw/opt/vyatta/etc/config`
copy `/lib/live/mount/persistence/boot/OLD/rw/etc/ssh/` to `/lib/live/mount/persistence/boot/NEW/rw/etc/ssh/`
copy `/lib/live/mount/persistence/boot/NEW/NEW.cfg` to `/lib/live/mount/persistence/boot/grub/grub.cfg.d/vyos-versions/`

```vbash
show system image
set system image default-boot YYYY.MM.DD-HHMM-rolling # will update the grub config but the os boots using u-boot
```

## Flash u-boot to SPI Flash

Please visit https://gist.github.com/BtbN/9e5878d83816fb49d51d1f76c42d7945#boot-method first.

```bash
# U-BOOT Shell:
setenv bl2file bpi-r4_spim-nand_ubi_8GB_bl2.img
run run wrspimnand
```

```bash
# On VyOS or other linux
apt install mtd-utils
ubidetach -p /dev/mtd1
ubiformat /dev/mtd1
ubiattach -p /dev/mtd1
ubimkvol /dev/ubi0 -N fip -s 4MiB -t static
mkdir /tmp/p5
mount /dev/mmcblk0p5 /tmp/p5
ubiupdatevol /dev/ubi0_0 /tmp/p5/the_fip.bin
```

Now the u-boot on SPI flash cannot detect nvme SSD so it's no use.

## How to get defconfig

```bash
bash $PROJECT_ROOT/scripts/merge_config.sh -m --always-enable ../build/.config ../arch/arm64/configs/vyos_defconfig
bash $PROJECT_ROOT/scripts/merge_config.sh -m --always-enable .config data/config_overrides
```
