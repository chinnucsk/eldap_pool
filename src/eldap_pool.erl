-module(eldap_pool).

-export([start/1]).

-export([simple_bind/2]).

-define(DEFAULT_POOL, defautl_eldap_pool).

-type dn() :: binary().
-type passwd() :: binary().

-spec start(binary()) -> ok.
start(Hostname) ->
  ok = application:start(eldap_pool),
  Args = [{name, {local, ?DEFAULT_POOL}},
          {worker_module, eldap_pool_worker},
          {hostname, Hostname}],
  Spec = {?DEFAULT_POOL, {poolboy, start_link, [Args]},
          permanent, 5000, worker, [poolboy]},
  {ok, _Pid} = supervisor:start_child(eldap_pool_sup, Spec).

%% TODO: timeout process
-spec simple_bind(dn(), passwd()) -> ok | {error, term()}.
simple_bind(Dn, Passwd) ->
  Worker = poolboy:checkout(?DEFAULT_POOL),
  Reply = gen_server:call(Worker, {simple_bind, Dn, Passwd}),
  poolboy:checkin(?DEFAULT_POOL, Worker),
  Reply.

-ifdef(TEST).
-endif.
