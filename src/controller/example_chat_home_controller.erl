-module(example_chat_home_controller, [Req]).
-compile(export_all).

index('GET', []) ->
        Timestamp = boss_mq:now("updates"),
        {ok, [{timestamp, Timestamp}]}.
        
pull('GET', [LastTimestamp]) ->
	% time out a pull after 15 seconds
	{ok, Timestamp, Objects} = boss_mq:pull("updates", list_to_integer(LastTimestamp), 15),
        {json, [{timestamp, Timestamp}, {ok, Objects}]}.
        
push('POST', []) ->
  Json = mochijson2:decode(Req:request_body()),
  % http://www.progski.net/blog/2010/destructuring_json_in_erlang_made_easy.html
  Msg = boss_record:new(msg, [
    {id, id},
    {text, json:destructure("Obj.message", Json)}
  ]),
  case Msg:save() of
    {ok, SavedMsg} ->
      {json, [{ok, SavedMsg}]};
    {error, Error} ->
      {json, [{error, [{error, Error}]}]}
  end.
        
