# Install guide for how to install quickshell in postmarketOS
----------
## Manual Installation
### 1. Install to packages
$ `sudo apk add cmake ninja qt6-qtbase-dev qt6-qtdeclarative-dev \
    qt6-qtwayland-dev wayland-protocols wayland-dev \
    pipewire-dev dbus-dev libxkbcommon-dev qt6-qtwayland-private-dev \
    qt6-qtbase-private-dev libunwind-dev polkit-elogind-dev linux-pam-dev \
    jemalloc-dev`
### 2. Build to CLI11
$ `sudo mkdir -p /usr/local/include/CLI11`<br>
$ `cd /tmp`<br>
$ `git clone https://github.com/CLIUtils/CLI11`<br>
$ `cd CLI11`<br>
$ `cmake -B build -DCLI11_BUILD_TESTS=OFF -DCLI11_BUILD_EXAMPLES=OFF`<br>
$ `sudo cmake --install build`
### 3. Build to CPPTRACE
$ `cd /tmp`<br>
$ `git clone https://github.com/jeremy-rifkin/cpptrace`<br>
$ `cd cpptrace`<br>
$ `cmake -B build -DCMAKE_BUILD_TYPE=Release - DCPPTRACE_UNWIND_WITH_LIBUNWIND=ON`<br>
$ `cmake --build build -j$(nproc)`<br>
$ `sudo cmake --install build`
### 4. Build to QuickShell
$ `cd`<br>
$ `git clone https://github.com/quickshell-mirror/quickshell.git`<br>
$ `cd quickshell`<br>
$ `cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release`<br>
$ `cmake --build build`<br>
$ `sudo cmake --install build`
