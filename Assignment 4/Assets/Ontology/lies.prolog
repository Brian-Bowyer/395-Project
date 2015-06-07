:- external lie/2.
:- public retract_lie/2.

%% FINAL PROJECT CODE %%
can_lie(X) :-
lie(X,_).

%% retract_lie(+Truth, +Lie).
retract_lie(X, Y) :- retract(lie(X,Y)).

%%%%%%%%%%%%%%%%%%%%%%%%%%