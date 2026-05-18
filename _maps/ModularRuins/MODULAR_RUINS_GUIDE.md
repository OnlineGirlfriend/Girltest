# Modular Ruin System - Documentation

## Overview

The Modular Ruin System allows map makers to create "parent" ruins (like a space mall or abandoned station) where individual rooms/sections are dynamically selected and placed at runtime from a pool of "modular room" templates.

## Why Use This System?

- **Replayability**: Each time a modular ruin spawns, it can have different room layouts
- **Modularity**: Create a library of rooms that can be mixed and matched
- **Easier Mapping**: Focus on creating good individual rooms rather than entire complexes
- **Scalability**: Add new rooms without modifying existing ruins

## System Flow

1. **World Generation**: Planet generates terrain (existing system)
2. **Ruin Placement**: A parent ruin (e.g., spacemall.dmm) is selected and placed (existing system)
3. **Modular Processing**: NEW - The system finds modular placement markers within the ruin
4. **Room Selection**: Compatible rooms are selected based on traits
5. **Room Placement**: Selected rooms are loaded at marker positions

## Creating a Modular Parent Ruin

### Step 1: Create Your Main Ruin and Mark Modular Zones

Create your ruin map file normally (e.g., `spacemall.dmm`).

### Step 2: Add Modular Markers

1. **Place the modular placement landmark**
Place one marker turf at the **bottom-left corner** of each modular zone:

```dm
// For a 5x5 room
/turf/open/floor/modular_marker/small

// For a 10x10 room
/turf/open/floor/modular_marker/medium

// For a 5x10 hallway
/turf/open/floor/modular_marker/hallway

// For a 6x6 shop
/turf/open/floor/modular_marker/shop
```

2. **OPTIONAL: Paint the exact room footprint** 
Paint the area with visual guide turfs (e.g., paint all 25 tiles of a 5x5 space)

**Visual Guide Turfs** (makes it obvious in the map editor):
```dm
/turf/open/floor/modular_guide
```

**Example in Map Editor:**
```
Paint a 5x5 area with /turf/open/floor/modular_guide:
[Guide][Guide][Guide][Guide][Guide]
[Guide][Guide][Guide][Guide][Guide]
[Guide][Guide][Guide][Guide][Guide]
[Guide][Guide][Guide][Guide][Guide]
[MARKER][Guide][Guide][Guide][Guide]  <- Marker at bottom-left

The guide turfs are purely visual - they get replaced when the room loads!
```

### Step 3: Add Door Connection Markers (OPTIONAL - for door alignment validation)

If your modular zones have doors that need to align with the parent ruin structure, use door markers:

**In the Parent Ruin:**
Place `/obj/effect/landmark/modular_connection/parent_door` at each door tile that modular rooms should connect to.

**Example:**
```
[Wall][Wall][Door][Wall][Wall]
			  ^
		 Place parent_door marker here
```

**Important Notes:**
- Door markers can be placed ON the door tile itself (interior edge) or one tile outside (exterior edge)
- The system automatically detects doors within ±1 tile orthogonally
- Format: Markers are stored as coordinates like "5,4" relative to the marker's bottom-left
- Rooms without matching door positions are automatically filtered out

**In Modular Room Templates:**
Place `/obj/effect/landmark/modular_connection/door` at positions where doors can connect in your modular room .dmm files.

The system will:
1. Detect all parent door markers within the marker's scan area
2. Scan modular room templates for their door connection markers
3. Match rooms where doors align within ±1 tile (orthogonally only: north, south, east, west)
4. Filter out rooms where doors don't align properly

**Valid offset examples:**
- Parent door at (5,4), room door at (4,4) → offset (-1,0) ✓ VALID (west)
- Parent door at (5,4), room door at (5,3) → offset (0,-1) ✓ VALID (south)
- Parent door at (5,4), room door at (5,4) → offset (0,0) ✗ INVALID (same position)
- Parent door at (5,4), room door at (4,5) → offset (-1,1) ✗ INVALID (diagonal)

### Step 4: Configure Traits

You can customize markers with traits in your map editor via variables:

```dm
/obj/effect/landmark/modular_marker{
	required_size = "6x6";  // Plain string - no DEFINE needed!
	placement_traits = list(MODULAR_FACTION_NANOTRASEN, MODULAR_ENEMY_ZOMBIES, MODULAR_LOOT_MEDIUM);
	forced_category = MODULAR_ROOM_SHOP
}
```

**Advanced Options:**

For weird-shaped rooms or specific room sets:
```dm
/obj/effect/landmark/modular_marker{
	required_size = "7x7";
	// Only allow these specific rooms (perfect for custom-shaped rooms with 4 variants)
	approved_rooms = list(
		/datum/map_template/modular_room/custom/weird_shape_v1,
		/datum/map_template/modular_room/custom/weird_shape_v2,
		/datum/map_template/modular_room/custom/weird_shape_v3,
		/datum/map_template/modular_room/custom/weird_shape_v4
	)
}
```

For filtering out specific room traits (e.g., preventing vacuum rooms on planets):
```dm
/obj/effect/landmark/modular_marker{
	required_size = "10x10";
	placement_traits = list(MODULAR_ENV_BREATHABLE);  // Zone is breathable
	// Prevent any rooms with vacuum trait from spawning
	forbidden_room_traits = list(MODULAR_ENV_VACUUM)
	// Useful for: preventing spaced shuttles on planets, blocking dangerous rooms in safe zones, etc.
}
```

**IMPORTANT:** The marker must ALWAYS be placed at the bottom-left corner of the full rectangular size (e.g., bottom-left of the 7x7), even if that corner is a template_noop tile in your modular room. The system uses this position as the anchor point for loading the entire template.

**For Testing:**
```dm
/obj/effect/landmark/modular_marker{
	// Force one specific room (bypasses all filtering)
	forced_template = /datum/map_template/modular_room/shop/my_test_shop
}
```

### Marker Variable Priority (Filter Order)

When selecting a room, the system checks filters in this exact order:

1. **`forced_template`** - If set, immediately returns this room and skips ALL other checks
2. **`required_size`** - Room dimensions must exactly match (hard filter) - **CHECKED FIRST for performance**
3. **`approved_rooms`** - If set, room MUST be in this list (hard filter)
4. **`forced_category`** - If set, room category must match (hard filter)
5. **`placement_traits`** - Checks room compatibility using the room's `required_traits`/`forbidden_traits` settings
6. **`forbidden_room_traits`** - If set, room cannot have ANY of these traits (hard filter)
7. **`available_connections`** - If parent has door markers, checks coordinate-based alignment (hard filter) - **MOST EXPENSIVE**
8. **`allow_duplicates`** - Checks if room was already used in this ruin (soft filter, has fallback)

**Key Points:**
- **Hard filters** = Room is completely excluded if it fails
- **Soft filters** = Has fallback behavior (e.g., allow_duplicates will use duplicates if no unique rooms left)
- **Order is optimized for performance!** Size check is fastest (eliminates most rooms), connection check is slowest (done last)
- Setting `forced_template` bypasses everything - useful for testing specific rooms

**Example combining filters:**
```dm
/obj/effect/landmark/modular_marker{
	required_size = "9x6";  // Plain string
	approved_rooms = list(/datum/.../shuttle_v1, /datum/.../shuttle_v2, /datum/.../shuttle_v3, /datum/.../shuttle_v4);
	forbidden_room_traits = list(MODULAR_ENV_VACUUM);  // Blocks shuttle_v4 if it has vacuum
	forced_category = MODULAR_ROOM_SHUTTLE;  // Redundant but explicit
	placement_traits = list(MODULAR_ENV_BREATHABLE)  // Additional compatibility check
}
```
Result: Only shuttles v1-v3 can spawn (v4 blocked by forbidden_room_traits), and they must pass compatibility checks.

### Step 4: Mark the Ruin as Modular

In your ruin datum definition:

```dm
/datum/map_template/ruin/space/spacemall
	name = "Abandoned Space Mall"
	id = "spacemall"
	description = "A once-thriving mall, now empty..."
	suffix = "spacemall.dmm"
	this_ruin_uses_modular_rooms = TRUE  // <- ADD THIS
	// ... other properties
```

## Creating Modular Rooms

### Area Inheritance - CRITICAL

**All modular room DMMs MUST use `/area/template_noop` for proper area inheritance.**

### Why This Matters

When a modular room is loaded, the area system preserves the parent ruin's area:

1. **Parent Ruin**: Places modular marker in its specific area (e.g., `/area/ruin/space/has_grav/spacemall/shop`)
2. **Modular Room DMM**: Uses `/area/template_noop` for all turfs
3. **Map Loading**: The system skips loading `/area/template_noop`, leaving turfs in the parent's area
4. **Result**: Modular room inherits the parent area at the placement location

### Benefits

- **Reusability**: Same bedroom works in space mall, beach resort, or pirate ship
- **Power Systems**: APCs in parent area power the modular rooms correctly
- **Atmospherics**: Area-based air systems work across the entire combined space
- **APC Connectivity**: Devices in modular rooms connect to parent area's APC without issues

### Example

```dm
// Parent Ruin (spacemall_modular.dmm)
"yr" = (
/obj/effect/landmark/modular_marker/mall_bedrooms_2x2,
/turf/open/floor/modular_guide,
/area/ruin/space/has_grav/spacemall/dorms)  // Parent's dorms area

// Modular Room DMM (bedroom_2x2_v1.dmm)
"a" = (
/obj/structure/dresser,
/turf/open/floor/wood,
/area/template_noop)  // Will inherit parent's area!

// After Loading:
// The bedroom's turfs are now in /area/ruin/space/has_grav/spacemall/dorms
// If same bedroom loads in beach resort, it inherits /area/ruin/beach/rooms instead
```

### Converting Existing Rooms

If you have modular rooms with hardcoded areas, convert them:

```powershell
# Use the provided conversion script
powershell -ExecutionPolicy Bypass -File .\tools\convert_modular_rooms_to_template_noop.ps1
```

This script automatically replaces all hardcoded area paths with `/area/template_noop` in your modular room DMMs.

### Creating New Modular Rooms

**DO THIS:** ✅
```dm
"a" = (
/obj/structure/table,
/turf/open/floor/plasteel,
/area/template_noop)  // CORRECT - inherits parent area
```

**DON'T DO THIS:** ❌
```dm
"a" = (
/obj/structure/table,
/turf/open/floor/plasteel,
/area/ruin/beach)  // WRONG - locks room to beach ruins only!
```

### Adding Door Connection Markers to Modular Rooms

If your parent ruin uses door validation (has parent_door markers), your modular rooms need matching door markers:

**Step 1:** Place `/obj/effect/landmark/modular_connection/door` at each position where a door can connect.

**Step 2:** The system will automatically scan your .dmm file during preload and store door positions as coordinates (e.g., "3,1" for a door at X=3, Y=1 from bottom-left).

**Step 3:** During room selection, the system matches door coordinates with ±1 offset tolerance:
- Parent door at (5,4) will accept room doors at (4,4), (6,4), (5,3), or (5,5)
- This accounts for doors being on either side of a wall

**Example modular room with doors:**
```dm
// In your 5x5 modular room .dmm file:
// Place door connection markers where doors should align

[Floor][Floor][Floor][Floor][Floor]
[Floor][Floor][Floor][Floor][Floor]
[Floor][Floor][Floor][Floor][Floor]
[Floor][Floor][Floor][Floor][Floor]
[Floor][DOOR][Floor][Floor][Floor]  <- Door marker at position (2,1)
The system will register this as available_connections = list("2,1":"door")
```

**Tips:**
- Place door markers on the same tiles where actual doors/airlocks will be on parent ruins
- Multiple door markers per room are supported on modular ruins
- The coordinate system is 1-based from the modular room's bottom-left corner
- Don't place markers on template_noop tiles

### Handling Weird-Shaped Rooms

For non-rectangular rooms, use **template noop** to preserve the parent ruin's layout:

```dm
// In your modular room .dmm file
// Areas/turfs marked as template_noop are NOT replaced when the room loads

/area/template_noop  // This area won't be replaced
/turf/template_noop  // This turf won't be replaced
```

**Example: L-shaped room in a 7x7 space**
```
[Room][Room][Room][Noop][Noop][Noop][Noop]
[Room][Room][Room][Noop][Noop][Noop][Noop]
[Room][Room][Room][Noop][Noop][Noop][Noop]
[Room][Room][Room][Room][Room][Room][Room]
[Room][Room][Room][Room][Room][Room][Room]
[Room][Room][Room][Room][Room][Room][Room]
[Room][Room][Room][Room][Room][Room][Room]
```

**Example: L-shaped room in a 7x7 space with internal door**
```
[Room][Room][Room][Noop][Noop][Noop][Noop]
[Room][Room][Room][Noop][Noop][Noop][Noop]
[Room][Room][Room][Noop][DOOR][Noop][Noop] <- Parent Ruin Marker placed at position (5,5)
[Room][Room][Room][Room][MARK][Room][Room] <- Door marker at position (5,4)
[Room][Room][Room][Room][Room][Room][Room]
[Room][Room][Room][Room][Room][Room][Room]
[Room][Room][Room][Room][Room][Room][Room]
The system will register this as an approved connection
```

The noop tiles preserve whatever was in the parent ruin, allowing complex shapes while still using standard rectangular sizes.

**Recommended Workflow for Weird Shapes:**
1. Create 4+ variations of the same weird shape
2. Use `approved_rooms` on the marker to limit to just those variants
3. Use `/turf/template_noop` for areas outside the actual room shape
4. This ensures variety while maintaining the exact shape you need

### Basic Template

Create a new file in `code/datums/ruins/modular/`:

```dm
/datum/map_template/modular_room/shop/my_shop
	name = "My Cool Shop"
	mappath = "_maps/ModularRuins/shops/my_shop_6x6.dmm"
	room_size = "6x6"  // Dedicated variable - specify as plain string!
	
	room_traits = list(
		MODULAR_FACTION_INDEPENDENT,	// Who built/owns this
		MODULAR_THEME_COMMERCIAL,		// What type of room
		MODULAR_LOOT_MEDIUM,			// Loot level
		MODULAR_ENEMY_NONE				// Enemies present
	)
	
	room_category = MODULAR_ROOM_SHOP
	selection_weight = 10				// Higher = more likely to be picked
	allow_duplicates = TRUE				// Can appear multiple times per ruin?
	
	// NOTE: available_connections is automatically populated by scan_for_connections()
	// during preload. It reads your .dmm file and finds all door connection markers.
	// Format: list("3,1":"door", "5,3":"door") - coordinates relative to bottom-left
```

### Important: Using Parent Types with `abstract_type`

If you create parent datums to share variables across multiple rooms, you **MUST** set `abstract_type` to prevent them from being loaded:

```dm
// PARENT - No mappath, just shared settings
/datum/map_template/modular_room/shop
	name = "Generic Shop Base"
	abstract_type = /datum/map_template/modular_room/shop  // CRITICAL: Prevents loading!
	room_category = MODULAR_ROOM_SHOP
	allow_duplicates = TRUE

// CHILD - Has mappath, will actually load
/datum/map_template/modular_room/shop/weapon_shop
	name = "Weapon Shop"
	mappath = "_maps/ModularRuins/shops/weapon_shop.dmm"  // This one loads!
	room_size = "6x6"
	room_traits = list(MODULAR_LOOT_MAJOR)
```

**Why this matters:** Without `abstract_type`, the system will try to load the parent datum (which has no mappath) and log warnings. The preload function automatically skips any datum where `abstract_type` equals its own path.

### Advanced: Required & Forbidden Traits

```dm
/datum/map_template/modular_room/security/syndicate_armory
	name = "Syndicate Armory"
	mappath = "_maps/ModularRuins/syndicate_armory_10x10.dmm"
	room_size = "10x10"

	room_traits = list(
		MODULAR_FACTION_SYNDICATE,
		MODULAR_THEME_MILITARY,
		MODULAR_LOOT_MAJOR
	)

	// This room REQUIRES faction_syndicate to be in the marker
	required_traits = list(MODULAR_FACTION_SYNDICATE)

	// This room will NEVER spawn if these traits are present
	forbidden_traits = list(MODULAR_FACTION_NANOTRASEN)

	selection_weight = 15
```

## Available Trait Constants (Check `code\_DEFINES\modular_ruins.dm` for current list)

### Room Size

**Size is NOT a trait!** Use the dedicated `room_size` variable instead:

```dm
/datum/map_template/modular_room/my_room
	room_size = "6x7"  // Just write the dimensions as a string
```

**Common sizes:** `"3x3"`, `"5x5"`, `"6x6"`, `"7x7"`, `"10x10"`, `"14x14"`, `"5x10"`, `"10x5"`, `"6x7"`, `"8x4"`, etc.

**Note:** You can use ANY dimensions without needing to define them first. The old `MODULAR_SIZE_*` defines are deprecated.

**For markers:** Use plain strings too: `required_size = "6x7"`

**Handling NOOP tiles:** Remember that the bottom left most tile is the bounding point for your modular ruin. 


### Factions
- `MODULAR_FACTION_NANOTRASEN`
- `MODULAR_FACTION_SYNDICATE`
- `MODULAR_FACTION_INDEPENDENT`
- `MODULAR_FACTION_SRM`
- `MODULAR_FACTION_INTEQ`
- `MODULAR_FACTION_FRONTIER`
- `MODULAR_FACTION_PIRATE`

### Enemy Types
- `MODULAR_ENEMY_NONE`
- `MODULAR_ENEMY_ZOMBIES`
- `MODULAR_ENEMY_SPIDERS`
- `MODULAR_ENEMY_SYNDICATE`
- `MODULAR_ENEMY_PIRATES`
- `MODULAR_ENEMY_WILDLIFE`
- `MODULAR_ENEMY_MECHS`
- `MODULAR_ENEMY_CONSTRUCTS`

### Danger Levels
- `MODULAR_DANGER_SAFE`
- `MODULAR_DANGER_MINOR`
- `MODULAR_DANGER_MEDIUM`
- `MODULAR_DANGER_HIGH`
- `MODULAR_DANGER_EXTREME`

### Themes
- `MODULAR_THEME_MILITARY`
- `MODULAR_THEME_CIVILIAN`
- `MODULAR_THEME_INDUSTRIAL`
- `MODULAR_THEME_RESEARCH`
- `MODULAR_THEME_COMMERCIAL`
- `MODULAR_THEME_ABANDONED`

### Environment
- `MODULAR_ENV_POWERED`
- `MODULAR_ENV_UNPOWERED`
- `MODULAR_ENV_DAMAGED`
- `MODULAR_ENV_PRISTINE`
- `MODULAR_ENV_VACUUM`
- `MODULAR_ENV_BREATHABLE`

### Loot Levels
- `MODULAR_LOOT_NONE`
- `MODULAR_LOOT_MINOR`
- `MODULAR_LOOT_MEDIUM`
- `MODULAR_LOOT_MAJOR`

## Room Categories

Categories help organize rooms and can be forced on markers:

- `MODULAR_ROOM_GENERIC` - Any room type
- `MODULAR_ROOM_HALLWAY` - Connecting corridors
- `MODULAR_ROOM_SHOP` - Commercial spaces
- `MODULAR_ROOM_STORAGE` - Storage areas
- `MODULAR_ROOM_RESIDENTIAL` - Living quarters
- `MODULAR_ROOM_SECURITY` - Security/armory
- `MODULAR_ROOM_MEDICAL` - Medical facilities
- `MODULAR_ROOM_ENGINEERING` - Engineering areas
- `MODULAR_ROOM_CARGO` - Cargo bays
- `MODULAR_ROOM_COMMAND` - Command centers
- `MODULAR_ROOM_MAINTENANCE` - Maintenance tunnels

## Example Use Cases

### Space Mall Example

**Parent Ruin**: A mall structure with empty shop spaces

**Modular Markers**: 
- 6 shop spaces with `forced_category = MODULAR_ROOM_SHOP`
- 2 hallway connectors with `forced_category = MODULAR_ROOM_HALLWAY`
- 1 security office with traits: `faction_nanotrasen`, `theme_military`

**Result**: Each time the mall spawns, it has different shops! Maybe a weapon shop, general store, and clothing shop one time. Next time it could be a bar, electronics store, and abandoned shop with zombies.

### Syndicate Station Example

**Parent Ruin**: Syndicate base layout

**Modular Markers**: All have `required_traits = list(MODULAR_FACTION_SYNDICATE)`

**Modular Rooms**: Only Syndicate-themed rooms (armory, barracks, command) can spawn

**Result**: Guarantees faction-appropriate rooms while still having variety

### Abandoned Facility Example

**Parent Ruin**: Derelict station

**Modular Markers**: Mix of traits like `enemy_zombies`, `enemy_spiders`, `env_damaged`

**Modular Rooms**: Various abandoned/damaged versions with different enemy types

**Result**: Each visit has different dangers and loot

## File Structure

```
_maps/
	ModularRuins/		  <- Your modular room .dmm files
		hallways/
			hallway_standard_5x10.dmm
			hallway_damaged_5x10.dmm
		shops/
			shop_general_6x6.dmm
			shop_weapons_6x6.dmm
		small/
			storage_5x5.dmm
			medical_5x5.dmm
		medium/
			syndicate_armory_10x10.dmm
			cargo_bay_10x10.dmm
	PentestRuins/
		SpaceRuins/
			spacemall.dmm   <- Your parent modular ruin

modular_pentest/
	modules/
		moodular_ruins/
			ruins/
				catagory/
					example_modular_rooms.dm  <- Room datum definitions
```

## Tips and Best Practices

1. **Size Must Match**: Room's `room_size` variable MUST match the marker's `required_size` exactly (as strings)
2. **Use Plain Strings**: No DEFINE needed - just write `room_size = "6x7"` directly
3. **Test First**: Place rooms manually to ensure they work before making them modular
4. **Trait Variety**: Create multiple rooms with the same size but different traits for variety
5. **Weight Balance**: Use `selection_weight` to make interesting rooms appear more often
6. **Edge Cases**: Handle empty/failed placements gracefully - the system replaces failed markers with plating
7. **Logging**: Check logs with "MODULAR RUIN:" to debug placement issues
8. **Always Use `/area/template_noop`**: NEVER use hardcoded areas like `/area/ruin/beach` or `/area/space` in modular room DMMs - they break reusability and prevent proper area inheritance
9. **NOOP Dimensions**: When using NOOP tiles, specify functional size in `room_size`, not .dmm dimensions

## Debugging

If rooms aren't spawning:

1. Check logs for "MODULAR RUIN:" messages
2. Verify room `room_size` matches marker `required_size` exactly (both as strings)
3. Check that room traits are compatible with marker traits
4. Ensure the parent ruin has `this_ruin_uses_modular_rooms = TRUE`
5. Verify room mappath is correct and file exists
6. Confirm modular room DMMs use `/area/template_noop` (not hardcoded areas)

### Testing Individual Modular Rooms

To test a specific modular room without randomization, use the `forced_template` variable on your marker:

```dm
// In your map editor, set the marker's variables:
/obj/effect/landmark/modular_marker/shop{
	forced_template = /datum/map_template/modular_room/shop/my_test_shop;
	required_size = "6x6"
}
```

This bypasses all trait checking and selection logic, forcing that exact room to spawn. Perfect for:
- Testing a new modular room design
- Debugging specific room issues
- Creating demo/preview ruins
- Guaranteeing specific layouts for story purposes

**Note:** When `forced_template` is set, the marker ignores:
- `placement_traits` - No compatibility checking
- `forced_category` - Category doesn't matter
- `selection_weight` - No random selection
- `allow_duplicates` - Will place even if already used

### Force Spawning Ruins for Testing

**Admin Method (In-Game):**
1. Have admin permissions (R_ADMIN and R_SPAWN)
2. Use the admin verb: **Event → Overmap → Spawn Planet/Ruin**
3. Select planet type
4. Select ruin type (RUINTYPE_SPACE for space ruins like spacemall)
5. Choose "Forced" instead of "Random"
6. Select your specific ruin from the list
7. Choose Random spawn location
8. Force Admin load so that the map loads now

This will spawn the ruin with all its modular rooms processed.

**Debug Logging:**
All modular room placement is logged with "MODULAR RUIN:" prefix. Check your logs to see:
- Which markers were found
- Which rooms were selected
- Success/failure of placements
- When duplicates were forced

## Future Expansion Ideas

- Add more size variants (rectangular rooms, odd shapes)
- Implement "room sets" that spawn together
- Add connectivity requirements for hallways
- Support for multi-z-level modular rooms
- Dynamic enemy spawning based on traits
- Procedural loot placement within rooms
