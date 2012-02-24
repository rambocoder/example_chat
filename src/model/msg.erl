-module(msg, [Id, Text]).
-compile(export_all).

after_create() ->
	{msg, _Id ,Text} = THIS,
        boss_mq:push("updates", {text, Text}).
