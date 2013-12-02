local code = ngx.status
-- Mark the backend as dead only for 5xx errors
if not (ngx.status >= 501 and ngx.status ~= 503) then
    return
end
local frontend = ngx.var.frontend
if #frontend == 0 then
    return
end
-- Put the dead backends in a shared dict (we cannot call Redis from here)
local deads = ngx.shared.deads
deads:add(ngx.var.backend , ngx.var.frontend)
