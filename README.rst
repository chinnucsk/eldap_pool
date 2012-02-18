####################
eldap_pool
####################

::

  application:start(eldap_pool).
  ...

::

  case eldap_pool:simple_bind(Dn, Passwd) of
    ok ->
      ...
    Error ->
      ...
  end.
