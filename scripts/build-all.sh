export PROJECT_ROOT=$(pwd)

set -e

echo "Updating package lists..."
sudo apt-get update
# sudo apt-get install -y gcc-aarch64-linux-gnu u-boot-tools bc make gcc ccache libc6-dev libncurses5-dev libssl-dev bison flex device-tree-compiler libelf-dev kmod libdw-dev libdebuginfod-dev systemtap-sdt-dev libunwind-dev libslang2-dev libperl-dev python3-dev python3 llvm-dev libzstd-dev libnuma-dev libbabeltrace-ctf-dev libcapstone-dev libpfm4-dev libtraceevent-dev libtracefs-dev default-jdk clang binutils-dev libcap-dev libbpf-dev asciidoc xmlto u-boot-tools

echo "Cloning vyos-arm64-build and vyos-build repositories..."
git clone https://github.com/huihuimoe/vyos-arm64-build
git clone https://github.com/vyos/vyos-build vyos-arm64-build/vyos-build

echo "Building vyos-1x package..."
bash scripts/patch-and-build-vyos-1x.sh
rm -rf $PROJECT_ROOT/vyos-arm64-build/vyos-build/scripts/package-build/vyos-1x

echo "Building kernel and related packages..."
bash scripts/patch-and-build-kernel.sh
bash scripts/patch-and-build-kernel-related-packages.sh
umount $PROJECT_ROOT/vyos-arm64-build/vyos-build/scripts/package-build/linux-kernel/build
rm -rf $PROJECT_ROOT/vyos-arm64-build/vyos-build/scripts/package-build/linux-kernel

echo "Building VyOS image..."
sudo -E bash scripts/patch-and-build-vyos-image.sh

echo "Generating final image..."
sudo -E bash scripts/generate_img.sh