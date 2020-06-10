local KongErrorLog = {}
local errlog = require "ngx.errlog"
local find = string.find
local sub = string.sub
local gsub = string.gsub

KongErrorLog.PRIORITY = 13
KongErrorLog.VERSION = "2.0.1"

function KongErrorLog:init_worker()
   local status, err = errlog.set_filter_level(ngx.ERR)
   if not status then
     ngx.log(ngx.ERR, err)
   end
end

function KongErrorLog:log(conf)
  
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
          if find(msg, conf.keyword) and find(msg, conf.trim_on) then --Pattern match on schema set related errors
            msg = gsub(msg, '"', '') --Strip double quotes from string so its safe for logging to json
            msg = sub(msg, 1, find(msg, conf.trim_on) + (#conf.trim_on - 2)) --Remove extraneous undesired info
            kong.ctx.shared.errmsg = msg --Set it as a shared context for other plugins to reference
            break
          end
      end
    end
  end
end

return KongErrorLog
