local M = {}

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], enabled?:fun():boolean}
---@alias LazyKeysLsp LazyKeys|{has?:string|string[], enabled?:fun():boolean}

---@param filter vim.lsp.get_clients.Filter
---@param spec LazyKeysLspSpec[]
function M.set(filter, spec)
  local Keys = require("lazy.core.handler.keys")
  for _, keys in pairs(Keys.resolve(spec)) do
    ---@cast keys LazyKeysLsp
    local filters = {} ---@type vim.lsp.get_clients.Filter[]
    if keys.has then
      local methods = type(keys.has) == "string" and { keys.has } or keys.has --[[@as string[] ]]
      for _, method in ipairs(methods) do
        method = method:find("/") and method or ("textDocument/" .. method)
        filters[#filters + 1] = vim.tbl_extend("force", vim.deepcopy(filter), { method = method })
      end
    else
      filters[#filters + 1] = filter
    end

    for _, f in ipairs(filters) do
      local opts = Keys.opts(keys)
      ---@cast opts snacks.keymap.set.Opts
      opts.lsp = f
      opts.enabled = keys.enabled
      require("snacks").keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
