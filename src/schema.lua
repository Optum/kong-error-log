local typedefs = require "kong.db.schema.typedefs"

return {
  name = "kong-error-log",
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { keyword = { type = "string", default = "upstream:", }, }, --Set to handle grabbing upstream related errors (L4 errors)
          { trim_on = { type = "string", default = "upstream,", }, }, --Trim error string down to drop all text after found match
        }, }, },
    },
}

