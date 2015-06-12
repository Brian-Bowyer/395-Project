:- external lie/2.
:- public retract_lie/2.

~location(X,Y) :- \+ location(X,Y). %because apparently this was never defined and I spent 2 hours trying to figure out if ~ was a built-in predicate... lolz.

%% FINAL PROJECT CODE %%
can_lie(X) :-
lie(X,_).

%% retract_lie(+LF) removes any lie which contradicts the LF given
retract_lie(not(LF)) :-
  !, % don't try the next case
	forall(lie(X,LF), 
		tracereturn(retract(lie(X,LF)))).

retract_lie(LF) :- 
	forall(lie(LF,Y),
		(Y \== LF -> retract(lie(LF, Y)); fail)).

pretend_truth_value(Listener, ~P, Truth) :-
	pretend_truth_value(Listener,P,InvTruth),
	invert_truth_value(InvTruth, Truth).

pretend_truth_value(Listener, P, Truth) :-
	Listener \== $me,
	can_lie(P), !,
	(lie(P,P) -> 
		Truth = true;
		Truth = false).

tracereturn(X) :-
trace, (X -> notrace; (notrace, fail)).

lie(contained_in(X,_), contained_in(X,Container)) :- lie(location(X,_), location(X, Loc)), (Loc = Container; contained_in(Loc, Container)). %% Why does this work here but not in "lies.prolog".

%%%%%%%%%%%%%%%%%%%%%%%%%%