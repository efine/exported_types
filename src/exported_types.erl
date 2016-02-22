-module(exported_types).

-export([
          main/1
    ]).

%%====================================================================
%% API
%%====================================================================
-spec main(Args) -> no_return() when Args :: [string()].
main(Args) ->
    PgmName = filename:basename(escript:script_name()),
    halt(exported_types_main:main(PgmName, Args)).

%% ex: ft=erlang ts=4 sts=4 sw=4 et
