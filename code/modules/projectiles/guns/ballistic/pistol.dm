/obj/item/gun/ballistic/automatic/pistol
	bolt_type = BOLT_TYPE_LOCKING
	w_class = WEIGHT_CLASS_NORMAL

	vary_fire_sound = FALSE
	fire_sound_volume = 90
	bolt_wording = "slide"
	weapon_weight = WEAPON_LIGHT
	pickup_sound =  'sound/items/handling/gun_pickup.ogg'

	//recoil = 0.5 // apogee wants bloom, this is a placeholder until then to simulate the same concept. //UPDATE ive changed my mind on this, however i would
	recoil_unwielded = 3
	recoil_backtime_multiplier = 1

	zoom_amt = PISTOL_ZOOM

	wield_delay = 0.2 SECONDS
	fire_delay = 0.2 SECONDS
	spread = 5
	spread_unwielded = 7

	wield_slowdown = PISTOL_SLOWDOWN
	aimed_wield_slowdown = PISTOL_AIM_SLOWDOWN

	muzzleflash_iconstate = "muzzle_flash_light"
	light_range = 1

	refused_attachments = list(
		/obj/item/attachment/gun,
		/obj/item/attachment/sling
		)


/obj/item/gun/ballistic/automatic/pistol/candor
	name = "\improper Candor"
	desc = "A classic semi-automatic handgun, widely popular throughout the Frontier. An engraving on the slide marks it as a product of Hunter's Pride. Chambered in .45."
	icon_state = "candor"
	item_state = "hp_generic"
	icon = 'icons/obj/guns/manufacturer/hunterspride/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/hunterspride/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/hunterspride/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/hunterspride/onmob.dmi'

	default_ammo_type = /obj/item/ammo_box/magazine/m45
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/m45,
	)
	fire_sound = 'sound/weapons/gun/pistol/candor.ogg'
	rack_sound = 'sound/weapons/gun/pistol/candor_cocked.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/slide_lock.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/candor_cocked.ogg'
	manufacturer = MANUFACTURER_HUNTERSPRIDE
	load_sound = 'sound/weapons/gun/pistol/candor_reload.ogg'
	load_empty_sound = 'sound/weapons/gun/pistol/candor_reload.ogg'
	eject_sound = 'sound/weapons/gun/pistol/candor_unload.ogg'
	eject_empty_sound = 'sound/weapons/gun/pistol/candor_unload.ogg'
	show_magazine_on_sprite = TRUE

NO_MAG_GUN_HELPER(automatic/pistol/candor)

/obj/item/gun/ballistic/automatic/pistol/candor/factory //also give this to the srm, their candors should probably look factory fresh from how well taken care of they are
	desc = "A classic semi-automatic handgun, widely popular throughout the Frontier. An engraving on the slide marks it as a product of 'Hunter's Pride Arms and Ammunition'. This example has been kept in especially good shape, and may as well be fresh out of the workshop. Chambered in .45."
	item_state = "hp_generic_fresh"

NO_MAG_GUN_HELPER(automatic/pistol/candor/factory)

/obj/item/gun/ballistic/automatic/pistol/candor/factory/update_overlays()
	. = ..()
	. += "[initial(icon_state)]_factory"

/obj/item/gun/ballistic/automatic/pistol/candor/phenex
	name = "\improper HP Phenex"
	desc = "A uniquely modified version of the Candor, famously created by Hunter's Pride. Named after the daemonic Phoenix of legend that the Ashen Huntsman had once slain, this hell-kissed weapon is more visually intimidating than its original counterpart, but mechanically acts the same. Chambered in .45."
	icon_state = "phenex"
	item_state = "hp_phenex"

/obj/item/gun/ballistic/automatic/pistol/commissar
	name = "\improper Commissar"
	desc = "A Nanotrasen-issue handgun, modified with a voice box to further enhance its effectiveness in troop discipline."
	icon_state = "commander"
	icon = 'icons/obj/guns/manufacturer/nanotrasen_sharplite/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/nanotrasen_sharplite/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/nanotrasen_sharplite/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/nanotrasen_sharplite/onmob.dmi'

	w_class = WEIGHT_CLASS_NORMAL
	default_ammo_type = /obj/item/ammo_box/magazine/co9mm
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/co9mm,
	)
	var/funnysounds = TRUE
	var/cooldown = 0
	load_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	load_empty_sound = 'sound/weapons/gun/pistol/mag_insert.ogg'
	eject_sound = 'sound/weapons/gun/pistol/mag_release.ogg'
	eject_empty_sound = 'sound/weapons/gun/pistol/mag_release.ogg'

	rack_sound = 'sound/weapons/gun/pistol/rack_small.ogg'
	lock_back_sound = 'sound/weapons/gun/pistol/lock_small.ogg'
	bolt_drop_sound = 'sound/weapons/gun/pistol/drop_small.ogg'

/obj/item/gun/ballistic/automatic/pistol/commissar/equipped(mob/living/user, slot)
	..()
	if(slot == ITEM_SLOT_HANDS && funnysounds) // We do this instead of equip_sound as we only want this to play when it's wielded
		playsound(src, 'sound/weapons/gun/commissar/pickup.ogg', 30, 0)

/obj/item/gun/ballistic/automatic/pistol/commissar/shoot_live_shot(mob/living/user, pointblank, atom/pbtarget, message)
	. = ..()
	if(prob(50) && funnysounds)
		playsound(src, 'sound/weapons/gun/commissar/shot.ogg', 30, 0)

/obj/item/gun/ballistic/automatic/pistol/commissar/shoot_with_empty_chamber(mob/living/user)
	. = ..()
	if(prob(50) && funnysounds)
		playsound(src, 'sound/weapons/gun/commissar/dry.ogg', 30, 0)

/obj/item/gun/ballistic/automatic/pistol/commissar/insert_magazine(mob/user, obj/item/ammo_box/magazine/AM, display_message)
	. = ..()
	if(bolt_locked)
		drop_bolt(user)
		if(. && funnysounds)
			playsound(src, 'sound/weapons/gun/commissar/magazine.ogg', 30, 0)

/obj/item/gun/ballistic/automatic/pistol/commissar/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	funnysounds = !funnysounds
	to_chat(user, span_notice("You toggle [src]'s vox audio functions."))

/obj/item/gun/ballistic/automatic/pistol/commissar/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if((cooldown < world.time - 200) && funnysounds)
		user.audible_message("<font color='red' size='5'><b>DON'T TURN AROUND!</b></font>")
		playsound(src, 'sound/weapons/gun/commissar/dontturnaround.ogg', 50, 0, 4)
		cooldown = world.time

/obj/item/gun/ballistic/automatic/pistol/commissar/examine(mob/user)
	. = ..()
	if(funnysounds)
		. += span_info("Alt-click to use \the [src] vox hailer.")

/obj/item/gun/ballistic/automatic/pistol/disposable
	name = "disposable gun"
	desc = "An exceedingly flimsy plastic gun that is extremely cheap to produce. You get what you pay for."
	fire_sound = 'sound/weapons/gun/pistol/himehabu.ogg'

	icon_state = "disposable" //credit to discord user 20nypercent for the sprite
	w_class = WEIGHT_CLASS_NORMAL
	default_ammo_type = /obj/item/ammo_box/magazine/disposable
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/disposable,
	)
	custom_materials = list(/datum/material/plastic=2000)
	manufacturer = MANUFACTURER_NONE
	has_safety = FALSE //thing barely costs anything, why would it have a safety?
	safety = FALSE

/obj/item/gun/ballistic/automatic/pistol/disposable/eject_magazine(mob/user, display_message = TRUE)
	to_chat(user, span_warning("Theres no magazine to eject!"))
	return

/obj/item/gun/ballistic/automatic/pistol/disposable/insert_magazine(mob/user)
	to_chat(user, span_warning("Theres no magazine to replace!"))
	return

//not technically a pistol but whatever
/obj/item/gun/ballistic/derringer
	name = ".38 Derringer"
	desc = "An easily concealable derringer. Uses .38 special ammo."
	icon_state = "derringer"
	item_state = "hp_generic"

	icon = 'icons/obj/guns/manufacturer/hunterspride/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/hunterspride/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/hunterspride/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/hunterspride/onmob.dmi'

	default_ammo_type = /obj/item/ammo_box/magazine/internal/derr38
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/internal/derr38,
	)
	fire_sound = 'sound/weapons/gun/revolver/shot.ogg'
	load_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	eject_sound = 'sound/weapons/gun/revolver/empty.ogg'
	fire_sound_volume = 60
	dry_fire_sound = 'sound/weapons/gun/revolver/dry_fire.ogg'
	casing_ejector = FALSE
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	tac_reloads = FALSE
	w_class = WEIGHT_CLASS_TINY

/obj/item/gun/ballistic/derringer/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //legacy var name maturity
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/derringer/examine(mob/user)
	. = ..()
	var/live_ammo = get_ammo(FALSE, FALSE)
	. += "[live_ammo ? live_ammo : "None"] of those are live rounds."

/obj/item/gun/ballistic/derringer/traitor
	name = "\improper .357 Syndicate Derringer"
	desc = "An easily concealable derriger, if not for the bright red-and-black. Uses .357 ammo."

	icon = 'icons/obj/guns/manufacturer/scarborough/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/scarborough/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/scarborough/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/scarborough/onmob.dmi'

	icon_state = "derringer_syndie"
	item_state = "sa_generic"
	default_ammo_type = /obj/item/ammo_box/magazine/internal/derr357
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/internal/derr357,
	)
	fire_sound_volume = 50 //Tactical stealth firing

/obj/item/gun/ballistic/derringer/gold
	name = "\improper Golden Derringer"
	desc = "The golden sheen is somewhat counter-intuitive on a holdout weapon, but it looks cool. Uses .357 ammo."
	icon_state = "derringer_gold"
	default_ammo_type = /obj/item/ammo_box/magazine/internal/derr357
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/internal/derr357,
	)

EMPTY_GUN_HELPER(ballistic/derringer)
