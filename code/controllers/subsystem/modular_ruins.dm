//PENTEST ADDITION - MODULAR RUINS SUBSYSTEM
//
// Because this is a subsystem I am going to have to break modularization rules and place this where subsystems go.
// Also This will be the only time we really need to add something into the shiptest.dme
// Ill continue to itterate over this and see if we can modularize the file.
//

SUBSYSTEM_DEF(modular_ruins)
	name = "Modular Ruins"
	init_order = INIT_ORDER_MODULAR_RUINS
	flags = SS_NO_FIRE

	/// Indexed list of rooms by size for fast lookup: list("5x5" = list(rooms), "5x10" = list(rooms), ...)
	var/list/rooms_by_size = list()

	/// Indexed list of rooms by category for fast lookup
	var/list/rooms_by_category = list()

	/// Compatibility cache for trait matching: list("trait1|trait2|..." = list(compatible_rooms))
	var/list/compatibility_cache = list()

	/// List of ruins deferred during mapload for potential later processing
	var/list/deferred_ruins = list()

	/// Performance metrics
	var/total_rooms_processed = 0
	var/total_processing_time = 0

/datum/controller/subsystem/modular_ruins/Initialize(timeofday)
	build_room_indexes()
	return ..()

/datum/controller/subsystem/modular_ruins/stat_entry(msg)
	msg = "Rooms: [length(SSmapping.modular_room_templates)] | Processed: [total_rooms_processed]"
	return ..()

/**
 * Builds optimized indexes and caches during subsystem initialization
 */
/datum/controller/subsystem/modular_ruins/proc/build_room_indexes()
	log_modular_ruins("Building modular room indexes...")
	var/start_time = world.timeofday

	// Debug: Check if mapping subsystem has loaded templates
	if(!SSmapping)
		log_modular_ruins("ERROR: SSmapping is null!")
		return

	if(!SSmapping.modular_room_templates)
		log_modular_ruins("ERROR: SSmapping.modular_room_templates is null!")
		return

	var/template_count = length(SSmapping.modular_room_templates)
	log_modular_ruins("Found [template_count] templates in SSmapping.modular_room_templates")

	// Clear existing indexes
	rooms_by_size = list()
	rooms_by_category = list()
	compatibility_cache = list()

	// Build indexes from the mapping subsystem's loaded templates
	for(var/room_name in SSmapping.modular_room_templates)
		var/datum/map_template/modular_room/room = SSmapping.modular_room_templates[room_name]

		// Index by size
		if(!rooms_by_size[room.room_size])
			rooms_by_size[room.room_size] = list()
		rooms_by_size[room.room_size] += room

		// Index by category
		if(!rooms_by_category[room.room_category])
			rooms_by_category[room.room_category] = list()
		rooms_by_category[room.room_category] += room

	var/elapsed = world.timeofday - start_time
	log_modular_ruins("Built room indexes in [elapsed/10] seconds")
	log_modular_ruins("- Indexed [length(rooms_by_size)] size categories")
	log_modular_ruins("- Indexed [length(rooms_by_category)] room categories")

/**
 * Defers a ruin for later processing (called during mapload)
 * This avoids blocking server initialization
 */
/datum/controller/subsystem/modular_ruins/proc/defer_ruin(datum/map_template/ruin/ruin_datum)
	if(!ruin_datum)
		return FALSE

	log_modular_ruins("DEFERRED: Ruin '[ruin_datum.name]' added to deferred list")
	deferred_ruins += ruin_datum
	return TRUE

/**
 * Processes a ruin's modular rooms immediately (called at runtime when players visit)
 * Uses pre-built indexes for fast processing
 */
/datum/controller/subsystem/modular_ruins/proc/process_ruin(datum/map_template/ruin/ruin_datum)
	if(!ruin_datum?.this_ruin_uses_modular_rooms)
		return FALSE

	var/start_time = world.timeofday
	log_modular_ruins("PROCESSING: Ruin '[ruin_datum.name]' started")

	// Find all modular markers in this ruin's area
	ruin_datum.find_modular_markers()

	if(!length(ruin_datum.modular_markers))
		log_modular_ruins("PROCESSING: No modular markers found in '[ruin_datum.name]'")
		return FALSE

	log_modular_ruins("PROCESSING: Found [length(ruin_datum.modular_markers)] modular markers")

	// Detect parent door connections for all markers
	for(var/obj/effect/landmark/modular_marker/marker in ruin_datum.modular_markers)
		marker.detect_parent_connections()

	// Clean up parent door markers now that detection is complete
	ruin_datum.cleanup_parent_door_markers()

	// Place modular rooms at each marker
	var/successful_placements = 0
	var/failed_placements = 0

	for(var/obj/effect/landmark/modular_marker/marker in ruin_datum.modular_markers)
		marker.parent_ruin = ruin_datum
		var/datum/map_template/modular_room/placed_room = place_room_at_marker(marker, ruin_datum)

		if(placed_room)
			successful_placements++
			// Track the room type if it doesn't allow duplicates
			if(!placed_room.allow_duplicates)
				ruin_datum.used_modular_rooms += placed_room.type
			// Marker deletes itself after successful placement
		else
			failed_placements++
			// Delete failed markers too
			qdel(marker)

	var/elapsed = world.timeofday - start_time
	total_processing_time += elapsed
	total_rooms_processed += successful_placements

	log_modular_ruins("PROCESSING: '[ruin_datum.name]' complete in [elapsed/10]s - [successful_placements] placed, [failed_placements] failed")
	return TRUE

/**
 * Places a room at a marker using optimized lookup
 * Returns the placed room or null if failed
 */
/datum/controller/subsystem/modular_ruins/proc/place_room_at_marker(obj/effect/landmark/modular_marker/marker, datum/map_template/ruin/parent_ruin)
	if(!marker || !parent_ruin)
		return null

	// Use optimized room selection
	var/datum/map_template/modular_room/selected_room = select_compatible_room_fast(marker, parent_ruin)
	if(!selected_room)
		log_modular_ruins("PLACEMENT: No compatible room found for marker at [marker.x],[marker.y],[marker.z]")
		return null

	// Get placement coordinates
	var/marker_x = marker.x
	var/marker_y = marker.y
	var/marker_z = marker.z

	// Get the target turf for placement (bottom-left corner)
	var/turf/target_turf = locate(marker_x, marker_y, marker_z)
	if(!target_turf)
		log_modular_ruins("PLACEMENT: Invalid target turf for room at [marker_x],[marker_y],[marker_z]")
		return null

	// Store placement traits for post-processing
	var/list/placement_traits = marker.placement_traits

	// Mark that we're loading a modular room (for air system optimization)
	SSair.loading_modular_room = TRUE

	// Load the room at this location
	var/success = selected_room.load(target_turf, centered = FALSE)

	// Clear the loading flag
	SSair.loading_modular_room = FALSE

	if(success)
		log_modular_ruins("PLACEMENT: Placed '[selected_room.name]' at [marker_x],[marker_y],[marker_z]")
		selected_room.post_load_room(target_turf, placement_traits)
		qdel(marker)
		return selected_room
	else
		log_modular_ruins("PLACEMENT: Failed to load '[selected_room.name]' at [marker_x],[marker_y],[marker_z]")
		qdel(marker)
		return null

/**
 * Fast room selection using indexes and caching
 * Returns a compatible room or null if none found
 */
/datum/controller/subsystem/modular_ruins/proc/select_compatible_room_fast(obj/effect/landmark/modular_marker/marker, datum/map_template/ruin/parent_ruin)
	if(!marker)
		return null

	var/required_size = marker.required_size
	var/list/required_traits = marker.placement_traits
	var/list/forbidden_traits = marker.forbidden_room_traits
	var/list/required_connections = marker.required_connections
	var/list/approved_rooms = marker.approved_rooms

	if(GLOB.modular_connections_debug)
		log_modular_ruins("SELECTION: Looking for room with size '[required_size]'")
		log_modular_ruins("SELECTION: Total size categories available: [length(rooms_by_size)]")
		if(rooms_by_size[required_size])
			log_modular_ruins("SELECTION: Found [length(rooms_by_size[required_size])] rooms for size '[required_size]'")

	// FAST PATH 1: Size filter - eliminates most incompatible rooms immediately
	var/list/size_filtered = rooms_by_size[required_size]
	if(!size_filtered?.len)
		log_modular_ruins("SELECTION: No rooms found for size '[required_size]'")
		log_modular_ruins("SELECTION: Available sizes: [json_encode(rooms_by_size)]")
		return null

	// FAST PATH 2: Approved whitelist - if set, only check those rooms
	if(approved_rooms?.len)
		var/list/compatible = list()
		var/list/weights = list()

		// Whitelist contains type paths, so we need to check against room types
		for(var/datum/map_template/modular_room/room in size_filtered)
			// Check if this room's type is in the approved list
			if(!(room.type in approved_rooms))
				continue

			// Check if already used (for non-duplicate rooms)
			if(!room.allow_duplicates && (room.type in parent_ruin.used_modular_rooms))
				continue

			// Verify traits
			if(!check_trait_compatibility(room, required_traits, forbidden_traits))
				continue

			// Verify door connections if required
			if(required_connections?.len && !check_door_compatibility(room, required_connections))
				continue

			compatible += room
			weights[room] = room.selection_weight

		if(GLOB.modular_connections_debug)
			log_modular_ruins("SELECTION: Whitelist filtering found [length(compatible)] compatible rooms from [length(approved_rooms)] approved types")

		return pick_weighted_room(compatible, weights)

	// NORMAL PATH: Check all rooms of this size
	var/list/compatible = list()
	var/list/weights = list()
	var/list/used_types = parent_ruin.used_modular_rooms

	for(var/datum/map_template/modular_room/room in size_filtered)
		// Check duplicate status
		if(!room.allow_duplicates && (room.type in used_types))
			continue

		// Check trait compatibility
		if(!check_trait_compatibility(room, required_traits, forbidden_traits))
			continue

		// Check door connections if required
		if(required_connections?.len && !check_door_compatibility(room, required_connections))
			continue

		compatible += room
		weights[room] = room.selection_weight

	return pick_weighted_room(compatible, weights)

/**
 * Checks if a room's traits are compatible with requirements
 */
/datum/controller/subsystem/modular_ruins/proc/check_trait_compatibility(datum/map_template/modular_room/room, list/required_traits, list/forbidden_traits)
	// Check required traits
	if(required_traits?.len)
		for(var/required_trait in required_traits)
			if(!(required_trait in room.room_traits))
				return FALSE

	// Check forbidden traits
	if(forbidden_traits?.len)
		for(var/forbidden_trait in forbidden_traits)
			if(forbidden_trait in room.room_traits)
				return FALSE

	// Check room's required traits
	if(room.required_traits?.len)
		for(var/room_required in room.required_traits)
			if(!(room_required in required_traits))
				return FALSE

	// Check room's forbidden traits
	if(room.forbidden_traits?.len)
		for(var/room_forbidden in room.forbidden_traits)
			if(room_forbidden in required_traits)
				return FALSE

	return TRUE

/**
 * Checks if a room has compatible door connections
 */
/datum/controller/subsystem/modular_ruins/proc/check_door_compatibility(datum/map_template/modular_room/room, list/required_connections)
	if(!required_connections?.len)
		return TRUE

	if(!room.available_connections?.len)
		return FALSE

	// For now, just check if room has at least as many connections as required
	// More sophisticated matching could be added later
	return length(room.available_connections) >= length(required_connections)

/**
 * Picks a room from compatible list using weighted selection
 */
/datum/controller/subsystem/modular_ruins/proc/pick_weighted_room(list/compatible_rooms, list/weights)
	if(!compatible_rooms?.len)
		return null

	if(compatible_rooms.len == 1)
		return compatible_rooms[1]

	// Use weighted pick if weights exist
	if(weights?.len)
		return pick_weight_allow_zero(weights)

	// Fallback to random pick
	return pick(compatible_rooms)
