local api = vim.api
local fn = vim.fn
local lsp = vim.lsp

local eq = assert.are.same

local base_capabilities = lsp.protocol.make_client_capabilities()

-- Base asserts that are all expected to be true when starting from nothing.
local function base_asserts(valid_config)
  -- It can't find something with root patterns, so it defaults to the cwd
  eq(valid_config.root_dir, fn.getcwd())
  -- Since the path to metals will be different per machine, for this we just
  -- ensure that the cmd is actually getting set
  eq(#valid_config.cmd, 1)
  eq(valid_config.capabilities, base_capabilities)
  eq(valid_config.settings, { metals = { superMethodLensesEnabled = true } })
  eq(valid_config.filetypes, { "sbt", "scala" })
  eq(valid_config.init_options, require("metals.config").metals_init_options)
end

describe("config", function()
  local current_buf = api.nvim_get_current_buf()
  local config = require("metals.config")
  before_each(function()
    config = require("metals.config")
  end)
  it("should handle an empty table", function()
    local valid_config = config.validate_config({}, current_buf)
    base_asserts(valid_config)
  end)
  it("should handle a bare config", function()
    local bare_config = require("metals.setup").bare_config

    local valid_config = config.validate_config(bare_config, current_buf)
    base_asserts(valid_config)
  end)
end)