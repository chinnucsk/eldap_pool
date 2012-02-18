-module(eldap_pool_worker).

-behaviour(gen_server).

-export([start_link/1]).

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {handle}).

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

init(Args) ->
  process_flag(trap_exit, true),
  Hostname = proplists:get_value(hostname, Args),
  %% Port = proplists:get_value(port, Args),
  %% Timeout = proplists:get_value(timeout, Args),
  case eldap:open([Hostname], []) of
    {ok, Handle} ->
      {ok, #state{handle=Handle}};
    {error, Reason} ->
      {stop, Reason}
  end.

handle_call({simple_bind, Dn, Passwd}, _From, #state{handle = Handle}=State) ->
  {reply, eldap:simple_bind(Handle, Dn, Passwd), State};
handle_call(_Request, _From, State) ->
  {noreply, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info({'EXIT', _, _}, State) ->
  {stop, shutdown, State};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, State) ->
  eldap:close(State#state.handle),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
