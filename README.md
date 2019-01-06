# Kong Error Log Plugin
## Overview
  This plugin will expose the nginx webserver error logs to a field "kong.ctx.shared.errmsg" that other Kong plugins can consume.
  
  Our use case was simple, we wanted to log the L4 errors NGINX was throwing around problems proxying to backend API services. Hence the observable defaults in our plugin schema that target and trim upstream related NGINX errors.
   
  To leverage this plugin, you will need to define a shm in your nginx conf:
  ```lua_capture_error_log 100k;``` 
  
  Example Error Log Highlighted:

  ![Error Sample](https://github.com/Optum/kong-error-log/blob/master/NginxUpstreamErrorMsg.png)
  
## Supported Kong Releases
Kong >= 0.14.1

## Installation
Recommended:
```
$ luarocks install kong-error-log
```
Other:
```
$ git clone https://github.com/Optum/kong-error-log.git /path/to/kong/plugins/kong-error-log
$ cd /path/to/kong/plugins/kong-error-log
$ luarocks make *.rockspec
```
## Maintainers
[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to open issues, or refer to our [Contribution Guidelines](https://github.com/Optum/kong-error-log/blob/master/CONTRIBUTING.md) if you have any questions.
