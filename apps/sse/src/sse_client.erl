-module(sse_client).

-export([start/0]).

start() ->
    ibrowse:start(),
    Url = "http://localhost:6000",
    Options = [{stream_to, {self(), once}}, {stream_chunk_size, 10}],
    {_, ReqId} = ibrowse:send_req(Url, [], get, [], Options),
    loop(ReqId).

loop(ReqId) ->
    ibrowse:stream_next(ReqId),
    receive
        {ibrowse_async_response, ReqIdReply, Data} when ReqIdReply =:= ReqId ->
            io:format("Received ReqId: ~p data: ~s~n", [ReqId, Data]),
            loop(ReqId);
        {ibrowse_async_response_end, ReqIdReply} when ReqIdReply =:= ReqId ->
            io:format("Event stream closed ~p ~n", [ReqId]),
            loop(ReqId);
        {ibrowse_async_headers, _, _, _} ->
            io:format("Event stream receive header ~p ~n", [ReqId]),
            loop(ReqId);
        Other ->
            io:format("Received unexpected message: ~p~n", [Other]),
            loop(ReqId)
    end.
