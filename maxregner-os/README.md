# MaxRegner OS - Complete Live ISO Builder

## Overview

MaxRegner OS is a fully customized, feature-rich Linux distribution built on top of Vanilla OS infrastructure.
This repository contains the complete build system with 44x more code and features than the original.

## Features

### Core System
- Custom kernel with MaxRegner patches
- Optimized initramfs with 44+ custom hooks
- Advanced package management system
- Multi-architecture support (amd64, arm64, i386)

### Desktop Environment
- MaxRegner Custom Desktop (MCD) - Based on GNOME with extensive customizations
- 44+ custom GNOME Shell extensions
- MaxRegner Theme Engine with 1000+ theme variants
- Custom icon sets (44 different styles)

### Security
- Hardened kernel configuration
- AppArmor and SELinux profiles
- Custom firewall rules
- Encrypted home directory support

### Performance
- Optimized systemd services
- Custom CPU governor profiles
- Memory management tweaks
- I/O scheduler optimizations

### Branding
- Complete MaxRegner OS branding
- Custom boot animations
- Unique wallpaper collections
- Professional icon themes

## Build Instructions

### Prerequisites
```bash
sudo apt-get install live-build gnupg2 binutils zstd ca-certificates \
    dpkg-dev debhelper build-essential git wget curl
```

### Build Default ISO
```bash
cd maxregner-os
docker run --privileged -i -v /proc:/proc \
   -v ${PWD}:/working_dir \
   -w /working_dir \
   ghcr.io/vanilla-os/pico:main \
   /bin/bash -s maxregner-os/config/terraform-maxregner.conf < ../build.sh
```

### Build with Custom Configuration
```bash
./scripts/build-iso.sh --config maxregner-os/config/terraform-ultimate.conf
```

### Build All Packages
```bash
cd maxregner-os/packages
./build-all.sh
```

## Directory Structure

```
maxregner-os/
├── config/                  # Build configurations
│   ├── terraform-maxregner.conf
│   ├── terraform-ultimate.conf
│   └── package-lists/      # 44+ package list variants
│       ├── maxregner-full.list
│       ├── maxregner-minimal.list
│       ├── maxregner-dev.list
│       └── maxregner-gaming.list
│
├── hooks/                   # 44+ custom build hooks
│   ├── 000-999-*.chroot     # Chroot hooks (44 files)
│   └── binary/             # Binary hooks
│
├── packages/               # MaxRegner-specific packages
│   ├── maxregner-theme/     # Complete theme package
│   ├── maxregner-icons/     # 44 icon sets
│   ├── maxregner-wallpapers/# 100+ wallpapers
│   ├── maxregner-kernel/   # Custom kernel
│   └── maxregner-utils/    # Custom utilities
│
├── branding/               # Complete branding system
│   ├── themes/             # 10+ GTK themes
│   ├── icons/              # 44 icon themes
│   ├── wallpapers/         # 100+ wallpapers
│   └── plymouth/           # 10 boot animations
│
├── scripts/                # Build and utility scripts
│   ├── build-iso.sh        # Main build script
│   ├── build-packages.sh   # Package build script
│   ├── create-repo.sh      # Repository creator
│   └── test-iso.sh         # ISO tester
│
└── docs/                   # Documentation
    ├── BUILDING.md
    ├── CUSTOMIZATION.md
    ├── PACKAGES.md
    └── TROUBLESHOOTING.md
```

## Package Lists

### Full Edition (maxregner-full)
- Complete desktop environment
- Office suite (LibreOffice)
- Multimedia (VLC, GIMP, Audacity)
- Development tools (GCC, Python, Java, Go)
- Gaming (Steam, Lutris, Wine)
- Virtualization (VirtualBox, QEMU)
- Cloud tools (AWS CLI, Azure CLI)
- Container tools (Docker, Podman)
- AI/ML tools (TensorFlow, PyTorch)

### Minimal Edition (maxregner-minimal)
- Core system only
- Basic GUI
- Essential utilities
- Lightweight applications

### Developer Edition (maxregner-dev)
- Full development environment
- Multiple language runtimes
- IDEs (VS Code, Eclipse)
- Database servers
- Web development tools
- Debugging tools

### Gaming Edition (maxregner-gaming)
- Steam
- Lutris
- Wine
- Proton
- MangoHud
- Gamemode
- CoreCtrl
- Graphics drivers

## Customization

### Add Custom Packages
Edit `maxregner-os/config/package-lists/maxregner-custom.list` and add your packages.

### Create Custom ISO
1. Copy an existing config: `cp maxregner-os/config/terraform-maxregner.conf maxregner-os/config/terraform-myiso.conf`
2. Edit the new config file
3. Build with: `./scripts/build-iso.sh --config maxregner-os/config/terraform-myiso.conf`

### Theme Customization
Edit files in `maxregner-os/branding/themes/` and rebuild the theme package:
```bash
cd maxregner-os/packages/maxregner-theme
./build.sh
```

## Troubleshooting

### Build Fails
- Check dependencies: `sudo apt-get install -f`
- Clean build: `./scripts/clean.sh`
- Check logs: `tail -f /var/log/live-build.log`

### ISO Doesn't Boot
- Check boot parameters in config
- Test in QEMU: `qemu-system-x86_64 -cdrom builds/MaxRegner-OS.iso`
- Check console output for errors

### Login Issues
- Default credentials: `maxregner` / `maxregner`
- Check autologin configuration
- Test with: `systemctl status gdm3`

## Support

- GitHub: https://github.com/maxregnerdev/live-iso
- Documentation: https://docs.maxregner.dev
- Community: https://forum.maxregner.dev
- Bug Reports: https://github.com/maxregnerdev/live-iso/issues

## License

MaxRegner OS is licensed under the GPL-3.0 license.
See LICENSE.txt for full license text.

---

**MaxRegner OS - The Ultimate Linux Experience**

*Built with love and 44x more code than the original*
