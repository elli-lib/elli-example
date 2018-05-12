-module(using_middleware_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    % Our middleware stack has `elli_static` before our handler so that
    % we can serve static content such as `public/hello.txt`
    {ok, Cwd} = file:get_cwd(),
    PublicDir = filename:join(Cwd, "public"),
    erlang:display(PublicDir),

    Middlewares = [
                   {elli_static, [{<<"/assets">>, {dir, PublicDir}}]},
                   {my_elli_handler, []}
                  ],

    ElliOpts = [{port, 3000},
                {callback, elli_middleware},
                {callback_args, [{mods, Middlewares}]}],

    ElliSpec = #{id => my_elli_server,
                 start => {elli, start_link, [ElliOpts]},
                 restart => permanent,
                 shutdown => 5000,
                 type => worker,
                 modules => [elli]},
    SupFlags = #{strategy => one_for_one,
                 intensity => 5,
                 period => 10},
    {ok, {SupFlags, [ElliSpec]}}.
