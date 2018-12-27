return {
  no_consumer = true,
  fields = {
     keyword = {type = "string", default = "upstream:"}, --Set to handle grabbing upstream related errors (L4 errors)
     trim_on = {type = "string", default = "upstream,"}, --Trim error string down to drop all text after found match
  }
}