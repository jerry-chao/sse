%%%-------------------------------------------------------------------
%% @doc sse public API
%% @end
%%%-------------------------------------------------------------------

-module(sse_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    sse_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
