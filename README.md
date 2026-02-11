# tree-sitter-ssl

A [tree-sitter](https://tree-sitter.github.io/) grammar for **SSL** (Star-Trek Scripting Language), the scripting language used by Fallout 1/2 and [sfall](https://github.com/sfall-team/sfall).

## Features

- Full parsing of SSL syntax: procedures, variables, control flow, expressions
- Syntax highlighting queries
- Local variable scoping queries
- Language bindings for C, Go, Node.js, Python, Rust, and Swift

## Neovim

This repository can be used directly as a Neovim plugin. Add it with your plugin manager (e.g. [lazy.nvim](https://github.com/folke/lazy.nvim)):

```lua
{
  "Urbs97/tree-sitter-ssl",
  config = function()
    ---@type table
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.ssl = {
      install_info = {
        url = "https://github.com/Urbs97/tree-sitter-ssl",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "ssl",
    }
  end,
  build = function()
    vim.cmd("TSInstall ssl")
  end,
}
```

Highlighting and filetype detection are included automatically.

## Development

```sh
npm install
npx tree-sitter generate
npx tree-sitter test
```

## License

[MIT](LICENSE)
