% Keep intruders out of bedroom
%/goals/maintain/bedroom_empty.

% I know the secret location of the macguffin
/perception/location/ $macguffin : $bookshelf.
/perception/location/ $body : $bed.
/perception/location/ $murder_weapon : $kitchen_sink.

% Monitor goals quickly
/parameters/poll_time:3.

% Don't admit you know where the macguffin is to anyone
% but other illuminati members
%% pretend_truth_value(Asker,
% 		    location($macguffin, Loc),
%		    T) :-
%   \+ related(Asker, member_of, illuminati),
%   (var(Loc) -> T = unknown ; T = false).

%% FINAL PROJECT CODE %%%

lie(location($macguffin, _), location($macguffin, $refrigerator)).
lie(contained_in($macguffin, _), contained_in($macguffin, $refrigerator)).
lie(location($body, _), location($body, $refrigerator)).
lie(location($body, _), location($body, $plant)).
lie(location($murder_weapon, _), location($murder_weapon, $desk)).
lie(location($murder_weapon, _), location($murder_weapon, $bookshelf)).
lie(is_a($murder_weapon, _), is_a($murder_weapon, 'feather duster')).
lie(is_a($murder_weapon, _), is_a($murder_weapon, 'Rube-Goldeberg machine').


%% pretend_truth_value(Asker,
%% 		    contained_in($macguffin, Loc),
%% 		    T) :-
%%    \+ related(Asker, member_of, illuminati),
%%    (var(Loc) -> T = unknown ; T = false).

% Don't admit to being an illuminati member to non-members
pretend_truth_value(Asker,
		    related($me, member_of, illuminati),
		    false) :-
   \+ related(Asker, member_of, illuminati).
   
% Don't admit to knowing who's in the illuminati
pretend_truth_value(Asker,
		    related(X, member_of, illuminati),
		    unknown) :-
   var(X),
   \+ related(Asker, member_of, illuminati).

%%%%%%%%%%%%%%%%%%%%%
   
:- public bedroom_empty/0.
bedroom_empty :-
   % Kluge, but I don't have time to refactor this stuff to be nice.
   $global_root/configuration/inhibit_beat_system
   ;
   \+ intruder(_Intruder, $bedroom).

% An intruder is a person who isn't an illuminati member
intruder(Intruder, Room) :-
   location(Intruder, Room),
   is_a(Intruder, person),
   \+ related(Intruder, member_of, illuminati).

% Eat all intruders
personal_strategy(achieve(bedroom_empty),
		  ingest(Intruder)) :-
   intruder(Intruder, $bedroom).

$global::fkey_command(alt-k, "Display Kavi's status") :-
   generate_character_debug_overlay($kavi).
