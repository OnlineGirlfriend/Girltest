//Command

/obj/item/circuitboard/machine/bsa/back
	name = "Bluespace Artillery Generator (Machine Board)"
	icon_state = "command"
	build_path = /obj/machinery/bsa/back //No freebies!
	req_components = list(
		/obj/item/stock_parts/capacitor/quadratic = 5,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/bsa/front
	name = "Bluespace Artillery Bore (Machine Board)"
	icon_state = "command"
	build_path = /obj/machinery/bsa/front
	req_components = list(
		/obj/item/stock_parts/manipulator/femto = 5,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/bsa/middle
	name = "Bluespace Artillery Fusor (Machine Board)"
	icon_state = "command"
	build_path = /obj/machinery/bsa/middle
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 20,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/dna_vault
	name = "DNA Vault (Machine Board)"
	icon_state = "command"
	build_path = /obj/machinery/dna_vault //No freebies!
	req_components = list(
		/obj/item/stock_parts/capacitor/super = 5,
		/obj/item/stock_parts/manipulator/pico = 5,
		/obj/item/stack/cable_coil = 2)

//Engineering

/obj/item/circuitboard/machine/announcement_system
	name = "Announcement System (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/announcement_system
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/autolathe
	name = "Autolathe (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/autolathe
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/grounding_rod
	name = "Grounding Rod (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/grounding_rod
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE


/obj/item/circuitboard/machine/telecomms/broadcaster
	name = "Subspace Broadcaster (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/broadcaster
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/telecomms/bus
	name = "Bus Mainframe (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/bus
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/telecomms/hub
	name = "Hub Mainframe (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/hub
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 2)

/obj/item/circuitboard/machine/telecomms/message_server
	name = "Messaging Server (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/message_server
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 3)

/obj/item/circuitboard/machine/telecomms/processor
	name = "Processor Unit (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/processor
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 2,
		/obj/item/stock_parts/subspace/analyzer = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/amplifier = 1)

/obj/item/circuitboard/machine/telecomms/receiver
	name = "Subspace Receiver (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/receiver
	req_components = list(
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/telecomms/relay
	name = "Relay Mainframe (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/relay
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 2)

/obj/item/circuitboard/machine/telecomms/server
	name = "Telecommunication Server (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/telecomms/server
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/tesla_coil
	name = "Tesla Controller (Machine Board)"
	icon_state = "engineering"
	desc = "You can use a screwdriver to switch between Research and Power Generation."
	build_path = /obj/machinery/power/tesla_coil
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

#define PATH_POWERCOIL /obj/machinery/power/tesla_coil/power
#define PATH_RPCOIL /obj/machinery/power/tesla_coil/research

/obj/item/circuitboard/machine/tesla_coil/Initialize()
	. = ..()
	if(build_path)
		build_path = PATH_POWERCOIL

/obj/item/circuitboard/machine/tesla_coil/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/obj/item/circuitboard/new_type
		var/new_setting
		switch(build_path)
			if(PATH_POWERCOIL)
				new_type = /obj/item/circuitboard/machine/tesla_coil/research
				new_setting = "Research"
			if(PATH_RPCOIL)
				new_type = /obj/item/circuitboard/machine/tesla_coil/power
				new_setting = "Power"
		name = initial(new_type.name)
		build_path = initial(new_type.build_path)
		I.play_tool_sound(src)
		to_chat(user, span_notice("You change the circuitboard setting to \"[new_setting]\"."))
	else
		return ..()

/obj/item/circuitboard/machine/tesla_coil/power
	name = "Tesla Coil (Machine Board)"
	build_path = PATH_POWERCOIL

/obj/item/circuitboard/machine/tesla_coil/research
	name = "Tesla Corona Researcher (Machine Board)"
	build_path = PATH_RPCOIL

#undef PATH_POWERCOIL
#undef PATH_RPCOIL

/obj/item/circuitboard/machine/tesla_ground
	name = "Tesla Ground (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/tesla_coil/tesla_ground
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = TRUE

/obj/item/circuitboard/machine/cell_charger
	name = "Cell Charger (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/cell_charger
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/circulator
	name = "Circulator/Heat Exchanger (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/atmospherics/components/binary/circulator
	var/pipe_layer = PIPING_LAYER_DEFAULT
	req_components = list()

/obj/item/circuitboard/machine/circulator/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		pipe_layer = (pipe_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (pipe_layer + 1)
		to_chat(user, span_notice("You change the circuitboard to layer [pipe_layer]."))
		return

/obj/item/circuitboard/machine/circulator/examine()
	. = ..()
	. += span_notice("It is set to layer [pipe_layer].")

/obj/item/circuitboard/machine/emitter
	name = "Emitter (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/emitter
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/generator
	name = "Thermo-Electric Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/generator
	req_components = list()

/obj/item/circuitboard/machine/ntnet_relay
	name = "NTNet Relay (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/ntnet_relay
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 1)

/obj/item/circuitboard/machine/pacman
	name = "PACMAN-type Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/port_gen/pacman
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/pacman/super
	name = "SUPERPACMAN-type Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/port_gen/pacman/super

/obj/item/circuitboard/machine/pacman/mrs
	name = "MRSPACMAN-type Generator (Machine Board)"
	build_path = /obj/machinery/power/port_gen/pacman/mrs

/obj/item/circuitboard/machine/power_compressor
	name = "Power Compressor (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/compressor
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/manipulator = 6)

/obj/item/circuitboard/machine/power_turbine
	name = "Power Turbine (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/shuttle/engine/turbine
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 6)

/obj/item/circuitboard/machine/protolathe/department/engineering
	name = "Protolathe (Machine Board) - Engineering"
	icon_state = "engineering"
	build_path = /obj/machinery/rnd/production/protolathe/department/engineering

/obj/item/circuitboard/machine/rad_collector
	name = "Radiation Collector (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/rad_collector
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/sheet/plasmarglass = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/rtg
	name = "RTG (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/rtg
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stack/sheet/mineral/uranium = 10) // We have no Pu-238, and this is the closest thing to it.

/obj/item/circuitboard/machine/rtg/advanced
	name = "Advanced RTG (Machine Board)"
	build_path = /obj/machinery/power/rtg/advanced
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/mineral/uranium = 10,
		/obj/item/stack/sheet/mineral/plasma = 5)

/obj/item/circuitboard/machine/rtg/geothermal
	name = "Geothermal Power Tap"
	build_path = /obj/machinery/power/rtg/geothermal
	req_components = list(
	/obj/item/pickaxe/drill = 1,
	/obj/item/stack/cable_coil = 10,
	/obj/item/stock_parts/capacitor = 2,
	/obj/item/stock_parts/micro_laser = 1,
	/obj/item/stock_parts/manipulator = 4)

/obj/item/circuitboard/machine/scanner_gate
	name = "Scanner Gate (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/scanner_gate
	req_components = list(
		/obj/item/stock_parts/scanning_module = 3)

/obj/item/circuitboard/machine/smes
	name = "SMES (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/smes
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/cell = 5,
		/obj/item/stock_parts/capacitor = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high/empty)

/obj/item/circuitboard/machine/techfab/department/engineering
	name = "\improper Departmental Techfab (Machine Board) - Engineering"
	build_path = /obj/machinery/rnd/production/techfab/department/engineering

/obj/item/circuitboard/machine/thermomachine
	name = "Thermomachine (Machine Board)"
	icon_state = "engineering"
	desc = "You can use a screwdriver to switch between heater and freezer."
	var/pipe_layer = PIPING_LAYER_DEFAULT
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1)

#define PATH_FREEZER /obj/machinery/atmospherics/components/unary/thermomachine/freezer
#define PATH_HEATER /obj/machinery/atmospherics/components/unary/thermomachine/heater

/obj/item/circuitboard/machine/thermomachine/Initialize()
	. = ..()
	if(!build_path)
		if(prob(50))
			name = "Freezer (Machine Board)"
			build_path = PATH_FREEZER
		else
			name = "Heater (Machine Board)"
			build_path = PATH_HEATER

/obj/item/circuitboard/machine/thermomachine/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/obj/item/circuitboard/new_type
		var/new_setting
		switch(build_path)
			if(PATH_FREEZER)
				new_type = /obj/item/circuitboard/machine/thermomachine/heater
				new_setting = "Heater"
			if(PATH_HEATER)
				new_type = /obj/item/circuitboard/machine/thermomachine/freezer
				new_setting = "Freezer"
		name = initial(new_type.name)
		build_path = initial(new_type.build_path)
		I.play_tool_sound(src)
		to_chat(user, span_notice("You change the circuitboard setting to \"[new_setting]\"."))
		return

	if(I.tool_behaviour == TOOL_MULTITOOL)
		pipe_layer = (pipe_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (pipe_layer + 1)
		to_chat(user, span_notice("You change the circuitboard to layer [pipe_layer]."))
		return

	. = ..()

/obj/item/circuitboard/machine/thermomachine/examine()
	. = ..()
	. += span_notice("It is set to layer [pipe_layer].")

/obj/item/circuitboard/machine/thermomachine/heater
	name = "Heater (Machine Board)"
	build_path = PATH_HEATER

/obj/item/circuitboard/machine/thermomachine/freezer
	name = "Freezer (Machine Board)"
	build_path = PATH_FREEZER

/obj/item/circuitboard/machine/ship_gravity
	name = "Gravity Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/ship_gravity
	req_components = list(
		/obj/item/stock_parts/capacitor = 5,
		/obj/item/stack/sheet/bluespace_crystal = 1,
		/obj/item/stock_parts/micro_laser = 4
		)
	needs_anchored = FALSE

#undef PATH_FREEZER
#undef PATH_HEATER

/obj/item/circuitboard/machine/shieldwallgen
	name = "Shieldwall Generator (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/power/shieldwallgen
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stack/sheet/plasmaglass = 1,
		/obj/item/stack/cable_coil = 5
		)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/shieldwallgen/atmos
	name = "Atmospheric Holofield Generator (Machine Board)"
	build_path = /obj/machinery/power/shieldwallgen/atmos

/obj/item/circuitboard/machine/shieldwallgen/atmos/strong
	name = "High Power Atmospheric Holofield Generator (Machine Board)"
	build_path = /obj/machinery/power/shieldwallgen/atmos/strong
	req_components = list(
		/obj/item/stock_parts/manipulator/nano = 2,
		/obj/item/stock_parts/micro_laser/high = 2,
		/obj/item/stock_parts/capacitor/adv = 2,
		/obj/item/stack/sheet/plasmaglass = 1,
		/obj/item/stack/cable_coil = 5,
	)


/obj/item/circuitboard/machine/pipedispenser
	name = "Pipe dispenser (Machine Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/pipedispenser
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 1)

//Generic

/obj/item/circuitboard/machine/circuit_imprinter
	name = "Circuit Imprinter (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/rnd/production/circuit_imprinter
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/reagent_containers/glass/beaker = 2)

/obj/item/circuitboard/machine/circuit_imprinter/department
	name = "Departmental Circuit Imprinter (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department

/obj/item/circuitboard/machine/circuit_imprinter/department/cargo
	name = "Circuit Imprinter (M.I.D.A.S)"
	icon_state = "supply"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/cargo

/obj/item/circuitboard/machine/circuit_imprinter/department/engi
	name = "Circuit Imprinter (A.T.L.A.S)"
	icon_state = "engineering"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/engi

/obj/item/circuitboard/machine/circuit_imprinter/department/med
	name = "Circuit Imprinter (C.A.R.E)"
	icon_state = "medical"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/med

/obj/item/circuitboard/machine/circuit_imprinter/department/sec
	name = "Circuit Imprinter (P.E.A.C.E)"
	icon_state = "security"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/sec

/obj/item/circuitboard/machine/circuit_imprinter/department/civ
	name = "Circuit Imprinter (H.O.M.E)"
	icon_state = "service"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/civ

/obj/item/circuitboard/machine/circuit_imprinter/department/basic
	name = "Circuit Imprinter (B.A.S.I.C)"
	icon_state = "generic"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/basic

/obj/item/circuitboard/machine/holopad
	name = "AI Holopad (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/holopad
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE //wew lad
	var/secure = FALSE

/obj/item/circuitboard/machine/holopad/attackby(obj/item/P, mob/user, params)
	if(P.tool_behaviour == TOOL_MULTITOOL)
		if(secure)
			build_path = /obj/machinery/holopad
			secure = FALSE
		else
			build_path = /obj/machinery/holopad/secure
			secure = TRUE
		to_chat(user, span_notice("You [secure? "en" : "dis"]able the security on the [src]"))
	. = ..()

/obj/item/circuitboard/machine/holopad/examine(mob/user)
	. = ..()
	. += "There is a connection port on this board that could be <b>pulsed</b>"
	if(secure)
		. += "There is a red light flashing next to the word \"secure\""

/obj/item/circuitboard/machine/launchpad
	name = "Bluespace Launchpad (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/launchpad
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stock_parts/manipulator = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/paystand
	name = "Pay Stand (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/paystand
	req_components = list()

/obj/item/circuitboard/machine/protolathe
	name = "Protolathe (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/rnd/production/protolathe
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_containers/glass/beaker = 2)

/obj/item/circuitboard/machine/protolathe/department
	name = "Departmental Protolathe (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/rnd/production/protolathe/department

/obj/item/circuitboard/machine/protolathe/department/basic
	name = "Protolathe (Basic)"
	icon_state = "generic"
	build_path = /obj/machinery/rnd/production/protolathe/department/basic

/obj/item/circuitboard/machine/reagentgrinder
	name = "Machine Design (All-In-One Grinder)"
	icon_state = "generic"
	build_path = /obj/machinery/reagentgrinder/constructed
	req_components = list(
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/smartfridge
	name = "Smartfridge (Machine Board)"
	build_path = /obj/machinery/smartfridge
	req_components = list(/obj/item/stock_parts/matter_bin = 1)
	var/static/list/fridges_name_paths = list(/obj/machinery/smartfridge = "plant produce",
		/obj/machinery/smartfridge/food = "food",
		/obj/machinery/smartfridge/drinks = "drinks",
		/obj/machinery/smartfridge/bloodbank = "blood",
		/obj/machinery/smartfridge/organ = "organs",
		/obj/machinery/smartfridge/chemistry = "chems",
		/obj/machinery/smartfridge/chemistry/virology = "viruses",
		/obj/machinery/smartfridge/disks = "disks", /obj/machinery/smartfridge/extract = "slimes") //PENTEST ADDITION - XENOBIOLOGY
	needs_anchored = FALSE

/obj/item/circuitboard/machine/smartfridge/Initialize(mapload, new_type)
	if(new_type)
		build_path = new_type
	return ..()

/obj/item/circuitboard/machine/smartfridge/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/position = fridges_name_paths.Find(build_path, fridges_name_paths)
		position = (position == fridges_name_paths.len) ? 1 : (position + 1)
		build_path = fridges_name_paths[position]
		to_chat(user, span_notice("You set the board to [fridges_name_paths[build_path]]."))
	else
		return ..()

/obj/item/circuitboard/machine/smartfridge/examine(mob/user)
	. = ..()
	. += span_info("[src] is set to [fridges_name_paths[build_path]]. You can use a screwdriver to reconfigure it.")


/obj/item/circuitboard/machine/space_heater
	name = "Space Heater (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/space_heater
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stack/cable_coil = 3)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/techfab
	name = "\improper Techfab (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/rnd/production/techfab
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_containers/glass/beaker = 2)

/obj/item/circuitboard/machine/techfab/department
	name = "\improper Departmental Techfab (Machine Board)"
	build_path = /obj/machinery/rnd/production/techfab/department

/obj/item/circuitboard/machine/vendor
	name = "Custom Vendor (Machine Board)"
	desc = "You can turn the \"brand selection\" dial using a screwdriver."
	custom_premium_price = 100
	build_path = /obj/machinery/vending/custom
	req_components = list(/obj/item/vending_refill/custom = 1)

	var/static/list/vending_names_paths = list(
		/obj/machinery/vending/boozeomat = "Booze-O-Mat",
		/obj/machinery/vending/coffee = "Solar's Best Hot Drinks",
		/obj/machinery/vending/snack = "Getmore Chocolate Corp",
		/obj/machinery/vending/cola = "Robust Softdrinks",
		/obj/machinery/vending/cigarette = "ShadyCigs Deluxe",
		/obj/machinery/vending/games = "\improper Good Clean Fun",
		/obj/machinery/vending/autodrobe = "AutoDrobe",
		/obj/machinery/vending/wardrobe/sec_wardrobe = "SecDrobe",
		/obj/machinery/vending/wardrobe/medi_wardrobe = "MediDrobe",
		/obj/machinery/vending/wardrobe/engi_wardrobe = "EngiDrobe",
		/obj/machinery/vending/wardrobe/atmos_wardrobe = "AtmosDrobe",
		/obj/machinery/vending/wardrobe/cargo_wardrobe = "CargoDrobe",
		/obj/machinery/vending/wardrobe/robo_wardrobe = "RoboDrobe",
		/obj/machinery/vending/wardrobe/science_wardrobe = "SciDrobe",
		/obj/machinery/vending/wardrobe/hydro_wardrobe = "HyDrobe",
		/obj/machinery/vending/wardrobe/curator_wardrobe = "CuraDrobe",
		/obj/machinery/vending/wardrobe/bar_wardrobe = "BarDrobe",
		/obj/machinery/vending/wardrobe/chef_wardrobe = "ChefDrobe",
		/obj/machinery/vending/wardrobe/jani_wardrobe = "JaniDrobe",
		/obj/machinery/vending/wardrobe/law_wardrobe = "LawDrobe",
		/obj/machinery/vending/wardrobe/chap_wardrobe = "ChapDrobe",
		/obj/machinery/vending/wardrobe/chem_wardrobe = "ChemDrobe",
		/obj/machinery/vending/wardrobe/gene_wardrobe = "GeneDrobe",
		/obj/machinery/vending/wardrobe/viro_wardrobe = "ViroDrobe",
		/obj/machinery/vending/clothing = "ClothesMate",
		/obj/machinery/vending/medical = "NanoMed Plus",
		/obj/machinery/vending/wallmed = "NanoMed",
		/obj/machinery/vending/assist  = "Vendomat",
		/obj/machinery/vending/engivend = "Engi-Vend",
		/obj/machinery/vending/hydronutrients = "NutriMax",
		/obj/machinery/vending/hydroseeds = "MegaSeed Servitor",
		/obj/machinery/vending/sustenance = "Sustenance Vendor",
		/obj/machinery/vending/dinnerware = "Plasteel Chef's Dinnerware Vendor",
		/obj/machinery/vending/cart = "PTech",
		/obj/machinery/vending/robotics = "Robotech Deluxe",
		/obj/machinery/vending/engineering = "Robco Tool Maker",
		/obj/machinery/vending/sovietsoda = "BODA",
		/obj/machinery/vending/security = "SecTech",
		/obj/machinery/vending/modularpc = "Deluxe Silicate Selections",
		/obj/machinery/vending/custom = "Custom Vendor")

/obj/item/circuitboard/machine/vendor/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/static/list/display_vending_names_paths
		if(!display_vending_names_paths)
			display_vending_names_paths = list()
			for(var/path in vending_names_paths)
				display_vending_names_paths[vending_names_paths[path]] = path
		var/choice =  input(user,"Choose a new brand","Select an Item") as null|anything in sortList(display_vending_names_paths)
		set_type(display_vending_names_paths[choice])
	else
		return ..()

/obj/item/circuitboard/machine/vendor/proc/set_type(obj/machinery/vending/typepath)
	build_path = typepath
	name = "[vending_names_paths[build_path]] Vendor (Machine Board)"
	req_components = list(initial(typepath.refill_canister) = 1)

/obj/item/circuitboard/machine/vendor/apply_default_parts(obj/machinery/M)
	for(var/typepath in vending_names_paths)
		if(istype(M, typepath))
			set_type(typepath)
			break
	return ..()

/obj/item/circuitboard/machine/vending/donksofttoyvendor
	name = "Donksoft Toy Vendor (Machine Board)"
	build_path = /obj/machinery/vending/donksofttoyvendor
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/vending_refill/donksoft = 1)

/obj/item/circuitboard/machine/vending/syndicatedonksofttoyvendor
	name = "Syndicate Donksoft Toy Vendor (Machine Board)"
	build_path = /obj/machinery/vending/toyliberationstation
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/vending_refill/donksoft = 1)

/obj/item/circuitboard/machine/fax
	name = "Fax Machine"
	build_path = /obj/machinery/fax
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1,)

//Medical

/obj/item/circuitboard/machine/chem_dispenser
	name = "Chem Dispenser (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/chem_dispenser
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		///obj/item/stack/ore/bluespace_crystal/refined = 1, //PENTEST OVERRIDE - MAKING IT A LITTLE CHEAPER
		/obj/item/stock_parts/cell = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_dispenser/abductor
	name = "Reagent Synthesizer (Abductor Machine Board)"
	icon_state = "abductor_mod"
	build_path = /obj/machinery/chem_dispenser/abductor
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_dispenser/fullupgrade
	build_path = /obj/machinery/chem_dispenser/fullupgrade
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/mutagensaltpeter
	build_path = /obj/machinery/chem_dispenser/mutagensaltpeter
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/abductor
	name = "Reagent Synthesizer (Abductor Machine Board)"
	icon_state = "abductor_mod"
	build_path = /obj/machinery/chem_dispenser/abductor
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_heater
	name = "Chemical Heater (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/chem_heater
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/chem_master
	name = "ChemMaster 3000 (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/chem_master
	desc = "You can turn the \"mode selection\" dial using a screwdriver."
	req_components = list(
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_master/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		var/new_name = "ChemMaster"
		var/new_path = /obj/machinery/chem_master

		if(build_path == /obj/machinery/chem_master)
			new_name = "CondiMaster"
			new_path = /obj/machinery/chem_master/condimaster

		build_path = new_path
		name = "[new_name] 3000 (Machine Board)"
		to_chat(user, span_notice("You change the circuit board setting to \"[new_name]\"."))
	else
		return ..()

/obj/item/circuitboard/machine/dnascanner
	name = "DNA Scanner (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/dna_scannernew
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/cryo_tube
	name = "Cryotube (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/atmospherics/components/unary/cryo_cell
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 4)

/obj/item/circuitboard/machine/harvester
	name = "Harvester (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/harvester
	req_components = list(/obj/item/stock_parts/micro_laser = 4)

/obj/item/circuitboard/machine/medical_kiosk
	name = "Medical Kiosk (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/medical_kiosk
	req_components = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/limbgrower
	name = "Limb Grower (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/limbgrower
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/protolathe/department/medical
	name = "Protolathe (Machine Board) - Medical"
	icon_state = "medical"
	build_path = /obj/machinery/rnd/production/protolathe/department/medical

/obj/item/circuitboard/machine/sleeper
	name = "Sleeper (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/sleeper
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 2)

/obj/item/circuitboard/machine/smoke_machine
	name = "Smoke Machine (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/smoke_machine
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/stasis
	name = "Lifeform Stasis Unit (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/stasis
	req_components = list(
		/obj/item/stack/cable_coil = 3,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/capacitor = 1)

/obj/item/circuitboard/machine/medipen_refiller
	name = "Medipen Refiller (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/medipen_refiller
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/machine/techfab/department/medical
	name = "\improper Departmental Techfab (Machine Board) - Medical"
	icon_state = "medical"
	build_path = /obj/machinery/rnd/production/techfab/department/medical

/obj/item/circuitboard/machine/clonepod
	name = "Clone Pod (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/clonepod
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/reagent_containers/glass/beaker = 2)

/obj/item/circuitboard/machine/clonepod/experimental
	name = "Experimental Clone Pod (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/clonepod/experimental

/obj/item/circuitboard/machine/clonescanner
	name = "Cloning Scanner (Machine Board)"
	icon_state = "medical"
	build_path = /obj/machinery/dna_scannernew
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/cable_coil = 2)

//Science

/obj/item/circuitboard/machine/circuit_imprinter/department/science
	name = "Departmental Circuit Imprinter - Science (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/science

/obj/item/circuitboard/machine/cyborgrecharger
	name = "Cyborg Recharger (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/recharge_station
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/cell = 1,
		/obj/item/stock_parts/manipulator = 1)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high)

/obj/item/circuitboard/machine/destructive_analyzer
	name = "Destructive Analyzer (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/rnd/destructive_analyzer
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/experimentor
	name = "E.X.P.E.R.I-MENTOR (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/rnd/experimentor
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/mech_recharger
	name = "Exosuit Bay Recharger (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/mech_bay_recharge_port
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor = 5)

/obj/item/circuitboard/machine/mechfab
	name = "Exosuit Fabricator (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/mecha_part_fabricator
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/aug_manipulator
	name = "Augment Manipulator (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/aug_manipulator
	req_components = list(
		/obj/item/airlock_painter = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/nanite_chamber
	name = "Nanite Chamber (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/nanite_chamber
	req_components = list(
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/nanite_program_hub
	name = "Nanite Program Hub (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/nanite_program_hub
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/nanite_programmer
	name = "Nanite Programmer (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/nanite_programmer
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/protolathe/department/science
	name = "Protolathe (Machine Board) - Science"
	icon_state = "science"
	build_path = /obj/machinery/rnd/production/protolathe/department/science

/obj/item/circuitboard/machine/public_nanite_chamber
	name = "Public Nanite Chamber (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/public_nanite_chamber
	var/cloud_id = 1
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/machine/public_nanite_chamber/multitool_act(mob/living/user)
	. = ..()
	var/new_cloud = input("Set the public nanite chamber's Cloud ID (1-100).", "Cloud ID", cloud_id) as num|null
	if(!new_cloud || (loc != user))
		to_chat(user, span_warning("You must hold the circuitboard to change its Cloud ID!"))
		return
	cloud_id = clamp(round(new_cloud, 1), 1, 100)

/obj/item/circuitboard/machine/public_nanite_chamber/examine(mob/user)
	. = ..()
	. += "Cloud ID is currently set to [cloud_id]."

/obj/item/circuitboard/machine/quantumpad
	name = "Quantum Pad (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/quantumpad
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/rdserver
	name = "R&D Server (Machine Board)"
	var/server_id = "default-server"
	var/static/list/all_ids = list()
	icon_state = "science"
	build_path = /obj/machinery/rnd/server
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/rdserver/multitool_act(mob/living/user)
	. = ..()
	var/new_id = input("Set the server ID", "ServerID ID", server_id) as text|null
	new_id = replacetext(new_id, " ", "-")
	if(!new_id || (loc != user))
		to_chat(user, span_warning("You must hold the circuitboard to change its Server ID!"))
		return

	if(new_id in all_ids)
		to_chat(user, span_warning("Server ID already in use!"))
		return

	if(server_id != initial(server_id))
		all_ids -= server_id

	server_id = new_id
	all_ids |= server_id

/obj/item/circuitboard/machine/techfab/department/science
	name = "\improper Departmental Techfab (Machine Board) - Science"
	icon_state = "science"
	build_path = /obj/machinery/rnd/production/techfab/department/science

/obj/item/circuitboard/machine/teleporter_hub
	name = "Teleporter Hub (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/teleport/hub
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 3,
		/obj/item/stock_parts/matter_bin = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/teleporter_station
	name = "Teleporter Station (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/teleport/station
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/sheet/glass = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/bluespace_miner
	name = "Bluespace Miner (Machine Board)"
	build_path = /obj/machinery/power/bluespace_miner
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stack/ore/bluespace_crystal = 5)
	needs_anchored = FALSE

//Security

/obj/item/circuitboard/machine/protolathe/department/security
	name = "Protolathe (Machine Board) - Security"
	icon_state = "security"
	build_path = /obj/machinery/rnd/production/protolathe/department/security

/obj/item/circuitboard/machine/protolathe/department/ballistics
	name = "Protolathe (Machine Board) - Ballistics"
	icon_state = "security"
	build_path = /obj/machinery/rnd/production/protolathe/department/ballistics

/obj/item/circuitboard/machine/recharger
	name = "Weapon Recharger (Machine Board)"
	icon_state = "security"
	build_path = /obj/machinery/recharger
	req_components = list(/obj/item/stock_parts/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/techfab/department/security
	name = "\improper Departmental Techfab (Machine Board) - Security"
	icon_state = "security"
	build_path = /obj/machinery/rnd/production/techfab/department/security

//Service

/obj/item/circuitboard/machine/biogenerator
	name = "Biogenerator (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/biogenerator
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/chem_dispenser/drinks
	name = "Soda Dispenser (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/chem_dispenser/drinks

/obj/item/circuitboard/machine/chem_dispenser/drinks/fullupgrade
	build_path = /obj/machinery/chem_dispenser/drinks/fullupgrade
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	name = "Booze Dispenser (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/chem_dispenser/drinks/beer

/obj/item/circuitboard/machine/chem_dispenser/drinks/beer/fullupgrade
	build_path = /obj/machinery/chem_dispenser/drinks/beer/fullupgrade
	req_components = list(
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stock_parts/manipulator/femto = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_master/condi
	name = "CondiMaster 3000 (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/chem_master/condimaster

/obj/item/circuitboard/machine/deep_fryer
	name = "circuit board (Deep Fryer)"
	icon_state = "service"
	build_path = /obj/machinery/deepfryer
	req_components = list(/obj/item/stock_parts/micro_laser = 1)
	needs_anchored = FALSE


/obj/item/circuitboard/machine/dish_drive
	name = "Dish Drive (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/dish_drive
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 2)
	var/suction = TRUE
	var/transmit = TRUE
	needs_anchored = FALSE

/obj/item/circuitboard/machine/dish_drive/examine(mob/user)
	. = ..()
	. += span_notice("Its suction function is [suction ? "enabled" : "disabled"]. Use it in-hand to switch.")
	. += span_notice("Its disposal auto-transmit function is [transmit ? "enabled" : "disabled"]. Alt-click it to switch.")

/obj/item/circuitboard/machine/dish_drive/attack_self(mob/living/user)
	suction = !suction
	to_chat(user, span_notice("You [suction ? "enable" : "disable"] the board's suction function."))

/obj/item/circuitboard/machine/dish_drive/AltClick(mob/living/user)
	if(!user.Adjacent(src))
		return
	transmit = !transmit
	to_chat(user, span_notice("You [transmit ? "enable" : "disable"] the board's automatic disposal transmission."))

/obj/item/circuitboard/machine/gibber
	name = "Gibber (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/gibber
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/hydroponics
	name = "Hydroponics Tray (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/hydroponics/constructable
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/microwave
	name = "Microwave (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/microwave
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 2)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/plantgenes
	name = "Plant DNA Manipulator (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/plantgenes
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/scanning_module = 1)

/obj/item/circuitboard/machine/processor
	name = "Food Processor (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/processor
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/protolathe/department/service
	name = "Protolathe - Service (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/rnd/production/protolathe/department/service

/obj/item/circuitboard/machine/recycler
	name = "Recycler (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/recycler
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/seed_extractor
	name = "Seed Extractor (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/seed_extractor
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/techfab/department/service
	name = "\improper Departmental Techfab - Service (Machine Board)"
	icon_state = "service"
	build_path = /obj/machinery/rnd/production/techfab/department/service

/obj/item/circuitboard/machine/vendatray
	name = "Vend-A-Tray (Machine Board)"
	icon_state = "service"
	build_path = /obj/structure/displaycase/forsale
	req_components = list(
		/obj/item/stock_parts/card_reader = 1)

//Supply
/obj/item/circuitboard/machine/ore_redemption
	name = "Ore Redemption (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/mineral/ore_redemption
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/assembly/igniter = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/ore_silo
	name = "Ore Silo (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/ore_silo
	req_components = list()

/obj/item/circuitboard/machine/protolathe/department/cargo
	name = "Protolathe (Machine Board) - Cargo"
	icon_state = "supply"
	build_path = /obj/machinery/rnd/production/protolathe/department/cargo

/obj/item/circuitboard/machine/stacking_machine
	name = "Stacking Machine (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/mineral/stacking_machine
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)

/obj/item/circuitboard/machine/stacking_unit_console
	name = "Stacking Machine Console (Machine Board)"
	icon_state = "supply"
	build_path = /obj/machinery/mineral/stacking_unit_console
	req_components = list(
		/obj/item/stack/sheet/glass = 2,
		/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/machine/techfab/department/cargo
	name = "\improper Departmental Techfab (Machine Board) - Cargo"
	icon_state = "supply"
	build_path = /obj/machinery/rnd/production/techfab/department/cargo

/obj/item/circuitboard/machine/abductor
	name = "alien board (Report This)"
	icon_state = "abductor_mod"

/obj/item/circuitboard/machine/abductor/core
	name = "alien board (Void Core)"
	build_path = /obj/machinery/power/rtg/abductor
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/cell/infinite/abductor = 1)
	def_components = list(
		/obj/item/stock_parts/capacitor = /obj/item/stock_parts/capacitor/quadratic,
		/obj/item/stock_parts/micro_laser = /obj/item/stock_parts/micro_laser/quadultra)

/obj/item/circuitboard/machine/plantgenes/vault
	name = "alien board (Plant DNA Manipulator)"
	icon_state = "abductor_mod"
	// It wasn't made by actual abductors race, so no abductor tech here.
	def_components = list(
		/obj/item/stock_parts/manipulator = /obj/item/stock_parts/manipulator/femto,
		/obj/item/stock_parts/micro_laser = /obj/item/stock_parts/micro_laser/quadultra,
		/obj/item/stock_parts/scanning_module = /obj/item/stock_parts/scanning_module/triphasic)

/obj/item/circuitboard/machine/hypnochair
	name = "Enhanced Interrogation Chamber (Machine Board)"
	icon_state = "security"
	build_path = /obj/machinery/hypnochair
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 2
	)

/obj/item/circuitboard/machine/shuttle/engine/plasma
	name = "Plasma Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/fueled/plasma
	req_components = list(/obj/item/stock_parts/capacitor = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/micro_laser = 1)

/obj/item/circuitboard/machine/shuttle/engine/fire
	name = "Combustion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/fire
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/assembly/igniter = 1,
		/obj/item/stack/sheet/plasteel = 2
	)

/obj/item/circuitboard/machine/shuttle/engine/electric
	name = "Ion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/electric
	req_components = list(/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/micro_laser = 3)

/obj/item/circuitboard/machine/shuttle/engine/electric/bad
	name = "Outdated Ion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/electric/bad
	req_components = list(/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/shuttle/engine/expulsion
	name = "Expulsion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/fueled/expulsion
	req_components = list(/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)

/obj/item/circuitboard/machine/shuttle/engine/oil
	name = "Oil Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/liquid/oil
	req_components = list(/obj/item/reagent_containers/glass/beaker = 4,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/shuttle/engine/beer
	name = "Beer Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/liquid/beer
	req_components = list(/obj/item/reagent_containers/food/drinks/beer = 4,
		/obj/item/stock_parts/micro_laser =  2)

/obj/item/circuitboard/machine/shuttle/engine/void
	name = "Void Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/void
	req_components = list(/obj/item/stock_parts/capacitor/quadratic = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/micro_laser/quadultra = 1)

/obj/item/circuitboard/machine/shuttle/heater
	name = "Fueled Engine Heater (Machine Board)"
	desc = "You can use mulitool to switch pipe layers"
	build_path = /obj/machinery/atmospherics/components/unary/shuttle/heater
	var/pipe_layer = PIPING_LAYER_DEFAULT
	req_components = list(/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/machine/shuttle/heater/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		pipe_layer = (pipe_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (pipe_layer + 1)
		to_chat(user, span_notice("You change the circuitboard to layer [pipe_layer]."))
		return

/obj/item/circuitboard/machine/shuttle/heater/examine()
	. = ..()
	. += span_notice("It is set to layer [pipe_layer].")

/obj/item/circuitboard/machine/shuttle/fire_heater
	name = "Combustion Engine Heater (Machine Board)"
	desc = "You can use mulitool to switch pipe layers"
	var/pipe_layer = PIPING_LAYER_DEFAULT
	build_path = /obj/machinery/atmospherics/components/unary/shuttle/fire_heater
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1
	)

/obj/item/circuitboard/machine/shuttle/fire_heater/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		pipe_layer = (pipe_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (pipe_layer + 1)
		to_chat(user, span_notice("You change the circuitboard to layer [pipe_layer]."))
		return

/obj/item/circuitboard/machine/shuttle/fire_heater/examine()
	. = ..()
	. += span_notice("It is set to layer [pipe_layer].")

/obj/item/circuitboard/machine/shuttle/smes
	name = "Electric Engine Precharger (Machine Board)"
	build_path = /obj/machinery/power/smes/shuttle
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/cell = 3,
		/obj/item/stock_parts/capacitor = 1
	)

/obj/item/circuitboard/machine/shuttle/smes/micro
	name = "Micro Electric Engine Precharger (Machine Board)"
	build_path = /obj/machinery/power/smes/shuttle/micro
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/cell = 3,
		/obj/item/stock_parts/capacitor = 2
	)

/obj/item/circuitboard/machine/printer
	name = "Poster Printer (Machine Board)"
	build_path = /obj/machinery/printer
	req_components = list(
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/manipulator = 2,
	)

/obj/item/circuitboard/machine/suit_storage_unit
	name = "Suit Storage Unit"
	icon_state = "engineering"
	build_path = /obj/machinery/suit_storage_unit
	req_components = list(/obj/item/stock_parts/micro_laser = 4)

//preset for the industrial suit storage, otherwise identical.
/obj/item/circuitboard/machine/suit_storage_unit/industrial
	build_path = /obj/machinery/suit_storage_unit/industrial

/obj/item/circuitboard/machine/suit_storage_unit/examine(mob/user)
	. = ..()
	. += span_notice("You can change the resulting storage type by using a multitool.")
	var/obj/machinery/suit_storage_unit/information_holder = build_path
	. += span_notice("It is currently set to: [initial(information_holder.name)].")

/obj/item/circuitboard/machine/suit_storage_unit/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_MULTITOOL)
		var/list/possible_results = list(/obj/machinery/suit_storage_unit, /obj/machinery/suit_storage_unit/industrial)
		var/list_length = length(possible_results)
		var/list_position = possible_results.Find(build_path)
		if(list_position) //FALSE position should never happen, but could with var editing.
			//There is a modulus way to do this, but no real need to get fancy.
			build_path = list_position == list_length ? possible_results[1] : possible_results[++list_position]
			var/obj/machinery/suit_storage_unit/information_holder = build_path
			to_chat(user, span_notice("You modify the resulting construction. It is now set to [initial(information_holder.name)]."))
	return ..()

/obj/item/circuitboard/machine/turret
	name = "Turret"
	icon_state = "security"
	build_path = /obj/machinery/porta_turret
	req_components = list(/obj/item/stock_parts/capacitor = 2, /obj/item/stock_parts/scanning_module = 1, /obj/item/assembly/prox_sensor = 1, /obj/item/gun/energy = 1)
	def_components = list(/obj/item/gun/energy = /obj/item/gun/energy/e_gun/turret)

/obj/item/circuitboard/machine/turret/ship
	name = "Ship-mounted Turret"
	//We don't want to let people take the gun out of the turret
	def_components = list(/obj/item/gun/energy = /obj/item/stack/sheet/metal)

/obj/item/circuitboard/machine/turret/ruin
	def_components = list(/obj/item/gun/energy = /obj/item/stack/sheet/metal)
