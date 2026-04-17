# Ideas for Ft-Nixos Configuration — Tools & Enhancements

A collection of potential additions and improvements for the existing NixOS configuration.

---

## Quality-of-Life Tools (Easy Adds)

| # | Tool | Description | Why Add It |
|---|------|-------------|------------|
| 1 | `swappy` | Screenshot annotation (draw arrows, blur, text) | Edit screenshots before saving/sharing |
| 2 | `wf-recorder` | Screen recording for Wayland | Basic need, missing entirely |
| 3 | `peek` | GIF screen recorder | Quick GIFs for bug reports/demos |
| 4 | `rbw` | Bitwarden CLI (unofficial, Rust) | Fast password lookup in terminal |
| 5 | `rofi-rbw` | Bitwarden rofi integration | GUI password picker (or integrate into nixprism) |
| 6 | `helvum` / `qpwgraph` | PipeWire patchbay GUI | Visual audio routing |
| 7 | `easyeffects` | Audio effects / EQ for PipeWire | Essential for headphone users |
| 8 | `navi` | Interactive cheatsheets with fuzzy finding | Better than `cheat`, more discoverable |
| 9 | `zk` | Terminal Zettelkasten note-taking | Markdown notes in terminal |
| 10 | `pgcli` / `litecli` / `mycli` | Better SQL REPLs with autocomplete | Database work without GUI |
| 11 | `websocat` | WebSocket testing from CLI | API debugging |
| 12 | `grpcurl` | gRPC testing from CLI | API debugging |
| 13 | `distrobox` | Run any Linux distro in containers | Use packages not in nixpkgs |
| 14 | `podman` + `podman-compose` | Rootless containers | Docker alternative, daemonless |
| 15 | `quickemu` | Quick VMs with zero config | Test distros, Windows, etc. |
| 16 | `zeal` | Offline API documentation | Like Dash on macOS |
| 17 | `dbeaver` / `beekeeper-studio` | GUI database manager | Visual database exploration |
| 18 | `tailscale` | Mesh VPN for remote access | Access machines anywhere easily |
| 19 | `mullvad-vpn` / `protonvpn-cli` | Privacy VPN | Privacy-focused browsing |
| 20 | `wireguard-tools` | WireGuard VPN management | Simple, fast VPN connections |
| 21 | `gpg` + `pinentry-rofi` | Encryption + signing | Git commit signing, file encryption |
| 22 | `yubikey-manager` | YubiKey management | If using YubiKeys |
| 23 | `syncthing` | Continuous file synchronization | Sync files between devices (photos, docs) |
| 24 | `rclone` | Cloud storage sync | Mount Google Drive, Dropbox, etc. |
| 25 | `borgbackup` / `restic` | Deduplicating backup | Encrypted backups to external/cloud |
| 26 | `ncdu` | Disk usage analyzer (ncurses) | Find what's eating disk space |
| 27 | `duf` | Disk usage viewer | Pretty `df` alternative |
| 28 | `procs` | Modern `ps` replacement | Colorful process list with search |
| 29 | `bandwhich` | Network bandwidth monitor | See which processes use bandwidth |
| 30 | `dog` | Modern `dig` replacement | DNS lookup with pretty output |
| 31 | `xh` | HTTPie alternative in Rust | Already have, but ensure it's configured |
| 32 | `jaq` | `jq` alternative in Rust | Faster JSON processing |
| 33 | `jless` | JSON pager with folding | Explore large JSON files |
| 34 | `fx` | Terminal JSON viewer | Interactive JSON explorer |
| 35 | `hexyl` | Hex viewer with colors | Inspect binary files |
| 36 | `binutils` / `elfinfo` | Binary analysis | Inspect ELF binaries |
| 37 | `strace` / `ltrace` | System call tracing | Debug program behavior |
| 38 | `perf` | Linux profiling | Performance analysis |
| 39 | `flamegraph` | Visualization for perf | Flame graphs for performance |
| 40 | `hyperfine` | Benchmarking | Already have, good |

---

## Desktop Experience Improvements

| # | Idea | Description | Implementation |
|---|------|-------------|----------------|
| 1 | Wallpaper picker in nixprism | `SUPER+Space` → `~` → browse wallpapers | Add mode to nixprism, integrate with swww |
| 2 | Random wallpaper keybinding | `SUPER+Shift+W` → random wallpaper | Script + Hyprland bind |
| 3 | Per-workspace wallpapers | Different wallpaper per workspace | Hyprland workspace rules + swww |
| 4 | Window overview mode | Mission Control / Expo style | `hycov` plugin or `hyprexpo` plugin |
| 5 | Window switcher in nixprism | `SUPER+Space` → `w` → list windows | Query Hyprland sockets, show in rofi |
| 6 | DND toggle keybinding | `SUPER+Shift+D` → toggle mako DND | `makoctl mode` + Hyprland bind |
| 7 | Notification history | `SUPER+Space` → `!` → recent notifications | Parse mako history, show in nixprism |
| 8 | Auto-lock on lid close | Suspend + lock when laptop lid closes | Hypridle lid switch binding |
| 9 | Better idle management | Different timeouts for AC vs battery | UPower integration + hypridle profiles |
| 10 | Polished logout menu | `SUPER+Shift+E` → lock/logout/suspend/reboot/shutdown | nixprism mode or custom rofi menu |
| 11 | Emoji picker | `SUPER+.` → emoji picker | `wofi-emoji` or `rofi-emoji` integrated into nixprism |
| 12 | Calculator popup | `SUPER+=` → quick calculator | `rofi-calc` or custom script |
| 13 | Color picker | `SUPER+Shift+C` → pick color under cursor | `hyprpicker` + copy to clipboard |
| 14 | QR code generator | Select text → generate QR | `wl-clipboard` + `qrencode` + notification |
| 15 | Screenshot OCR | Screenshot → extract text | `tesseract` + `grim` + `slurp` |
| 16 | Quick notes | `SUPER+N` → popup note taker | Save to `~/notes/quick/` with timestamp |
| 17 | Pomodoro timer | `SUPER+Shift+T` → start 25min timer | Notification when done, tray indicator |
| 18 | Weather widget | Waybar module or popup | `wttr.in` + curl |
| 19 | Music control popup | `SUPER+M` → now playing + controls | `playerctl` + album art + progress |
| 20 | Bluetooth device picker | `SUPER+B` → connect/disconnect BT devices | `bluetoothctl` + nixprism |
| 21 | WiFi network picker | `SUPER+Shift+W` → connect to networks | `nmcli` + nixprism |
| 22 | Volume mixer popup | `SUPER+V` (or different) → per-app volume | `pavucontrol` in floating window or custom |
| 23 | Brightness / color temp | Night shift / redshift integration | `wlsunset` or `gammastep` |
| 24 | Battery warning | Low battery notification + auto-suspend | UPower + notify + hypridle |
| 25 | USB mount helper | Auto-mount USB drives with notification | `udisks2` + custom script |

---

## Developer Experience

| # | Improvement | Description | Priority |
|---|-------------|-------------|----------|
| 1 | `direnv` + `nix-direnv` | Auto-enter nix shells per project | Already have direnv, ensure nix-direnv is used |
| 2 | Devenv / Flake templates | Per-project `flake.nix` templates | Create templates for common stacks |
| 3 | `gh` CLI | GitHub CLI for PRs, issues, repos | Missing entirely |
| 4 | `glab` CLI | GitLab CLI | If using GitLab |
| 5 | `jira-cli` / `linear` | Issue tracker CLI | If using Jira/Linear |
| 6 | `terraform` / `opentofu` | Infrastructure as Code | If doing DevOps/cloud work |
| 7 | `pulumi` | Modern IaC | Alternative to Terraform |
| 8 | `awscli2` / `azure-cli` / `gcloud` | Cloud CLIs | If using cloud providers |
| 9 | `flyctl` | Fly.io CLI | If deploying to Fly.io |
| 10 | `vercel-cli` / `netlify-cli` | Static hosting CLIs | If using Vercel/Netlify |
| 11 | `cargo-binstall` | Install Rust binaries without compiling | Faster Rust tool installation |
| 12 | `rustup` | Rust toolchain manager | If doing Rust development |
| 13 | `pyenv` / `poetry` / `uv` | Python environment management | If doing Python development |
| 14 | `fnm` / `volta` | Node version manager | Already have fnm, ensure it's working |
| 15 | `mise` | Universal version manager (asdf replacement) | One tool for all language versions |
| 16 | `tmux` / `zellij` | Terminal multiplexer | Persistent terminal sessions |
| 17 | `asciinema` | Terminal session recorder | Record and share terminal sessions |
| 18 | `codex` CLI | OpenAI Codex CLI | AI coding agent (if available) |
| 19 | `aider` | AI pair programming in terminal | Multi-file AI editing |
| 20 | `continue` | AI coding assistant (VS Code/Zed) | Alternative to Copilot |

---

## Top Priority Recommendations

| Rank | Item | Category | Effort | Impact |
|------|------|----------|--------|--------|
| 1 | Add `distrobox` | Tools | Low | High |
| 2 | Add `swappy` + `wf-recorder` | Tools | Low | High |
| 3 | Add `zeal` | Tools | Low | Medium |
| 4 | Add `navi` | Tools | Low | Medium |
| 5 | Add `tailscale` | Tools | Low | High |
| 6 | Add `gh` CLI | Dev | Low | High |
| 7 | Add emoji picker to nixprism | Desktop | Low | Medium |
| 8 | Add color picker keybinding | Desktop | Low | Medium |
| 9 | Add calculator popup | Desktop | Low | Medium |
| 10 | Add wallpaper picker to nixprism | Desktop | Medium | Medium |

---

*Last updated: 2026-04-17*
