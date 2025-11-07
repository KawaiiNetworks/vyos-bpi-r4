export PROJECT_ROOT=$(pwd)

sudo apt-get update
# sudo apt-get install -y gcc-aarch64-linux-gnu u-boot-tools bc make gcc ccache libc6-dev libncurses5-dev libssl-dev bison flex device-tree-compiler libelf-dev kmod libdw-dev libdebuginfod-dev systemtap-sdt-dev libunwind-dev libslang2-dev libperl-dev python3-dev python3 llvm-dev libzstd-dev libnuma-dev libbabeltrace-ctf-dev libcapstone-dev libpfm4-dev libtraceevent-dev libtracefs-dev default-jdk clang binutils-dev libcap-dev libbpf-dev asciidoc xmlto u-boot-tools

git clone https://github.com/huihuimoe/vyos-arm64-build
git clone https://github.com/vyos/vyos-build vyos-arm64-build/vyos-build

bash scripts/patch-and-build-vyos-1x.sh

bash scripts/patch-and-build-kernel.sh

bash scripts/patch-and-build-kernel-related-packages.sh

sudo -E bash scripts/patch-and-build-vyos-image.sh

sudo -E bash scripts/generate_img.sh