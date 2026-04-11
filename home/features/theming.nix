{
  # Home-manager level Stylix target overrides.
  #
  # Stylix autoEnable = true (set in the system module) means every
  # supported HM target is themed automatically.  We only need to
  # opt-out for apps that manage their own theme.

  stylix.targets = {
    # NVF (Nix Vim Framework) manages Neovim theming independently.
    # Enabling Stylix's neovim target alongside NVF can cause conflicts.
    # To let Stylix theme Neovim instead, set this to true and remove
    # the `theme` block from home/features/nvim/settings.nix.
    neovim.enable = false;
    vim.enable = false;
  };
}
