# Install guide for how to install quickshell in postmarketOS
----------
## Manual Installation
### 1. Install to packages
`sudo apk add cmake ninja qt6-qtbase-dev qt6-qtdeclarative-dev \
    qt6-qtwayland-dev wayland-protocols wayland-dev \
    pipewire-dev dbus-dev libxkbcommon-dev qt6-qtwayland-private-dev \
    qt6-qtbase-private-dev libunwind-dev polkit-elogind-dev linux-pam-dev \
    jemalloc-dev`
### 2. Build to CLI11
`sudo mkdir -p /usr/local/include/CLI11
cd /tmp
git clone https://github.com/CLIUtils/CLI11
cd CLI11
cmake -B build -DCLI11_BUILD_TESTS=OFF -DCLI11_BUILD_EXAMPLES=OFF
sudo cmake --install build`
### 3. Build to CPPTRACE
`cd /tmp
git clone https://github.com/jeremy-rifkin/cpptrace
cd cpptrace
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCPPTRACE_UNWIND_WITH_LIBUNWIND=ON
cmake --build build -j$(nproc)
sudo cmake --install build`
### 4. Build to QuickShell
`cd
git clone https://github.com/quickshell-mirror/quickshell.git
cd quickshell
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build`
