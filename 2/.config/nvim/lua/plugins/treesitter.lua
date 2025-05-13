return {
  'nvim-treesitter/nvim-treesitter',
  -- Lazy-load Tree-sitter for specific filetypes (adjust to your preferences)
  ft = {'python', 'lua', 'javascript', 'go', 'html', 'css', 'typescript', 'rust'},

  config = function()
    -- Tree-sitter configuration
    require('nvim-treesitter.configs').setup {
      -- Automatically install parsers for maintained languages
      ensure_installed = "maintained",

      -- Enable Tree-sitter syntax highlighting
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false -- Disable Vim's regex-based highlighting
      },

      -- Enable incremental selection with Tree-sitter
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn", -- Start incremental selection
          node_incremental = "grn", -- Increment to next node
          node_decremental = "grm", -- Decrement to previous node
          scope_incremental = "grc" -- Increment to next scope
        }
      },

      -- Enable automatic indentation based on Tree-sitter
      indent = {
        enable = true
      },

      -- Enable context-aware folding (if desired)
      fold = {
        enable = true
        -- folding based on Tree-sitter
      }
    }
  end
}

