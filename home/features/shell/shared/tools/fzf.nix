{
  programs.fzf = {
    enable = true;

    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];

    # Ctrl+T: file search with bat preview
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || cat {}'"
    ];

    # Ctrl+R: history search
    historyWidgetOptions = [
      "--sort"
      "--exact"
    ];

    # Alt+C: directory search with eza preview
    changeDirWidgetOptions = [
      "--preview 'eza --tree --level=1 --color=always --icons {} 2>/dev/null'"
    ];
  };
}
