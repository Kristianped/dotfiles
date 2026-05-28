---@module 'lazy'

return {
  {
    "ahmedkhalf/project.nvim",
    optional = true,
    opts = {
      manual_mode = false,
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      open_files_do_not_replace_types = { "edgy" },
    },
  },
  {
    "snacks.nvim",
    optional = true,
    ---@type snacks.Config
    opts = {
      picker = {
        sources = {
          projects = {
            patterns = { ".git", ".svn", "package.json", "Makefile" },
            dev = {
              "~/workspace/brreg_projects",
              "~/projects/konkurs_projects",
            },
          },
        },
      },
    },
  },
}
