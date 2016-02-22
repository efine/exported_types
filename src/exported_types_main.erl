-module(exported_types_main).

-export([
          main/2
    ]).

-define(RC_SUCCESS, (0)).
-define(RC_ERROR,   (1)).

%%====================================================================
%% API
%%====================================================================
-spec main(ScriptName, Args) -> integer() when
      ScriptName :: string(),
      Args :: [string()].
main(ScriptName, []) ->
    usage(ScriptName);
main(_, [Arg0|_] = Args) when is_list(Arg0) ->
    {module, _} = code:ensure_loaded(beamish),
    try
        _ = [list_types(beamish:exported_types(F)) || F <- Args],
        ?RC_SUCCESS
    catch
        _: Reason ->
            msg("***** ERROR: ~p~n~p~n", [Reason, erlang:get_stacktrace()]),
            ?RC_ERROR
    end.

list_types({ok, {_Mod, []}}) ->
    ok;
list_types({ok, {Mod, Types}}) ->
    io:format("~w\t~s~n", [Mod, fmt_types(Types)]);
list_types({error, beam_lib, _Reason} = BeamErr) ->
     io:put_chars("ERROR: " ++ beam_lib:format_error(BeamErr));
list_types({error, Reason}) ->
    io:format("ERROR: ~p~n", [Reason]).

fmt_types(Types) ->
    string:join([fmt_type(Type) || Type <- Types], " ").

fmt_type({Name, Arity}) ->
    [atom_to_list(Name), $/, integer_to_list(Arity)].

usage(ScriptName) ->
    msg("usage: ~s beam-file [beam-file...]~n", [ScriptName]),
    ?RC_ERROR.

msg(Fmt, Args) ->
    io:format(standard_error, Fmt, Args).


%% ex: ft=erlang ts=4 sts=4 sw=4 et

