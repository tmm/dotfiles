vim.g.colors_name = "rsms"

package.loaded["colors.palette"] = nil
package.loaded["colors.highlights"] = nil

-- Use vim.o.background, but on first load it may still be "dark" before
-- terminal detection runs. Detect from macOS directly to avoid a flash.
local bg = vim.o.background
if not vim.g._rsms_loaded then
  local handle = io.popen("defaults read -globalDomain AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    bg = result:match("Dark") and "dark" or "light"
  end
  vim.g._rsms_loaded = true
end

local palette = require("colors.palette")
local colors = palette[bg] or palette.dark

require("colors.highlights").setup(colors)
require("colors.dev")
