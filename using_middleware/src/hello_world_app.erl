-module(hello_world_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    hello_world_sup:start_link().

stop(_State) ->
    ok.
