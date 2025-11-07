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

docker run -it --privileged --sysctl net.ipv6.conf.lo.disable_ipv6=0 -v $(pwd):/vyos -w /vyos ghcr.io/huihuimoe/vyos-arm64-build/vyos-builder:current-arm64 bash
```

In the container (we assume that the current user is not root):

```bash
export PROJECT_ROOT=$(pwd)

sudo apt update
sudo apt-get install -y gcc-aarch64-linux-gnu u-boot-tools bc make gcc ccache libc6-dev libncurses5-dev libssl-dev bison flex device-tree-compiler libelf-dev kmod libdw-dev libdebuginfod-dev systemtap-sdt-dev libunwind-dev libslang2-dev libperl-dev python3-dev python3 llvm-dev libzstd-dev libnuma-dev libbabeltrace-ctf-dev libcapstone-dev libpfm4-dev libtraceevent-dev libtracefs-dev default-jdk clang binutils-dev libcap-dev libbpf-dev asciidoc xmlto u-boot-tools

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
