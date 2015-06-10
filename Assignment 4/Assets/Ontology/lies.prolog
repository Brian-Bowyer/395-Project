:- external lie/2.
:- public retract_lie/2.

%% FINAL PROJECT CODE %%
can_lie(X) :-
lie(X,_).

%% retract_lie(+Truth, +Lie).
retract_lie(X, Y) :- retract(lie(X,Y)).

pretend_truth_value(_, P, Truth) :-
	can_lie(P), !,
	(lie(P,P) -> 
		Truth = true;
		Truth = false).



%%%%%%%%%%%%%%%%%%%%%%%%%%