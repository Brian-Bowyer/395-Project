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
   heard_hearsay(ModalLF) -> Response="I've heard that." ; Response="Really?".

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

default_strategy(respond_to_contradiction(Speaker, _, ModalLF, _AdmittedTruth),
		say_string("I already know that's true.")) :-
	admitted_truth_value(Speaker, ModalLF, true),
	truth_value(ModalLF, true).

default_strategy(respond_to_contradiction(_Speaker, _, ModalLF, AdmittedTruth),
		begin(say_string("I'm convinced.")), 
			  do_hypnotically_believe(ModalLF)) :-
	truth_value(ModalLF, true).

default_strategy(respond_to_contradiction(_Speaker, _, ModalLF, _AdmittedTruth),
		say_string("That's not true.")) :-
	truth_value(ModalLF, false).

default_strategy(respond_to_contradiction(_Speaker, _, ModalLF, _AdmittedTruth),
		say_string("You don't know that's true.")) :-
	truth_value(ModalLF, unknown).

%% -----------------------------------------------------------------------------

%%default_strategy(respond_to_contradiction(Speaker, _, ModalLF, false),
%%	say_string("Claimed false but was true.")) :-
%%	truth_value(ModalLF, true).

%% default_strategy(respond_to_contradiction(Speaker, _, ModalLF, unknown),
%% 		say_string("Claimed unknown but was true.")) :-
%% 	truth_value(ModalLF, true).

%% default_strategy(respond_to_contradiction(Speaker, _, ModalLF, true),
%% 		say_string("Claimed true but was false.")) :-
%% 	truth_value(ModalLF, false).

%% default_strategy(respond_to_contradiction(Speaker, _, ModalLF, unknown),
%% 		say_string("Claimed unknown but was false.")) :-
%% 	truth_value(ModalLF, false).

%% default_strategy(respond_to_contradiction(Speaker, _, ModalLF, true),
%% 		say_string("Claimed true but was unknown")) :-
%% 	truth_value(ModalLF, unknown).

%% default_strategy(respond_to_contradiction(Speaker, _, ModalLF, false),
%% 		say_string("Claimed false but was unknown.")) :-
%% 	truth_value(ModalLF, unknown).

%% default_strategy(respond_to_contradiction(Speaker, _, ModalLF, true),
%% 		say_string("Yes, I know that's true.")) :-
%% 	truth_value(ModalLF, true).

%% default_strategy(respond_to_contradiction(Speaker, _, ModalLF, false),
%% 		say_string("Yes, I know that's false.")) :-
%% 	truth_value(ModalLF, false).

%% default_strategy(respond_to_contradiction(Speaker, _, ModalLF, unknown),
%% 		say_string("Yes, I know that's unknown.")) :-
%% 	truth_value(ModalLF, unknown).