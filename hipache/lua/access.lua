-- Extract needed information from the hostname
local from, to = ngx.re.find(ngx.var.http_host, ".:([0-9]{1,5})", "jo")
if from then
    frontend = string.sub(ngx.var.http_host, 0, from)
else
    if err then
        ngx.log(ngx.ERR,"error: ", err)
        return
    end
    frontend = ngx.var.http_host
end

-- Connect to Redis
local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000)
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.log(ngx.ERR,"Failed to connect to Redis: ", err)
    return
end

-- Announce dead backends if there is any
local deads = ngx.shared.deads
for i, v in ipairs(deads:get_keys()) do
    local ans, err = red:sadd("dead:" .. deads:get(v), v)
    if ans then
	deads:delete(v)
    end
end

-- Redis lookup and dead announcement
local backends, err = red:sdiff("frontend:" .. frontend, "dead:" .. frontend)
if not backends then
    ngx.log(ngx.ERR,"Lookup failed: ", err)
    return
end

local backend = backends[math.random(1, #backends)]

-- Set the connection pool (to avoid connect/close everytime)
local ok, err = red:set_keepalive(0, 100)

-- Export variables
ngx.var.backend = backend
ngx.var.backends_len = #backends
ngx.var.frontend = frontend
ngx.var.vhost = ngx.var.http_host
