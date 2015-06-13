%%%%% Final Project Code %%%%%%

:- public secret_item/1.
:- public reveal_secret_item_on_truth/1.
/secret_item/ $body.
/secret_item/ $murder_weapon.

strategy(retract_secret_item_on_truth(location(Item, Loc)),
	if(
		(truth_value(location(Item, Loc), true), nonvar(Loc), nonvar(Item)),
				ignore(retract($global_root/secret_item/Item)),
				null)).

default_strategy(retract_secret_item_on_truth(_), null).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

