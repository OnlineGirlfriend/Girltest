//**************
//*****Keys*****
//**************
/obj/item/keycard
	name = "security keycard"
	desc = "This feels like it belongs to a door."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "keycard"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 7
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/puzzle_id = null

//Two test keys for use alongside the two test doors.
/obj/item/keycard/cheese
	name = "cheese keycard"
	desc = "Look, I still don't understand the reference. What the heck is a keyzza?"
	color = "#f0da12"
	puzzle_id = "cheese"

/obj/item/keycard/swordfish
	name = "titanic keycard"
	desc = "Smells like it was at the bottom of a harbor."
	color = "#3bbbdb"
	puzzle_id = "swordfish"

/obj/item/keycard/harmfactory
	name = "factory keycard"
	desc = "A keycard opening a door within the world's worst factory"
	color = "#727a7c"
	puzzle_id = "factory"

/obj/item/keycard/harmfactory/stockroom
	name = "stockroom keycard"
	desc = "A keycard opening a door within the world's worst factory"
	color = "#cf2323"
	puzzle_id = "stockroom"

/obj/item/keycard/harmfactory/office
	name = "office keycard"
	desc = "A keycard opening a door within the world's worst factory"
	color = "#1dac22"
	puzzle_id = "office"

/obj/item/keycard/harmfactory/entry
	name = "entry keycard"
	desc = "A keycard opening a door within the world's worst factory"
	color = "#1a27e7"
	puzzle_id = "entry"



/obj/item/keycard/gatedrop
	icon_state = "golden_key"

/obj/item/keycard/gatedrop/lavacanyon
	name = "Vault Key"
	desc = "A dusty key, smudged with dried blood."
	puzzle_id = "lavacanyonkey"

//***************
//*****Doors*****
//***************

/obj/machinery/door/keycard
	name = "locked door"
	desc = "This door only opens when a keycard is swiped. It looks virtually indestructable."
	icon = 'icons/obj/doors/doorpuzzle.dmi'
	icon_state = "door_closed"
	explosion_block = 3
	heat_proof = TRUE
	max_integrity = 600
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	damage_deflection = 70
	var/puzzle_id = null	//Make sure that the key has the same puzzle_id as the keycard door!

//Standard Expressions to make keycard doors basically un-cheeseable
/obj/machinery/door/keycard/Bumped(atom/movable/AM)
	return !density && ..()

/obj/machinery/door/keycard/emp_act(severity)
	return

/obj/machinery/door/keycard/ex_act(severity, target)
	return

/obj/machinery/door/keycard/try_to_activate_door(mob/user)
	add_fingerprint(user)
	if(operating)
		return

/obj/machinery/door/keycard/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I,/obj/item/keycard))
		var/obj/item/keycard/key = I
		if((!puzzle_id || puzzle_id == key.puzzle_id)  && density)
			to_chat(user, span_notice("The door rattles, and slides opens."))
			open()
			return
		else if(puzzle_id != key.puzzle_id)
			to_chat(user, span_notice("[src] shakes. This must not be the right key."))
			return
		else
			to_chat(user, span_notice("This door doesn't appear to close."))
			return

//Test doors. Gives admins a few doors to use quickly should they so choose.
/obj/machinery/door/keycard/cheese
	name = "blue airlock"
	desc = "Smells like... pizza?"
	puzzle_id = "cheese"

/obj/machinery/door/keycard/swordfish
	name = "blue airlock"
	desc = "If nautical nonsense be something you wish."
	puzzle_id = "swordfish"

/obj/machinery/door/keycard/harmfactory
	name = "keycard locked door"
	desc = "Seems to have a scanner for the factory keycard"
	puzzle_id = "factory"

/obj/machinery/door/keycard/harmfactory/stockroom
	name = "keycard locked door"
	desc = "Seems to have a scanner for the stockroom keycard"
	puzzle_id = "stockroom"

/obj/machinery/door/keycard/harmfactory/office
	name = "keycard locked door"
	desc = "Seems to have a scanner for the office keycard"
	puzzle_id = "office"

/obj/machinery/door/keycard/harmfactory/entry
	name = "keycard locked door"
	desc = "Seems to have a scanner for the entry keycard"
	puzzle_id = "entry"

/obj/machinery/door/keycard/gates
	gender = PLURAL
	name = "locked gates"
	desc = "A gate made out of hard metal. Opens with a key."
	icon = 'icons/obj/doors/gates.dmi'
	icon_state = "closed"
	layer = BLASTDOOR_LAYER
	closingLayer = BLASTDOOR_LAYER
	var/open_sound = 'sound/machines/airlocks/gate.ogg'
	var/close_sound = 'sound/machines/airlocks/gate.ogg'
	glass = TRUE
	opacity = FALSE
	move_resist = MOVE_FORCE_OVERPOWERING

/obj/machinery/door/keycard/gates/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
			playsound(src, open_sound, 30, FALSE)
		if("closing")
			flick("closing", src)
			playsound(src, close_sound, 30, FALSE)

/obj/machinery/door/keycard/gates/update_icon_state()
	. = ..()
	icon_state = density ? "closed" : "open"

/obj/machinery/door/keycard/gates/lavacanyon
	puzzle_id = "lavacanyonkey"

//*************************
//***Box Pushing Puzzles***
//*************************
//We're working off a subtype of pressureplates, which should work just a BIT better now.
/obj/structure/holobox
	name = "holobox"
	desc = "A hard-light box, containing a secure decryption key."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "laserbox"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF

//Uses the pressure_plate settings for a pretty basic custom pattern that waits for a specific item to trigger. Easy enough to retool for mapping purposes or subtypes.
/obj/item/pressure_plate/hologrid
	name = "hologrid"
	desc = "A high power, electronic input port for a holobox, which can unlock the hologrid's storage compartment. Safe to stand on."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "lasergrid"
	anchored = TRUE
	trigger_mob = FALSE
	trigger_item = TRUE
	specific_item = /obj/structure/holobox
	removable_signaller = FALSE //Being a pressure plate subtype, this can also use signals.
	roundstart_signaller_freq = FREQ_HOLOGRID_SOLUTION //Frequency is kept on it's own default channel however.
	active = TRUE
	trigger_delay = 10
	protected = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/reward = /obj/item/reagent_containers/food/snacks/cookie
	var/claimed = FALSE

/obj/item/pressure_plate/hologrid/Initialize()
	. = ..()

	AddElement(/datum/element/undertile, tile_overlay = tile_overlay) //we remove use_anchor here, so it ALWAYS stays anchored

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/pressure_plate/hologrid/examine(mob/user)
	. = ..()
	if(claimed)
		. += span_notice("This one appears to be spent already.")

/obj/item/pressure_plate/hologrid/trigger()
	if(!claimed)
		new reward(loc)
	flick("lasergrid_a",src)
	icon_state = "lasergrid_full"
	claimed = TRUE

/obj/item/pressure_plate/hologrid/on_entered(datum/source, atom/movable/AM)
	if(trigger_item && istype(AM, specific_item) && !claimed)
		AM.set_anchored(TRUE)
		flick("laserbox_burn", AM)
		trigger()
		QDEL_IN(AM, 15)
