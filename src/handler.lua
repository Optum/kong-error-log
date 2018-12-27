local BasePlugin = require "kong.plugins.base_plugin"
local KongErrorLog = BasePlugin:extend()
local errlog = require "ngx.errlog"

KongErrorLog.PRIORITY = 13
KongErrorLog.VERSION = "0.1.0"

function KongErrorLog:new(name)
  name = name or "kong-error-log"
  KongErrorLog.super.new(self, name)
  self.ngx_log = ngx.log
  self.name = name
end

function KongErrorLog:init_worker()
  KongErrorLog.super.init_worker(self)
   local status, err = errlog.set_filter_level(ngx.ERR)
   if not status then
     ngx.log(ngx.ERR, err)
   end
end

function KongErrorLog:log(conf)
  KongErrorLog.super.log(self)
  
  --Ensure we are dealing with an error scenario
  if 500 <= kong.response.get_status() then
    --Get all err messages from global buffer during the tx, get_logs() clears them from the buffer upon success.
    local res, err = errlog.get_logs()
    if not res then
      ngx.log(ngx.ERR, err)
    end

    if res then
      for i = 1, #res, 3 do
          local msg  = res[i + 2] -- res[i + 2] gives us the data of the error.
          if string.find(msg, conf.keyword) then --Pattern match on schema set related errors
            msg = msg:gsub('"','') --Strip double quotes from string so its safe for logging to json
            if conf.trim_on ~= "" then
              msg = msg:sub(1, msg:find(conf.trim_on) + (#conf.trim_on - 2)) --Remove extraneous undesired info
            end
            kong.ctx.shared.errmsg = msg --Set it as a shared context for other plugins to reference
            break
          end
      end
    end
  end
end

return KongErrorLog