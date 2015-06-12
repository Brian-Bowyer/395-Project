character_initialization :-
   start_task(setup_satisfy_needs, 100).

strategy(setup_satisfy_needs,
	 begin(call(initialize_last_satisfied_times),
	       satisfy_needs)).

%%%
%%% Put your code below.
%%%

%%Tracing for debug purposes
%trace_task(_, satisfy_needs).
%trace_task(_, satisfy_a_need).

%%The actual need satisfaction.
strategy(satisfy_needs, begin(satisfy_a_need, satisfy_needs)).
strategy(satisfy(Need, Amount, Object, String), begin(
	goto(Object),
	say_string(String),
	increase_satisfaction(Need, Amount)
	)).

strategy(satisfy_a_need, satisfy(hunger, 100, $refrigerator, "Nom nom nom")).
strategy(satisfy_a_need, satisfy(thirst, 100, $kitchen_sink, "Glug glug glug")).
strategy(satisfy_a_need, satisfy(sleep, 100, $bed, "Zzzzzzzzz")).
strategy(satisfy_a_need, satisfy(bladder, 100, $toilet, "Ahhhhhh")).
strategy(satisfy_a_need, satisfy(hygiene, 100, $'bathroom sink', "Brush brush brush")).
strategy(satisfy_a_need, satisfy(fun, 100, $radio, "Listening to the radio")).

%%Conflict resolution
strategy(resolve_conflict(satisfy_a_need, StrategyList), ChosenStrategy) :- 
	arg_max(satisfy(Need, Delta, Object, String),
		Score,
		(member(satisfy(Need, Delta, Object, String), 
					StrategyList),
				satisfaction_level(Need, Level),
				Score is min((Level+Delta)/Level, 100 - Level))),
	ChosenStrategy = satisfy(Need, Delta, Object, String),
	log($me:ChosenStrategy).