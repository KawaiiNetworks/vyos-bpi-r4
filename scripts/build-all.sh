export PROJECT_ROOT=$(pwd)
export VYOS_BUILD_ROOT=$PROJECT_ROOT/vyos-build

set -e

echo "Updating package lists..."
sudo apt-get update
# sudo apt-get install -y gcc-aarch64-linux-gnu u-boot-tools bc make gcc ccache libc6-dev libncurses5-dev libssl-dev bison flex device-tree-compiler libelf-dev kmod libdw-dev libdebuginfod-dev systemtap-sdt-dev libunwind-dev libslang2-dev libperl-dev python3-dev python3 llvm-dev libzstd-dev libnuma-dev libbabeltrace-ctf-dev libcapstone-dev libpfm4-dev libtraceevent-dev libtracefs-dev default-jdk clang binutils-dev libcap-dev libbpf-dev asciidoc xmlto u-boot-tools

echo "Cloning vyos-build repositories..."
git clone https://github.com/vyos/vyos-build

bash scripts/patch-and-build-vyos-1x.sh


echo "Building kernel and related packages..."
bash scripts/patch-and-build-kernel.sh
bash scripts/patch-and-build-kernel-related-packages.sh
rm -rf $VYOS_BUILD_ROOT/scripts/package-build/linux-kernel

echo "Building VyOS image..."
sudo -E bash scripts/patch-and-build-vyos-image.sh
