# vyos-bpi-r4

This project is a personal learning project, mainly aimed at porting the VyOS to the BPI-R4 board for use.

Project dependencies:

-   [vyos-1x](https://github.com/vyos/vyos-1x)
-   [vyos-build](https://github.com/vyos/vyos-build)
-   [vyos-arm64-build](https://github.com/huihuimoe/vyos-arm64-build)
-   [vyos-arm64-autobuild](https://github.com/KawaiiNetworks/vyos-arm64-autobuild)
-   [BPI-Router-Linux](https://github.com/frank-w/BPI-Router-Linux)
-   [u-boot for banana pi](https://github.com/frank-w/u-boot)

## Prepare the build environment

```bash
git clone https://github.com/KawaiiNetworks/vyos-bpi-r4
cd vyos-bpi-r4
git checkout bpi-r4-6.17

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

## Patch and build Linux Kernel and related packages

Patch and build linux kernel

```bash
bash scripts/patch-and-build-kernel.sh
```

Patch and build linux kernel related packages:

linux-firmware qat igb ixgbe ixgbevf jool nat-rtsp ovpn-dco (seems that accel-ppp-ng is not required)

```bash
bash scripts/patch-and-build-kernel-related-packages.sh
```

## Build VyOS image

```bash
sudo -E bash scripts/patch-and-build-vyos-image.sh
```

English: Now we have obtained an iso file, but the iso file is not usable. What we need is just the filesystem.squashfs file inside it.

## Make SD Card Image

```bash
sudo -E bash scripts/generate_img.sh
```

Finally we get 2 img.gz in after build.

## How to USE

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
