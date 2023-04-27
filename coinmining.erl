-module(coinmining).
-import(string, [to_lower/1]).
-import(string, [sub_string/3]).
-export([
    initiate_server/0,
    mainServer/1,
    creatingCoin/1,
    finder/1,
    making_worker/2,
    generate_slaves/2,
    miner/2
]).

%Getting random string
generate_string(Length, RequiredStringChar) ->
    lists:foldl(
        fun(_, Acc) ->
            [
                lists:nth(
                    rand:uniform(length(RequiredStringChar)),
                    RequiredStringChar
                )
            ] ++
                Acc
        end,
        [],
        lists:seq(1, Length)
    ).

numberOfZeros(0) -> "";
numberOfZeros(N) -> "0" ++ numberOfZeros(N - 1).
%Generating bitcoins
creatingCoin(K) ->
    receive
        {mine, From, SNode} ->
            StringId =
                "lokeshmeesala;" ++
                    generate_string(
                        200,
                        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789;!@#$%^&*()+-_="
                    ),
            StringHash = to_lower(
                integer_to_list(binary:decode_unsigned(crypto:hash(sha256, StringId)), 16)
            ),
            HashingLen = string:len(StringHash),
            if
                HashingLen =< (64 - K) ->
                    io:format("Hurray!! we found a coin! ~n"),
                    client ! got,
                    {From, SNode} ! {got_coin, {StringId, numberOfZeros(K) ++ StringHash}};
                true ->
                    spawn(coinmining, creatingCoin, [K]) ! {mine, From, SNode}
            end
    end.
%server function for starting the server
mainServer(K) ->
    receive
        %hello ->
        %io:format("someonesays Hello~n");
        {i_am_worker, WorkerPid} ->
            io:format("--------------------------------------------------~n"),
            io:format("main-Server got a Worker~n"),
            io:format("--------------------------------------------------~n"),
            io:format("Worker Node ~p ~n", [WorkerPid]),
            WorkerPid ! hello;
        {got_coin, {Coin, StringHash}} ->
            io:format("--------------------------------------------------~n"),
            io:format("Coin : StringHash ---> ~p  :  ~p~n", [Coin, StringHash]),
            io:format("--------------------------------------------------~n");
        {mine, WPid} ->
            WPid ! {zcount, K};
        {time, Time_for_CPU, REAL_Time, RATIO} ->
            io:format("-------------------------------------------------------~n"),
            io:format("CPU TIME : ~p REAL TIME : ~p RATIO : ~p", [Time_for_CPU, REAL_Time, RATIO]);
        terminate ->
            exit("Out")
    end,
    mainServer(K).
%Worker nodes are the ones which starts mining the coins
finder(SNode) ->
    {serverPid, SNode} ! {mine, self()},
    receive
        {zcount, K} ->
            spawn(coinmining, creatingCoin, [K]) ! {mine, serverPid, SNode}
    end.

generate_slaves(1, SNode) ->
    spawn(coinmining, finder, [SNode]);
generate_slaves(N, SNode) ->
    spawn(coinmining, finder, [SNode]),
    generate_slaves(N - 1, SNode).

miner(S, C) ->
    register(client, spawn(coinmining, making_worker, [S, C])).

making_worker(SNode, C) ->
    {_, _} = statistics(runtime),
    {_, _} = statistics(wall_clock),
    io:format("Generating a Worker~n"),
    %{ok, C} = io:read("Enter a number: "),
    generate_slaves(C, SNode),
    listen(1, C, SNode).

listen(N, C, SNode) ->
    receive
        got ->
            io:format("B : ~p", [N]),
            if
                N == C ->
                    {_, Time_for_CPU} = statistics(runtime),
                    {_, REAL_Time} = statistics(wall_clock),
                    {serverPid, SNode} ! {time, Time_for_CPU, REAL_Time, Time_for_CPU / REAL_Time};
                true ->
                    listen(N + 1, C, SNode)
            end
    end.
%function for starting the server
initiate_server() ->
    {ok, K} = io:read("Give the input for the number of zeroes needed: "),
    io:format("-------------------------------------------------~n"),
    io:format("Number of Zeroes given by you : ~p~n", [K]),
    io:format("--------------------------------------------------~n"),
    register(serverPid, spawn(coinmining, mainServer, [K])),
    {_, _} = statistics(runtime),
    {_, _} = statistics(wall_clock).
