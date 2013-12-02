Hipache-Nginx (experimental)
============================

This projects is an experimental port of [Hipache](https://github.com/dotcloud/hipache)
to nginx using the [Lua module](https://github.com/chaoslawful/lua-nginx-module).

The project only consists of configuration files for now but it will
evolve into a ready-to-use scalable proxy solution.

1. Nginx requires the LUA module: [installation instructions](http://wiki.nginx.org/HttpLuaModule#Installation)
2. You have to install the [lua-redis client](https://github.com/agentzh/lua-resty-redis).


Health-checks
-------------

For now [Hipache-hchecker](https://github.com/samalba/hipache-hchecker/) is not working because
[Radix](https://github.com/fzzy/radix) has removed pubsub support.

Because of this I have changed the way Hipache-Nginx dealed with dead backends, instead of announcing 
it they are marked as dead until a better solution is implemented.

Keep in mind that until better solution is found dead backends will not be marked as alive again.

TODO
-------------
- emulate proxy_next_upstream behaviour in lua using location.capture
- statistics panel
- test websockets support
- better health-check handling
