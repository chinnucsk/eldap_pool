-module(eldap_pool).

-export([simple_bind/2]).

-define(DEFAULT_POOL, defautl_eldap_pool).

-type dn() :: binary().
-type passwd() :: binary().

%% TODO: timeout process
-spec simple_bind(dn(), passwd()) -> ok | {error, term()}.
simple_bind(Dn, Passwd) ->
  Worker = poolboy:checkout(?DEFAULT_POOL),
  Reply = gen_server:call(Worker, {simple_bind, Dn, Passwd}),
  poolboy:checkin(?DEFAULT_POOL, Worker),
  Reply.

-ifdef(TEST).
-endif.
