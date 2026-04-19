# Ideas for Ft-Nixos — Experimental & Wildcard Flake Projects

A collection of potential standalone flakes that extend the NixOS ecosystem. Each follows the same pattern as ft-nixpalette, ft-nixpalette-hyprland, and ft-nixprism: a focused tool with deep Stylix/ft-nixpalette integration and Hyprland support.

For **already-built flakes**, see [`IDEAS-done.md`](./IDEAS-done.md).  
For **prioritized build order**, see [`IDEAS-priority.md`](./IDEAS-priority.md).

---

## Core Philosophy

Every flake in this ecosystem should:
- Follow the **ft-nixpalette/Stylix color system** automatically
- Integrate cleanly with **Hyprland** (blur rules, keybindings)
- Be installable via a **Home Manager module**
- Feel **polished and cohesive** with the rest of the desktop

---

## Wildcard / Experimental Ideas

These are ideas that don't yet have a priority tier. Some may become their own flakes, others may be absorbed into existing ones.

| Name | Concept | Vibe |
|------|---------|------|
| **nixmusic** | Unified music control (MPRIS + multiple sources) | "One interface for Spotify, local files, YouTube Music" |
| **nixchat** | Unified chat launcher (Discord, Element, Slack, Telegram) | "SUPER+C → pick chat app → jump to specific conversation" |
| **nixwork** | Work mode automator (Slack status, calendar focus, DND) | "Start focus mode → everything distracting disappears" |
| **nixgame** | Gaming mode (performance governor, disable compositor effects, RGB sync) | "One key → optimal gaming setup" |
| **nixlearn** | Spaced repetition popup (Anki-style flashcards in notifications) | "Learn while you work, micro-reviews" |
| **nixtimer** | Advanced timer/stopwatch/alarm system | "Pomodoro, tea timer, meeting reminders — all unified" |
| **nixclip** | Clipboard history on steroids (searchable, persistent, categorized) | "Find that URL from 3 days ago instantly" |
| **nixsearch** | Unified search (files, web, calculator, dictionary, translate) | "One search box for everything" |
| **nixmon** | System monitor dashboard (CPU, GPU, network, temps in one view) | "bpytop but as a native desktop widget" |
| **nixwifi** | WiFi network manager with visual signal map | "See networks, signal strength, connect with one key" |
| **nixbt** | Bluetooth device manager with battery levels | "See all BT devices, battery, connect/disconnect" |
| **nixpower** | Power profile manager (battery saver, balanced, performance) | "Auto-switch based on AC/battery, with notifications" |
| **nixupdate** | Update notifier + one-click updater | "Know when updates are available, apply with one key" |
| **nixbackup** | Snapshot backup manager (Btrfs/ZFS snapshots) | "Create, restore, schedule snapshots easily" |
| **nixdocker** | Docker container manager (TUI + GUI popup) | "See running containers, logs, stats, quick actions" |
| **nixgit** | Git repository overview (status across all repos) | "See all your repos' status in one place" |
| **nixtodo** | Quick todo capture + review (integrates with any backend) | "SUPER+T → capture → later review in your app of choice" |
| **nixcalc** | Advanced calculator popup (math, unit conversion, currency) | "More than basic arithmetic — full expr-eval" |
| **nixtrans** | Quick translate popup (select text → translate) | "Any language, any time, right on your desktop" |
| **nixdict** | Dictionary / thesaurus popup | "Word lookup without opening a browser" |
| **nixweather** | Weather widget + travel forecast | "Current + hourly + weekly, multiple locations" |
| **nixnews** | RSS news reader popup | "Quick headline scan without opening an app" |
| **nixstock** | Stock/crypto price tracker | "Portfolio overview in your bar or popup" |
| **nixcrypto** | Crypto wallet monitor | "Track addresses, get price alerts" |
| **nixpass** | One-time password (TOTP) manager | "2FA codes without reaching for your phone" |
| **nixssh** | SSH connection manager + launcher | "All your hosts, one key away, with connection profiles" |
| **nixvpn** | VPN connection manager | "Toggle VPN, see status, auto-connect on untrusted networks" |
| **nixfirewall** | Simple firewall rule manager | "Allow/block ports with a GUI, see active connections" |
| **nixdisk** | Disk usage visualizer + cleaner | "What's eating my space? Clean it up." |
| **nixnet** | Network connection visualizer | "See active connections, bandwidth per app, block apps" |
| **nixproc** | Process manager (kill, nice, inspect) | "Like htop but as a popup launcher" |
| **nixsys** | System info dashboard | "OS version, kernel, uptime, packages — pretty display" |
| **nixkey** | Keybinding cheat sheet | "Forgot a shortcut? Press SUPER+? to see all" |
| **nixtheme** | Live theme preview + switcher | "See all your themes, switch instantly, customize on the fly" |
| **nixcolor** | Color palette tool (extract from wallpaper, generate schemes) | "Create ft-nixpalette themes from any image" |
| **nixwall** | Wallpaper manager (sources, schedules, effects) | "Unsplash, local folders, slideshows, blur effects" |
| **nixcursor** | Cursor theme manager + preview | "Test cursor themes, apply system-wide" |
| **nixicon** | Icon theme manager + preview | "Browse icon themes, see previews, apply" |
| **nixgtk** | GTK theme preview + switcher | "Live preview GTK themes before applying" |
| **nixqt** | Qt theme configuration helper | "Make Qt apps match your GTK theme" |
| **nixemoji** | Emoji picker with search + favorites | "Better than basic emoji pickers — organized, searchable" |
| **nixsymbol** | Special character picker | "Math symbols, arrows, currency — for writers/devs" |
| **nixkaomoji** | Kaomoji picker (╯°□°）╯︵ ┻━┻ | "Japanese emoticons for fun" |
| **nixascii** | ASCII art generator | "Convert text to ASCII art for terminals" |
| **nixqr** | QR code generator + scanner | "Make QR codes from text/URLs, scan from screen" |
| **nixbarcode** | Barcode generator | "Generate various barcode formats" |
| **nixhash** | Hash calculator (MD5, SHA, etc.) | "Quick file/string hashing" |
| **nixuuid** | UUID/ULID generator | "Generate identifiers quickly" |
| **nixjwt** | JWT decoder/inspector | "Debug JWT tokens visually" |
| **nixbase64** | Base64 encoder/decoder | "Quick encode/decode with clipboard" |
| **nixurl** | URL encoder/decoder | "Fix URLs quickly" |
| **nixjson** | JSON formatter/validator | "Prettify, minify, validate JSON" |
| **nixyaml** | YAML ↔ JSON converter | "Convert between formats" |
| **nixcsv** | CSV ↔ JSON converter + viewer | "Quick CSV inspection" |
| **nixregex** | Regex tester | "Test patterns with live matches" |
| **nixcron** | Cron expression generator | "Human-readable cron builder" |
| **nixsql** | SQL formatter + explainer | "Prettify SQL, explain execution" |
| **nixdiff** | File/text diff viewer | "Quick diffs without opening an editor" |
| **nixpatch** | Patch file applier | "Apply .patch files easily" |
| **nixgitdiff** | Git diff viewer popup | "See changes before committing" |
| **nixgitblame** | Git blame viewer | "See who wrote what quickly" |
| **nixgitlog** | Git log visualizer | "Pretty git log without leaving desktop" |
| **nixgitstash** | Git stash manager | "View, apply, drop stashes easily" |
| **nixgitbranch** | Git branch switcher | "Visual branch list, quick switch" |
| **nixgitremote** | Git remote manager | "Add, remove, view remotes" |
| **nixgittag** | Git tag manager | "Create, delete, list tags" |
| **nixgithub** | GitHub quick actions (PRs, issues, notifications) | "See GitHub activity without opening browser" |
| **nixdockerlog** | Docker log viewer | "Follow logs for any container" |
| **nixdockerexec** | Docker exec launcher | "Quick shell into any container" |
| **nixdockerstats** | Docker stats viewer | "Resource usage per container" |
| **nixk8s** | Kubernetes context switcher | "Switch clusters/namespaces quickly" |
| **nixk8spod** | Kubernetes pod manager | "View pods, logs, exec, delete" |
| **nixk8slog** | Kubernetes log viewer | "Follow logs from multiple pods" |
| **nixk8sdeploy** | Kubernetes deployment manager | "Scale, restart, rollback deployments" |
| **nixaws** | AWS resource quick view | "See running instances, buckets, etc." |
| **nixgcp** | GCP resource quick view | "See GCP resources quickly" |
| **nixazure** | Azure resource quick view | "See Azure resources quickly" |
| **nixdomain** | Domain/DNS lookup tool | "WHOIS, DNS records, propagation check" |
| **nixssl** | SSL certificate checker | "Check cert expiry, chain, details" |
| **nixping** | Multi-target ping monitor | "Monitor multiple hosts simultaneously" |
| **nixport** | Port scanner | "Quick port scan of any host" |
| **nixip** | IP info lookup | "Your IP, geolocation, ISP info" |
| **nixmac** | MAC address lookup | "Vendor lookup for MAC addresses" |
| **nixspeed** | Internet speed test | "Quick speed test from desktop" |
| **nixlatency** | Latency monitor | "Track latency to multiple hosts over time" |
| **nixuptime** | Uptime monitor | "Track service uptime, get alerts" |
| **nixhttp** | HTTP request builder | "Build and send HTTP requests visually" |
| **nixws** | WebSocket client | "Test WebSocket connections" |
| **nixgrpc** | gRPC request builder | "Test gRPC services" |
| **nixmqtt** | MQTT client | "Publish/subscribe to MQTT topics" |
| **nixredis** | Redis client | "Browse Redis keys, execute commands" |
| **nixdb** | Database connection browser | "Quick browse for PostgreSQL, MySQL, SQLite" |
| **nixapi** | API documentation browser | "Browse OpenAPI specs, test endpoints" |
| **nixswagger** | Swagger UI launcher | "Open Swagger UI for local APIs" |
| **nixgraphql** | GraphQL query builder | "Build and test GraphQL queries" |
| **nixmarkdown** | Markdown previewer | "Live preview markdown with rendering" |
| **nixhtml** | HTML previewer | "Quick HTML render preview" |
| **nixcss** | CSS specificity calculator | "Debug CSS specificity issues" |
| **nixcolorpicker** | Advanced color picker | "Pick from screen, palette, harmonies" |
| **nixgradient** | CSS gradient generator | "Create beautiful gradients" |
| **nixshadow** | CSS shadow generator | "Create box-shadow values" |
| **nixflex** | Flexbox playground | "Visual flexbox builder" |
| **nixgrid** | CSS Grid playground | "Visual grid builder" |
| **nixsvg** | SVG editor/previewer | "Quick SVG edits and previews" |
| **nixpng** | PNG optimizer | "Compress PNGs without quality loss" |
| **nixjpg** | JPEG optimizer | "Compress JPEGs with quality control" |
| **nixgif** | GIF optimizer/editor | "Compress, crop, edit GIFs" |
| **nixvideo** | Video converter | "Quick format conversion" |
| **nixaudio** | Audio converter | "Quick format conversion, metadata edit" |
| **nixpdf** | PDF tools (merge, split, compress) | "Common PDF operations" |
| **niximage** | Image converter/resizer | "Batch convert, resize, format change" |
| **nixrename** | Bulk file renamer | "Pattern-based bulk renaming" |
| **nixchecksum** | Checksum verifier | "Verify file integrity with various algorithms" |
| **nixencrypt** | File encryption tool | "Encrypt/decrypt files with password or key" |
| **nixshred** | Secure file deletion | "Overwrite and delete files securely" |
| **nixrecover** | File recovery helper | "Attempt to recover deleted files" |
| **nixsyncdir** | Directory sync tool | "Two-way sync between folders" |
| **nixarchive** | Archive manager | "Create, extract, browse archives" |
| **nixcompress** | Compression analyzer | "Find best compression for files" |
| **nixduplicate** | Duplicate file finder | "Find and manage duplicate files" |
| **nixempty** | Empty directory finder | "Find and clean empty folders" |
| **nixold** | Old file finder | "Find files not accessed in X days" |
| **nixlarge** | Large file finder | "Find biggest files for cleanup" |
| **nixtemp** | Temp file cleaner | "Clean temporary files safely" |
| **nixcache** | Cache cleaner | "Clean application caches" |
| **nixtrash** | Trash manager | "View, restore, empty trash" |
| **nixhistory** | Shell history searcher | "Fuzzy search through all shell history" |
| **nixalias** | Alias finder/manager | "Find existing aliases, create new ones" |
| **nixenv** | Environment variable viewer | "View and search env vars" |
| **nixpath** | PATH analyzer | "See where each PATH entry comes from" |
| **nixservice** | Systemd service manager | "Enable, disable, start, stop services" |
| **nixtimer** | Systemd timer manager | "View and manage timers" |
| **nixsocket** | Unix socket viewer | "See active sockets and their owners" |
| **nixpipe** | Named pipe viewer | "See active pipes and their traffic" |
| **nixmount** | Mount point manager | "View, mount, unmount filesystems" |
| **nixdiskhealth** | Disk health checker | "SMART status for all disks" |
| **nixraid** | RAID status viewer | "Monitor software RAID arrays" |
| **nixzfs** | ZFS pool manager | "Monitor ZFS pools, snapshots" |
| **nixbtrfs** | Btrfs volume manager | "Monitor Btrfs volumes, snapshots" |
| **nixlvm** | LVM volume manager | "Manage logical volumes" |
| **nixpart** | Partition manager | "View and modify partitions" |
| **nixboot** | Boot entry manager | "Manage systemd-boot entries" |
| **nixkernel** | Kernel module manager | "Load, unload, view kernel modules" |
| **nixdriver** | Driver info viewer | "See loaded drivers and their devices" |
| **nixusb** | USB device viewer | "See connected USB devices" |
| **nixpci** | PCI device viewer | "See PCI devices and their drivers" |
| **nixbluetooth** | Bluetooth device detailed manager | "Full BT device management" |
| **nixprinter** | Printer manager | "Add, remove, configure printers" |
| **nixscanner** | Scanner manager | "Configure and use scanners" |
| **nixcamera** | Camera test tool | "Test and configure webcams" |
| **nixmic** | Microphone test tool | "Test and configure microphones" |
| **nixspeaker** | Speaker test tool | "Test audio output" |
| **nixdisplay** | Display/monitor manager | "Configure resolutions, scaling, arrangements" |
| **nixinput** | Input device manager | "Configure keyboards, mice, touchpads" |
| **nixgamepad** | Gamepad tester | "Test and configure controllers" |
| **nixvr** | VR headset manager | "Configure VR headsets (if applicable)" |
| **nixwine** | Wine prefix manager | "Manage Wine prefixes and apps" |
| **nixappimage` | AppImage launcher/integrator | "Run AppImages like native apps" |
| **nixflatpak** | Flatpak manager | "Install, update, remove Flatpaks" |
| **nixsnap** | Snap manager (if using) | "Manage snap packages" |
| **nixcargo** | Cargo crate browser | "Search crates.io, view docs" |
| **nixnpm** | NPM package browser | "Search npm, view package info" |
| **nixpypi** | PyPI package browser | "Search PyPI, view package info" |
| **nixdockerhub** | Docker Hub browser | "Search images, view tags" |
| **nixgithubrel** | GitHub release watcher | "Track new releases for repos" |
| **nixchangelog** | Changelog viewer | "View changelogs for installed packages" |
| **nixissue** | Issue tracker | "Track issues across projects" |
| **nixpr** | PR tracker | "Track pull requests across projects" |
| **nixreview** | Code review helper | "Quick review actions for PRs" |
| **nixci** | CI status viewer | "View CI status for repos" |
| **nixdeploy** | Deployment trigger | "Trigger deployments from desktop" |
| **nixrollback** | Quick rollback | "Rollback NixOS generation quickly" |
| **nixgc** | Garbage collect helper | "Visual garbage collection with space freed" |
| **nixoptimize** | Store optimizer | "Visual store optimization" |
| **nixsearchpkg** | Package search | "Search nixpkgs with previews" |
| **nixpkginfo** | Package info viewer | "Detailed package information" |
| **nixcompare** | Package comparison | "Compare versions across channels" |
| **nixchannel** | Channel manager | "Manage nix channels/flake inputs" |
| **nixrepl** | Nix REPL helper | "Enhanced nix repl with completions" |
| **nixeval** | Nix expression evaluator | "Evaluate nix expressions quickly" |
| **nixbuild** | Build watcher | "Watch nix builds with progress" |
| **nixshell** | Shell environment manager | "Manage and switch nix shells" |
| **nixprofile** | Profile manager | "Manage nix profiles" |
| **nixgeneration** | Generation manager | "Visual generation list, diff, rollback" |
| **nixdiff** | System diff viewer | "See what changed between generations" |
| **nixsize** | Closure size analyzer | "Find what's taking space in closure" |
| **nixwhy** | Dependency explainer | "Why is this package in my closure?" |
| **nixtree** | Dependency tree viewer | "Visual package dependency tree" |
| **nixreverse** | Reverse dependency viewer | "What depends on this package?" |
| **nixvuln** | Vulnerability checker | "Check installed packages for CVEs" |
| **nixlicense** | License checker | "See licenses of all installed packages" |
| **nixupdate** | Update checker | "Check for available updates" |
| **nixnews** | NixOS news reader | "Read NixOS release notes, blog" |
| **nixwiki** | NixOS wiki search | "Search NixOS wiki quickly" |
| **nixoption** | NixOS option search | "Search NixOS options with descriptions" |
| **nixexample** | NixOS config examples | "Browse community configurations" |
| **nixhome** | Home Manager option search | "Search HM options" |
| **nixflake** | Flake hub browser | "Browse flakehub, search flakes" |
| **nixtemplate** | Flake template browser | "Browse and use flake templates" |
| **nixdevshell** | Development shell browser | "Browse and enter dev shells" |
| **nixcache** | Binary cache manager | "Manage substituters and caches" |
| **nixkey** | Signing key manager | "Manage Nix signing keys" |
| **nixsecret** | Secret manager (sops helper) | "Manage sops secrets visually" |
| **nixage** | Age key manager | "Manage age encryption keys" |
| **nixsshkey** | SSH key manager | "Generate, view, manage SSH keys" |
| **nixgpgkey** | GPG key manager | "Manage GPG keys and trust" |
| **nixcert** | Certificate manager | "Manage TLS certificates" |
| **nixhosts** | Hosts file editor | "Edit /etc/hosts with validation" |
| **nixdns** | DNS config tester | "Test DNS resolution, compare servers" |
| **nixproxy** | Proxy config manager | "Manage HTTP/HTTPS/SOCKS proxies" |
| **nixvpnconf** | VPN config manager | "Manage WireGuard/OpenVPN configs" |
| **nixfirewall** | Firewall rule viewer | "View and test firewall rules" |
| **nixroute** | Routing table viewer | "View and understand routing" |
| **nixarp** | ARP table viewer | "View ARP entries" |
| **nixtraffic** | Traffic analyzer | "See network traffic by app/protocol" |
| **nixbandwidth** | Bandwidth monitor | "Real-time bandwidth usage" |
| **nixlatency** | Latency map | "Visual latency to various locations" |
| **nixgeo** | IP geolocation | "See where IPs are located" |
| **nixwhois** | WHOIS lookup | "Domain registration info" |
| **nixdig** | DNS dig helper | "Pretty DNS lookups" |
| **nixtraceroute** | Traceroute visualizer | "Visual traceroute with map" |
| **nixnetstat** | Connection viewer | "See all network connections" |
| **nixlistener** | Port listener viewer | "See what's listening on each port" |
| **nixfirewalllog** | Firewall log viewer | "View dropped/blocked connections" |
| **nixids** | Intrusion detection viewer | "View fail2ban, etc. alerts" |
| **nixlog** | System log viewer | "Pretty system log viewer" |
| **nixjournal** | Journalctl helper | "Search and view systemd journal" |
| **nixcrash** | Crash report viewer | "View and analyze crash dumps" |
| **nixcoredump** | Core dump manager | "View and analyze core dumps" |
| **nixstrace** | Syscall tracer | "Trace system calls visually" |
| **nixperf** | Performance profiler | "Profile CPU/memory usage" |
| **nixflame** | Flame graph generator | "Generate flame graphs easily" |
| **nixheatmap** | CPU heatmap | "Visual CPU usage over time" |
| **nixmemory** | Memory map viewer | "Visual memory usage breakdown" |
| **nixio** | IO analyzer | "Disk IO analysis" |
| **nixsyscall** | Syscall counter | "Most used syscalls per app" |
| **nixrace** | Race condition detector | "Detect data races" |
| **nixleak** | Memory leak detector | "Find memory leaks" |
| **nixsanitizer** | Sanitizer output parser | "Pretty sanitizer output" |
| **nixcoverage** | Code coverage viewer | "View test coverage visually" |
| **nixbenchmark** | Benchmark runner | "Run and compare benchmarks" |
| **nixprofile** | Profiler output viewer | "View perf/cachegrind output" |
| **nixdebug** | Debugger launcher | "Quickly debug any binary" |
| **nixtrace** | Execution tracer | "Trace program execution" |
| **nixreplay** | Record/replay debugger | "Record and replay executions" |
| **nixmutate` | Mutation testing | "Test your tests" |
| **nixfuzz** | Fuzzing launcher | "Quick fuzz testing setup" |
| **nixproperty** | Property-based testing | "QuickCheck-style testing helper" |
| **nixsnapshot** | Test snapshot manager | "Manage and update snapshots" |
| **nixmock** | Mock server launcher | "Quick HTTP mock servers" |
| **nixstub** | API stub generator | "Generate stubs from OpenAPI" |
| **nixfixture** | Test fixture manager | "Manage test data/fixtures" |
| **nixseed** | Database seeder | "Seed databases with test data" |
| **nixfactory** | Test factory generator | "Generate test object factories" |
| **nixfake** | Fake data generator | "Generate realistic fake data" |
| **nixload** | Load test launcher | "Quick load testing setup" |
| **nixchaos** | Chaos engineering | "Introduce failures for testing" |
| **nixcanary** | Canary deployment helper | "Deploy canaries safely" |
| **nixfeature** | Feature flag manager | "Manage feature flags" |
| **nixexperiment** | A/B test helper | "Setup and analyze A/B tests" |
| **nixconfig** | Config validation | "Validate config files" |
| **nixschema** | Schema validator | "Validate against JSON Schema, etc." |
| **nixlint** | Multi-linter runner | "Run all relevant linters" |
| **nixformat** | Multi-formatter runner | "Run all relevant formatters" |
| **nixtype** | Type checker | "Run type checkers for the project" |
| **nixtest** | Test runner | "Run all tests with nice output" |
| **nixdoc** | Doc generator | "Generate docs for the project" |
| **nixchangelog** | Changelog generator | "Generate changelog from commits" |
| **nixrelease** | Release helper | "Bump version, tag, release" |
| **nixpublish** | Package publisher | "Publish to npm/crates.io/PyPI" |
| **nixdeploy** | Deploy helper | "Deploy to various platforms" |
| **nixrollback** | Quick rollback | "Rollback deployments" |
| **nixmonitor** | Production monitor | "View production metrics" |
| **nixalert** | Alert manager | "View and manage alerts" |
| **nixincident** | Incident response | "Manage incident response" |
| **nixrunbook** | Runbook viewer | "View and execute runbooks" |
| **nixplaybook** | Ansible playbook runner | "Run Ansible playbooks" |
| **nixterraform** | Terraform plan/applier | "Quick Terraform workflows" |
| **nixpulumi** | Pulumi stack manager | "Manage Pulumi stacks" |
| **nixhelm** | Helm chart manager | "Manage Helm deployments" |
| **nixkubectl** | Kubectl helper | "Common kubectl workflows" |
| **nixdocker** | Docker helper | "Common Docker workflows" |
| **nixcompose** | Docker Compose helper | "Common Compose workflows" |
| **nixbuildkit** | BuildKit helper | "Advanced Docker builds" |
| **nixkaniko** | Kaniko builder | "Build images without Docker" |
| **nixko** | Ko builder | "Build Go containers easily" |
| **nixpack** | Buildpack runner | "Build with Cloud Native Buildpacks" |
| **nixjib** | Jib builder | "Build Java containers easily" |
| **nixsource** | Source-to-image builder | "S2I builds" |
| **nixfunction` | Function builder | "Build functions for serverless" |
| **nixwasm** | WASM builder | "Build and run WASM modules" |
| **nixoci** | OCI image tools | "Work with OCI images directly" |
| **nixsbom** | SBOM generator | "Generate software bill of materials" |
| **nixsign** | Image signer | "Sign container images" |
| **nixscan** | Vulnerability scanner | "Scan images for CVEs" |
| **nixattest** | Attestation manager | "Manage build attestations" |
| **nixprovenance** | Provenance tracker | "Track build provenance" |
| **nixsupply** | Supply chain checker | "Verify supply chain security" |
| **nixslsa** | SLSA compliance checker | "Check SLSA compliance" |
| **nixscorecard** | OpenSSF Scorecard | "Check security score" |
| **nixdependabot** | Dependency update checker | "Check for dependency updates" |
| **nixrenovate** | Renovate config helper | "Manage Renovate configuration" |
| **nixsnyk** | Snyk integration | "Run Snyk scans" |
| **nixtrivy** | Trivy scanner | "Run Trivy vulnerability scans" |
| **nixgrype** | Grype scanner | "Run Grype vulnerability scans" |
| **nixsyft** | Syft SBOM generator | "Generate SBOMs with Syft" |
| **nixcosign** | Cosign signer | "Sign with Sigstore/cosign" |
| **nixfulcio** | Fulcio client | "Get certificates from Fulcio" |
| **nixrekor** | Rekor transparency log | "Query Rekor transparency log" |
| **nixgitsign** | Git commit signing | "Sign commits with Sigstore" |
| **nixkeyless** | Keyless signing | "Sign without long-lived keys" |

---

*Last updated: 2026-04-19*
