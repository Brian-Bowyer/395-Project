%%
%% Responding to assertions
%%

strategy(respond_to_dialog_act(assertion(Speaker,_, LF, Tense, Aspect)),
	 respond_to_assertion(Speaker, Modalized, Truth)) :-
   modalized(LF, Tense, Aspect, Modalized),
   admitted_truth_value(Speaker, Modalized, Truth).

default_strategy(respond_to_assertion(_Speaker, _ModalLF, true),
	 say_string("Yes, I know.")).
default_strategy(respond_to_assertion(_Speaker, _ModalLF, false),
	 say_string("I don't think so.")).
default_strategy(respond_to_assertion(Speaker, ModalLF, unknown),
	 (say_string(Response), assert(/hearsay/Speaker/ModalLF))) :-
   heard_hearsay(ModalLF) -> Response="I've head that." ; Response="Really?".

heard_hearsay(ModalLF) :-
   /hearsay/_/Assertion, Assertion=ModalLF.

strategy(respond_to_dialog_act(question_answer(Speaker,_, LF)),
	 assert(/hearsay/Speaker/LF)).


%%
%% Kluges to keep characters from inappropriately contradicting other characters answers
%%

be(X,X).
be(Character, Name) :-
   property_value(Character, given_name, Name).

strategy(respond_to_assertion(Speaker, okay(Speaker), _),
	 null).

%%
%% Contradictions
%%

strategy(respond_to_dialog_act(contradiction(Speaker, Listener, LF, Tense, Aspect)), 
		respond_to_contradiction(Speaker, Listener, Modalized, Truth)) :-
   modalized(LF, Tense, Aspect, Modalized),
   admitted_truth_value(Speaker, Modalized, Truth).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, true),
		say_string("Claimed false but was true.")) :-
	admitted_truth_value(Listener, ModalLF, false),
	truth_value(ModalLF, true).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, true),
		say_string("Claimed unknown but was true.")) :-
	admitted_truth_value(Listener, ModalLF, unknown),
	truth_value(ModalLF, true).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, false),
		say_string("Claimed true but was false.")) :-
	admitted_truth_value(Listener, ModalLF, true),
	truth_value(ModalLF, false).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, false),
		say_string("Claimed unknown but was false.")) :-
	admitted_truth_value(Listener, ModalLF, unknown),
	truth_value(ModalLF, false).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, unknown),
		say_string("Claimed true but was unknown")) :-
	admitted_truth_value(Listener, ModalLF, true),
	truth_value(ModalLF, unknown).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, unknown),
		say_string("Claimed false but was unknown")) :-
	admitted_truth_value(Listener, ModalLF, false),
	truth_value(ModalLF, unknown).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, true),
		say_string("Yes, I know that's true.")) :-
	admitted_truth_value(Listener, ModalLF, true),
	truth_value(ModalLF, true).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, false),
		say_string("Yes, I know that's false.")) :-
	admitted_truth_value(Listener, ModalLF, false),
	truth_value(ModalLF, false).

default_strategy(respond_to_contradiction(Speaker, Listener, ModalLF, unknown),
		say_string("Yes, I know that's unknown.")) :-
	admitted_truth_value(Listener, ModalLF, unknown),
	truth_value(ModalLF, unknown).