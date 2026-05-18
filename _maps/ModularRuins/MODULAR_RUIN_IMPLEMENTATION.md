# Modular Ruin System - Implementation Summary

## What Has Been Created

A complete modular ruin system has been implemented that allows ruins to dynamically select and place rooms from a pool of templates based on traits and requirements.

## Files Created

### Core System Files

1. **`code/__DEFINES/modular_ruins.dm`**
   - All trait constants and definitions
   - Room categories, sizes, factions, enemy types, danger levels, themes, etc.

2. **`code/datums/ruins/modular/_modular_rooms.dm`**
   - Base `/datum/map_template/modular_room` class
   - Trait compatibility checking system
   - Door connection scanning system
   - Post-load hooks for custom room behavior

3. **`code/datums/ruins/modular/_modular_connections.dm`**
   - Connection landmark definitions
   - `/obj/effect/landmark/modular_connection/parent_door` - Parent ruin door markers
   - `/obj/effect/landmark/modular_connection/door` - Modular room door markers
   - Helper functions for coordinate-based position strings

4. **`code/datums/ruins/modular/_modular_processing.dm`**
   - Extensions to `/datum/map_template/ruin` for modular support
   - `process_modular_rooms()` function that runs after ruin placement
   - Door marker detection and cleanup
   - Global tracking lists

5. **`code/game/turf/modular_marker.dm`**
   - `/obj/effect/landmark/modular_marker` placement landmark
   - `/area/ruin/modular_placeholder` areas
   - Room selection and placement logic
   - Door connection compatibility checking with ±1 offset tolerance
   - Variant markers (small, medium, hallway, shop)

### Integration

5. **`code/controllers/subsystem/mapping.dm`** (modified)
   - Added `modular_room_templates` list to track available rooms
   - Added `preloadModularRoomTemplates()` function
   - Integrated into initialization sequence

6. **`code/controllers/subsystem/overmap.dm`** (modified)
   - Added modular room processing call after ruin placement
   - Integrated into `spawn_dynamic_encounter()` function

### Examples and Documentation

7. **`code/datums/ruins/modular/_TEMPLATE_ROOMS.dm`**
   - Example room definitions for various categories
   - Demonstrates trait usage, required/forbidden traits
   - Shows different room sizes and themes

8. **`_maps/ModularRuins/MODULAR_RUINS_GUIDE.md`**
   - Comprehensive documentation
   - Step-by-step tutorials
   - Examples and best practices

9. **Example Map Files**
    - `_maps/ModularRuins/small/storage_5x5.dmm`
    - `_maps/ModularRuins/hallways/hallway_standard_5x10.dmm`
    - `_maps/ModularRuins/shops/shop_general_1_6x6.dmm`

## How It Works

### Phase 1: Initialization
- Server starts
- Mapping subsystem loads all modular room templates
- Rooms are categorized and stored in `SSmapping.modular_room_templates`

### Phase 2: World Generation
- Planet generates terrain (existing system)
- Ruin is selected and placed normally (existing system)

### Phase 3: Modular Processing (NEW)
- After ruin placement, system checks if ruin has `this_ruin_uses_modular_rooms = TRUE`
- If yes, searches for modular placement markers within the ruin
- For each marker:
  1. Gets the marker's traits and size requirements
  2. Finds all compatible rooms from the template pool
  3. Filters by size, required traits, forbidden traits, and category
  4. Selects a room (randomly weighted or highest weight)
  5. Loads the room template at the marker location
  6. Cleans up the marker

### Phase 4: Turf Population
- Planet terrain population continues as normal (existing system)

## Key Features

### Trait System
- **Required Traits**: Room must have ALL of these to be selected
- **Forbidden Traits**: Room cannot have ANY of these to be selected
- **Room Traits**: Descriptive tags that define the room
- **Placement Traits**: Tags on the marker that filter compatible rooms

### Flexible Sizing
- Support for square rooms (3x3, 5x5, 6x6, 7x7, 10x10)
- Support for rectangular rooms (5x10, 10x5, 6x7, 8x4, etc.)
- Easy to add custom sizes - just use the dimensions as a string (e.g., `room_size = "7x9"`)
- No DEFINE needed - room_size is a dedicated variable

### Door Connection Validation (NEW)
- **Coordinate-based matching system** - Parent ruins and modular rooms use coordinate markers for door alignment
- **Automatic offset detection** - Rooms are matched if their doors are within ±1 tile orthogonally
- **Manual landmark placement** - Mappers place door markers in both parent ruins and modular room templates
- **Prevents door misalignment** - Rooms without properly aligned doors are automatically filtered out
- **Flexible positioning** - Works with doors on any edge (north, south, east, west) or interior positions

### Weight-Based Selection
- Rooms have selection weights (higher = more likely)
- Can force random selection or pick highest weight
- Can prevent duplicates per ruin

### Category Enforcement
- Markers can force specific room categories
- Ensures hallways get hallways, shops get shops, etc.

### Faction Support
- Rooms can require specific factions
- Prevents mismatched themes (e.g., NT office in Syndie base)

## Next Steps

To fully utilize this system:

1. **Create More Modular Rooms**
   - Make various shops for malls
   - Create different hallway styles
   - Design faction-specific rooms

2. **Create Modular Parent Ruins**
   - Design "shell" ruins with modular markers
   - Space malls, apartment complexes, office buildings
   - Abandoned stations with modular sections

3. **Test and Balance**
   - Ensure room `room_size` variables match marker `required_size` exactly
   - Balance loot and enemy difficulty
   - Adjust selection weights based on gameplay

4. **Expand the System**
   - Add more trait types as needed
   - Create specialized marker variants
   - Implement room "sets" that spawn together

## Troubleshooting

Check the game logs for messages starting with "MODULAR RUIN:" to debug placement issues.

### Debug Logging

**Verbose Connection Debugging:**
- Use the admin verb: `Debug > Mapping > Toggle Modular Connections Debug`
- When enabled, logs every single room check during door connection validation
- Shows exactly why each room was accepted or rejected
- **WARNING:** Generates significant log output - use only when debugging specific issues
- Default: OFF (for production performance)

Common issues:
- **Room not spawning**: room_size doesn't match marker required_size, or incompatible traits
- **Wrong room spawning**: Adjust selection weights or add required/forbidden traits
- **Errors on load**: Check mappath is correct and file exists
- **Door connections not working**: Enable debug logging to see coordinate matching details

## Area Inheritance System

**CRITICAL: All modular room DMMs must use `/area/template_noop`**

When a modular room is loaded, the area system preserves the parent ruin's area:

1. **Parent Ruin**: Places modular marker in its specific area (e.g., `/area/ruin/space/has_grav/spacemall/shop`)
2. **Modular Room DMM**: Uses `/area/template_noop` for all turfs
3. **Map Loading**: The system skips loading `/area/template_noop`, leaving turfs in the parent's area
4. **Result**: Modular room inherits the parent area at the placement location

**Why This Matters:**

- **Reusability**: Same bedroom can work in space mall dorms, beach resort rooms, or pirate ship quarters
- **Power Systems**: APCs in parent area power the modular rooms correctly
- **Atmospherics**: Area-based air systems work across the entire combined space
- **APC Connectivity**: Devices in modular rooms connect to parent area's APC

**Example:**

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

**Converting Existing Rooms:**

If you have modular rooms with hardcoded areas like `/area/ruin/beach` or `/area/space`, convert them:

```powershell
# Use the provided conversion script
powershell -ExecutionPolicy Bypass -File .\tools\convert_modular_rooms_to_template_noop.ps1
```

This script automatically replaces all hardcoded area paths with `/area/template_noop` in your modular room DMMs.

**For New Mappers:**

Always use `/area/template_noop` when creating modular room DMMs. Never use specific areas like `/area/ruin/beach` or `/area/space` - these lock your room to specific parent ruins and break reusability.

## Performance Considerations

- Room templates are cached at server start (one-time cost)
- Marker processing happens once per ruin placement
- No ongoing runtime performance impact
- Minimal memory footprint (templates reused)

## Compatibility

This system integrates with existing code without breaking changes:
- Existing ruins work normally
- Only ruins with `this_ruin_uses_modular_rooms = TRUE` use the new system
- No changes required to existing map generation
- Fully compatible with all ruin types (space, lava, ice, etc.)
