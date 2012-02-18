-module(eldap_pool_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  eldap_pool_sup:start_link().

stop(_State) ->
    ok.
