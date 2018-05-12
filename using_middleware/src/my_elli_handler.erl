-module(my_elli_handler).
-export([handle/2, handle_event/3]).

-behaviour(elli_handler).

handle(Req, _Args) ->
    %% Delegate to our handler function
    handle(elli_request:method(Req), elli_request:path(Req), Req).

%% Return 200 to GET requests to /hello/world
handle('GET',[<<"hello">>, <<"world">>], _Req) ->
    {200, [], <<"Hello World!">>};

%% Return 404 to any other requests
handle(_, _, _Req) ->
    {404, [], <<"Not Found">>}.

%% Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return `ok'.
handle_event(_Event, _Data, _Args) ->
    ok.
