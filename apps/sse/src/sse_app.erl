%%%-------------------------------------------------------------------
%% @doc sse public API
%% @end
%%%-------------------------------------------------------------------

-module(sse_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [{"/", sse_handler, []}]}
    ]),
    {ok, _} = cowboy:start_clear(sse_listener,
        [{port, 6000}],
        #{env => #{dispatch => Dispatch}}
    ),
    sse_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
