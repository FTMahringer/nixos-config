{
  programs.zsh.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # ls → eza
    ls = "eza --group-directories-first";
    ll = "eza -la --group-directories-first --icons";
    la = "eza -a --group-directories-first --icons";
    l = "eza -l --group-directories-first --icons";
    lt = "eza -T --group-directories-first --icons --level=2";

    # cat → bat
    cat = "bat --paging=never";

    # Safer defaults
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    mkdir = "mkdir -pv";

    # Git
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log --oneline --graph --decorate -10";
    gd = "git diff";
    gco = "git checkout";
    gb = "git branch";

    # Docker
    d = "docker";
    dc = "docker compose";
    dps = "docker ps";

    # NixOS
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
    rebuild-test = "sudo nixos-rebuild test --flake /etc/nixos#laptop";
    update = "nix flake update --flake /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#laptop";

    # Misc
    cls = "clear";
    grep = "grep --color=auto";
  };
}
