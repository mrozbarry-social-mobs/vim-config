lua <<EOF
require('lualine').setup({
  options = {
    theme = 'iceberg_light',
  },
  inactive_sections = {
    lualine_a = {"vim.fn.expand('%')"},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }
})
EOF
