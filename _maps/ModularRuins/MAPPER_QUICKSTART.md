# Modular Ruin System - Quick Reference for Mappers

## Setting Up a Modular Parent Ruin (In Map Editor)

### Step 1: Create Your Main Structure
Create your ruin map file normally with walls, basic structure, and layout.

### Step 2: Paint Visual Guides (Optional but Recommended)

Paint the exact room footprint with visual guide turfs to see where rooms will spawn:

| Visual Guide | What it shows |
|--------------|---------------|
| `/turf/open/floor/modular_guide` | Purple tiles showing room footprint |

**These are purely visual!** They get completely replaced when the room loads.

### Step 3: Place Modular Markers

Place ONE marker landmark at the **bottom-left corner** of each room space:

| Marker Type | Size | Best For |
|-------------|------|----------|
| `/obj/effect/landmark/modular_marker/small` | 5x5 | Storage, small offices, closets |
| `/obj/effect/landmark/modular_marker/medium` | 10x10 | Major rooms, labs, armories |
| `/obj/effect/landmark/modular_marker/hallway` | 5x10 | Connecting corridors |
| `/obj/effect/landmark/modular_marker/shop` | 6x6 | Commercial spaces |

### Step 4: Add Door Connection Markers (Optional)

If you want rooms to align with specific doors in your parent ruin, place door connection markers:

**In parent ruin:** Place `/obj/effect/landmark/modular_connection/parent_door` at each door tile

**In modular rooms:** Place `/obj/effect/landmark/modular_connection/door` at connection points

The system uses coordinate-based matching (X,Y from bottom-left) and accepts ±1 tile offset tolerance (orthogonal only).

**Example:** Parent door at (5,4) will match modular room doors at: (5,3), (5,5), (4,4), (6,4) ✅
Will NOT match: (5,4) exact, (6,5) diagonal, (7,4) too far ❌

See full guide for detailed explanation and examples.

### Step 5: Placeholder Area (Optional)

You can optionally surround marker regions with:
```
/area/ruin/modular_placeholder
```
This helps organize your map but is NOT required for the system to work.

### Step 6: Configure Marker Traits (Optional)

Click on the marker landmark and edit its properties:

```dm
placement_traits = list(MODULAR_FACTION_NANOTRASEN, MODULAR_ENEMY_ZOMBIES, MODULAR_DANGER_MEDIUM)
forced_category = MODULAR_ROOM_SHOP  // Forces only shops to spawn here
random_selection = TRUE   // Picks randomly (vs highest weight)
```

**Testing a Specific Room:**
```dm
forced_template = /datum/map_template/modular_room/shop/my_test_shop  // Force this exact room (for testing)
```

## Creating Modular Room Definitions (Code)

### Parent Types vs Actual Rooms

When creating room datums, use `abstract_type` for parent categories that don't have actual map files:

```dm
// Parent type - NO mappath, just shared variables
/datum/map_template/modular_room/my_category
	name = "My Category Base"
	abstract_type = /datum/map_template/modular_room/my_category  // Prevents this from loading!
	room_category = MODULAR_ROOM_MYCATEGORY
	selection_weight = 10

// Actual room - HAS mappath, will be loaded
/datum/map_template/modular_room/my_category/actual_room
	name = "Actual Room"
	mappath = "_maps/ModularRuins/myroom.dmm"  // This one loads!
	room_size = "5x5"  // Specify functional size as string
	room_traits = list(
		MODULAR_FACTION_INDEPENDENT,
		MODULAR_ENEMY_NONE
	)
```

**Why?** Without `abstract_type`, the parent will try to load (and fail because it has no mappath).

## Common Trait Combinations

### Safe Commercial Shop
```dm
placement_traits = list(
	MODULAR_FACTION_INDEPENDENT,
	MODULAR_THEME_COMMERCIAL, 
	MODULAR_ENEMY_NONE,
	MODULAR_LOOT_MEDIUM
)
forced_category = MODULAR_ROOM_SHOP
```

### Dangerous Syndicate Room
```dm
placement_traits = list(
	MODULAR_FACTION_SYNDICATE,
	MODULAR_THEME_MILITARY,
	MODULAR_ENEMY_SYNDICATE, 
	MODULAR_DANGER_HIGH,
	MODULAR_LOOT_MAJOR
)
```

### Abandoned Maintenance
```dm
placement_traits = list(
	MODULAR_FACTION_INDEPENDENT,
	MODULAR_THEME_ABANDONED,
	MODULAR_ENEMY_SPIDERS,
	MODULAR_ENV_DAMAGED,
	MODULAR_DANGER_MINOR
)
forced_category = MODULAR_ROOM_MAINTENANCE
```

### Clean Medical Bay
```dm
placement_traits = list(
	MODULAR_FACTION_NANOTRASEN,
	MODULAR_THEME_CIVILIAN,
	MODULAR_ENEMY_NONE,
	MODULAR_ENV_PRISTINE,
	MODULAR_LOOT_MEDIUM
)
forced_category = MODULAR_ROOM_MEDICAL
```

## Available Traits (Short List - List might not be complete. Check modular_ruins.dm for complete active list)

**Room Size:** Specified using `room_size = "WIDTHxHEIGHT"` variable (e.g., `"5x5"`, `"6x7"`, `"10x10"`, `"14x14"`)
- **NOT a trait** - size is a dedicated variable
- Can use any dimensions as a plain string (no DEFINE needed)
- Must match marker's `required_size` exactly
- Handles NOOP tiles properly (specify functional size, not .dmm dimensions)

**Factions:** `MODULAR_FACTION_NANOTRASEN`, `MODULAR_FACTION_SYNDICATE`, `MODULAR_FACTION_INDEPENDENT`, `MODULAR_FACTION_PIRATE`

**Enemies:** `MODULAR_ENEMY_NONE`, `MODULAR_ENEMY_ZOMBIES`, `MODULAR_ENEMY_SPIDERS`, `MODULAR_ENEMY_SYNDICATE`, `MODULAR_ENEMY_WILDLIFE`

**Danger:** `MODULAR_DANGER_SAFE`, `MODULAR_DANGER_MINOR`, `MODULAR_DANGER_MEDIUM`, `MODULAR_DANGER_HIGH`, `MODULAR_DANGER_EXTREME`

**Themes:** `MODULAR_THEME_MILITARY`, `MODULAR_THEME_CIVILIAN`, `MODULAR_THEME_INDUSTRIAL`, `MODULAR_THEME_RESEARCH`, `MODULAR_THEME_COMMERCIAL`, `MODULAR_THEME_ABANDONED`

**Environment:** `MODULAR_ENV_POWERED`, `MODULAR_ENV_UNPOWERED`, `MODULAR_ENV_DAMAGED`, `MODULAR_ENV_PRISTINE`, `MODULAR_ENV_VACUUM`, `MODULAR_ENV_BREATHABLE`

**Loot:** `MODULAR_LOOT_NONE`, `MODULAR_LOOT_MINOR`, `MODULAR_LOOT_MEDIUM`, `MODULAR_LOOT_MAJOR`

## Example: Creating a Modular Mall

```
1. Create outer mall structure (walls, main corridor)
2. Create 6 empty shop spaces (6x6 each)
3. Paint each 6x6 space with /turf/open/floor/modular_guide (visual aid)
4. Place /obj/effect/landmark/modular_marker/shop at bottom-left of each space
5. (Optional) Place /obj/effect/landmark/modular_connection/parent_door at door tiles for shop entrances
6. Add traits like:
   - Shop 1-3: MODULAR_FACTION_INDEPENDENT, MODULAR_LOOT_MEDIUM
   - Shop 4: MODULAR_FACTION_SYNDICATE, MODULAR_ENEMY_SYNDICATE (Syndicate takeover!)
   - Shop 5-6: MODULAR_ENEMY_ZOMBIES, MODULAR_ENV_DAMAGED (Infected areas)
7. Create 2 hallway connections (5x10 each)
8. Paint with /turf/open/floor/modular_guide
9. Place /obj/effect/landmark/modular_marker/hallway at bottom-left of each
10. (Optional) Mark areas with /area/ruin/modular_placeholder for organization
11. Save map file
```

## Enabling Modular System (In Code)

In your ruin's datum definition:

```dm
/datum/map_template/ruin/space/my_modular_ruin
	name = "My Modular Ruin"
	id = "my_ruin_id"
	suffix = "my_ruin.dmm"
	this_ruin_uses_modular_rooms = TRUE	// <- ADD THIS LINE
	ruin_type = RUINTYPE_SPACE
```

## Testing

1. Load your ruin via admin tools
2. Check logs for "MODULAR RUIN:" messages
3. Verify rooms spawned correctly
4. Adjust traits/weights as needed

## Tips

- **Leave space!** Make sure there's exactly enough room for the specified size
- **Don't overlap** - Markers should not be adjacent (leave at least 1 tile between)
- **Test manually first** - Load modular rooms manually to test before making them random
- **Use varied traits** - More specific traits = more control over what spawns
- **Check the logs** - They'll tell you exactly why a room didn't spawn

## Troubleshooting Checklist

**Nothing spawns when I load my ruin? Check these in order:**

1. ✅ **Is the parent ruin marked as modular?**
   - In your ruin datum code, check for: `this_ruin_uses_modular_rooms = TRUE`
   - **This is the #1 most common issue!** The system won't even look for markers without this flag.

2. ✅ **Are the modular room .dmm files in the correct location?**
   - Files should be in `_maps/ModularRuins/[category]/`
   - Check the `mappath` in your room datum matches the actual file location

3. ✅ **Are the room datums registered?**
   - Room datum files should be included in the codebase
   - Check that your `.dm` file with room definitions is being compiled

4. ✅ **Did you place markers correctly?**
   - Markers go at the **bottom-left corner** of the room space
   - Use `/obj/effect/landmark/modular_marker/*` (not turfs!)
   - Only ONE marker per room space

5. ✅ **Do the room sizes match?**
   - Marker's `required_size` must match the room's `room_size` variable
   - Room `room_size` should reflect functional dimensions (may differ from .dmm if using NOOP)
   - Example: Marker has `required_size = "9x6"`, room must have `room_size = "9x6"`

6. ✅ **Are traits compatible?**
   - If using `placement_traits`, rooms must pass compatibility check
   - If using `forced_category`, rooms must have that category
   - If using `approved_rooms`, room types must be in that list
   - Try removing all optional filters first to test

7. ✅ **Check the logs!**
   - Search for "MODULAR RUIN:" in your game logs
   - Logs will tell you: markers found, rooms selected, why rooms failed to spawn

**Quick Test Method:**
```dm
// Use forced_template to bypass all filtering and test a specific room
/obj/effect/landmark/modular_marker{
	forced_template = /datum/map_template/modular_room/shuttles/prop_shuttle_9x6_v1
}
```
If this works but normal selection doesn't, your issue is with trait compatibility or filtering.

## Need More Help?

See the full guide: `_maps/ModularRuins/MODULAR_RUINS_GUIDE.md`
