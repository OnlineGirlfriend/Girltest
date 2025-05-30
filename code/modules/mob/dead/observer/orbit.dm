/datum/orbit_menu
	///mobs worth orbiting. Because spaghetti, all mobs have the point of interest, but only some are allowed to actually show up.
	///this obviously should be changed in the future, so we only add mobs as POI if they actually are interesting, and we don't use
	///a typecache.
	var/static/list/mob_allowed_typecache
	var/mob/dead/observer/owner

/datum/orbit_menu/New(mob/dead/observer/new_owner)
	if(!istype(new_owner))
		qdel(src)
	owner = new_owner

/datum/orbit_menu/ui_state(mob/user)
	return GLOB.observer_state

/datum/orbit_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Orbit")
		ui.open()

/datum/orbit_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if ("orbit")
			var/ref = params["ref"]
			var/auto_observe = params["auto_observe"]
			var/atom/movable/poi = SSpoints_of_interest.get_poi_atom_by_ref(ref)

			if((ismob(poi) && !SSpoints_of_interest.is_valid_poi(poi, CALLBACK(src, PROC_REF(validate_mob_poi)))) \
				|| !SSpoints_of_interest.is_valid_poi(poi)
			)
				to_chat(usr, span_notice("That point of interest is no longer valid."))
				return TRUE

			var/mob/dead/observer/user = usr
			owner.ManualFollow(poi)
			owner.reset_perspective(null)
			user.orbiting_ref = ref
			if (auto_observe)
				owner.do_observe(poi)
			. = TRUE
		if ("refresh")
			update_static_data(owner, ui)
			. = TRUE


/datum/orbit_menu/ui_data(mob/user)
	var/list/data = list()

	if(isobserver(user))
		data["orbiting"] = get_currently_orbiting(user)

	return data

/datum/orbit_menu/ui_static_data(mob/user)
	var/list/new_mob_pois = SSpoints_of_interest.get_mob_pois(CALLBACK(src, PROC_REF(validate_mob_poi)), append_dead_role = FALSE)
	var/list/new_other_pois = SSpoints_of_interest.get_other_pois()

	var/list/alive = list()
	var/list/antagonists = list()
	var/list/critical = list()
	var/list/dead = list()
	var/list/ghosts = list()
	var/list/ships = list()
	var/list/misc = list()
	var/list/npcs = list()

	for(var/name in new_mob_pois)
		var/list/serialized = list()
		var/mob/mob_poi = new_mob_pois[name]
		var/number_of_orbiters = length(mob_poi.get_all_orbiters())

		if(isnewplayer(mob_poi))
			continue

		serialized["ref"] = REF(mob_poi)
		serialized["full_name"] = mob_poi.name
		serialized["job"] = mob_poi.job
		if(number_of_orbiters)
			serialized["orbiters"] = number_of_orbiters

		if(isobserver(mob_poi))
			ghosts += list(serialized)
			continue

		if(mob_poi.stat == DEAD)
			dead += list(serialized)
			continue

		if(isnull(mob_poi.mind))
			if(isliving(mob_poi))
				var/mob/living/npc = mob_poi
				serialized["health"] = FLOOR((npc.health / npc.maxHealth * 100), 1)

			npcs += list(serialized)
			continue

		serialized["client"] = !!mob_poi.client
		serialized["name"] = mob_poi.real_name

		if(isliving(mob_poi))
			serialized += get_living_data(mob_poi)

		var/list/antag_data = get_antag_data(mob_poi.mind)
		if(length(antag_data))
			serialized += antag_data
			antagonists += list(serialized)
			continue

		alive += list(serialized)

	for(var/name in new_other_pois)
		var/atom/atom_poi = new_other_pois[name]

		var/list/other_data = get_misc_data(atom_poi)
		var/misc_data = list(other_data[1])

		if(istype(atom_poi, /obj/machinery/computer/helm))
			ships += misc_data
		else
			misc += misc_data

		if(other_data[2]) // Critical = TRUE
			critical += misc_data

	return list(
		"alive" = alive,
		"antagonists" = antagonists,
		"critical" = critical,
		"dead" = dead,
		"ghosts" = ghosts,
		"ships" = ships,
		"misc" = misc,
		"npcs" = npcs,
	)

/datum/orbit_menu/ui_assets()
	. = ..() || list()
	. += get_asset_datum(/datum/asset/simple/orbit)

/// Helper function to get threat type, group, overrides for job and icon
/datum/orbit_menu/proc/get_antag_data(datum/mind/poi_mind) as /list
	var/list/serialized = list()

	for(var/datum/antagonist/antag as anything in poi_mind.antag_datums)
		if(!antag.show_to_ghosts)
			continue

		serialized["antag"] = antag.name
		serialized["antag_group"] = antag.antagpanel_category
		serialized["job"] = antag.name
		serialized["icon"] = antag.antag_hud_name

		return serialized

/// Helper to get the current thing we're orbiting (if any)
/datum/orbit_menu/proc/get_currently_orbiting(mob/dead/observer/user)
	if(isnull(user.orbiting_ref))
		return

	var/atom/poi = SSpoints_of_interest.get_poi_atom_by_ref(user.orbiting_ref)
	if(isnull(poi))
		user.orbiting_ref = null
		return

	if((ismob(poi) && !SSpoints_of_interest.is_valid_poi(poi, CALLBACK(src, PROC_REF(validate_mob_poi)))) \
		|| !SSpoints_of_interest.is_valid_poi(poi)
	)
		user.orbiting_ref = null
		return

	var/list/serialized = list()

	if(!ismob(poi))
		var/list/misc_info = get_misc_data(poi)
		serialized += misc_info[1]
		return serialized

	var/mob/mob_poi = poi
	serialized["full_name"] = mob_poi.name
	serialized["ref"] = REF(poi)

	if(mob_poi.mind)
		serialized["client"] = !!mob_poi.client
		serialized["name"] = mob_poi.real_name

	if(isliving(mob_poi))
		serialized += get_living_data(mob_poi)

	return serialized

/// Helper function to get job / icon / health data for a living mob
/datum/orbit_menu/proc/get_living_data(mob/living/player) as /list
	var/list/serialized = list()

	serialized["health"] = FLOOR((player.health / player.maxHealth * 100), 1)

	return serialized


/// Gets a list: Misc data and whether it's critical. Handles all snowflakey type cases
/datum/orbit_menu/proc/get_misc_data(atom/movable/atom_poi) as /list
	var/list/misc = list()
	var/critical = FALSE

	misc["ref"] = REF(atom_poi)
	misc["full_name"] = atom_poi.name

	// Display the nuke timer
	if(istype(atom_poi, /obj/machinery/nuclearbomb))
		var/obj/machinery/nuclearbomb/bomb = atom_poi

		if(bomb.timing)
			misc["extra"] = "Timer: [bomb.countdown?.displayed_text]s"
			critical = TRUE

		return list(misc, critical)

	// Display the holder if its a nuke disk
	if(istype(atom_poi, /obj/item/disk/nuclear))
		var/obj/item/disk/nuclear/disk = atom_poi
		var/mob/holder = disk.pulledby || get(disk, /mob)
		misc["extra"] = "Location: [holder?.real_name || "Unsecured"]"

		return list(misc, critical)

	// Display singuloths if they exist
	if(istype(atom_poi, /obj/singularity))
		var/obj/singularity/singulo = atom_poi
		misc["extra"] = "Energy: [round(singulo.energy)]"

		if(singulo.current_size > 2)
			critical = TRUE

		return list(misc, critical)

	if(istype(atom_poi, /obj/machinery/computer/helm))
		var/obj/machinery/computer/helm/helm_poi = atom_poi
		if(helm_poi.current_ship)
			var/datum/overmap/ship/controlled/helm_ship = helm_poi.current_ship
			misc["full_name"] = helm_ship.name
			misc["extra"] = "Crew Size: [length(helm_ship.manifest)]"

		return list(misc, critical)

	return list(misc, critical)

/**
 * Helper POI validation function passed as a callback to various SSpoints_of_interest procs.
 *
 * Provides extended validation above and beyond standard, limiting mob POIs without minds or ckeys
 * unless they're mobs, camera mobs or megafauna. Also allows exceptions for mobs that are deadchat controlled.
 *
 * If they satisfy that requirement, falls back to default validation for the POI.
 */
/datum/orbit_menu/proc/validate_mob_poi(datum/point_of_interest/mob_poi/potential_poi)
	var/mob/potential_mob_poi = potential_poi.target
	if(!potential_mob_poi.mind && !potential_mob_poi.ckey)
		if(!mob_allowed_typecache)
			mob_allowed_typecache = typecacheof(list(
				/mob/living/simple_animal/hostile/megafauna,
				/mob/living/simple_animal/hostile/boss
			))
		if(!is_type_in_typecache(potential_mob_poi, mob_allowed_typecache) && !potential_mob_poi.GetComponent(/datum/component/deadchat_control) && !potential_mob_poi.GetComponent(/datum/component/mission_important))
			return FALSE

	return potential_poi.validate()
