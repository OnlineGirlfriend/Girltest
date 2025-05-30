//modular computer program version is located in code\modules\modular_computers\file_system\programs\powermonitor.dm, /datum/computer_file/program/power_monitor

/obj/machinery/computer/monitor
	name = "power monitoring console"
	desc = "It monitors power levels on it's assigned network."
	icon_screen = "power"
	icon_keyboard = "power_key"
	light_color = LIGHT_COLOR_YELLOW
	use_power = ACTIVE_POWER_USE
	idle_power_usage = IDLE_DRAW_MINIMAL
	active_power_usage = ACTIVE_DRAW_MINIMAL
	circuit = /obj/item/circuitboard/computer/powermonitor
	tgui_id = "PowerMonitor"

	var/obj/structure/cable/attached_wire
	var/obj/machinery/power/apc/local_apc

	var/list/history = list()
	var/record_size = 60
	var/record_interval = 50
	var/next_record = 0
	var/is_secret_monitor = FALSE

/obj/machinery/computer/monitor/retro
	icon = 'icons/obj/machines/retro_computer.dmi'
	icon_state = "computer-retro"
	deconpath = /obj/structure/frame/computer/retro

/obj/machinery/computer/monitor/terragov
	icon = 'icons/obj/machines/retro_computer.dmi'
	icon_state = "computer-solgov"
	deconpath = /obj/structure/frame/computer/terragov

/obj/machinery/computer/monitor/secret //Hides the power monitor (such as ones on ruins & CentCom) from PDA's to prevent metagaming.
	name = "outdated power monitoring console"
	desc = "It monitors power levels across the local powernet."
	circuit = /obj/item/circuitboard/computer/powermonitor/secret
	is_secret_monitor = TRUE

/obj/machinery/computer/monitor/secret/examine(mob/user)
	. = ..()
	. += span_notice("It's operating system seems quite outdated... It doesn't seem like it'd be compatible with the latest remote NTOS monitoring systems.")

/obj/machinery/computer/monitor/Initialize()
	. = ..()
	search()
	history["supply"] = list()
	history["demand"] = list()

/obj/machinery/computer/monitor/process(seconds_per_tick)
	if(!get_powernet())
		if(use_static_power != IDLE_POWER_USE)
			set_idle_power()
		search()
	else
		if(use_static_power != ACTIVE_POWER_USE)
			set_active_power()
		record()

/obj/machinery/computer/monitor/proc/search() //keep in sync with /datum/computer_file/program/power_monitor's version
	var/turf/T = get_turf(src)
	attached_wire = locate(/obj/structure/cable) in T
	if(attached_wire)
		return
	var/area/A = get_area(src) //if the computer isn't directly connected to a wire, attempt to find the APC powering it to pull it's powernet instead
	if(!A)
		return
	local_apc = A.get_apc()
	if(!local_apc)
		return
	if(!local_apc.terminal) //this really shouldn't happen without badminnery.
		local_apc = null

/obj/machinery/computer/monitor/proc/get_powernet() //keep in sync with /datum/computer_file/program/power_monitor's version
	if(attached_wire || (local_apc && local_apc.terminal))
		return attached_wire ? attached_wire.powernet : local_apc.terminal.powernet
	return FALSE

/obj/machinery/computer/monitor/proc/record() //keep in sync with /datum/computer_file/program/power_monitor's version
	if(world.time >= next_record)
		next_record = world.time + record_interval

		var/datum/powernet/connected_powernet = get_powernet()

		var/list/supply = history["supply"]
		if(connected_powernet)
			supply += connected_powernet.viewavail
		if(supply.len > record_size)
			supply.Cut(1, 2)

		var/list/demand = history["demand"]
		if(connected_powernet)
			demand += connected_powernet.viewload
		if(demand.len > record_size)
			demand.Cut(1, 2)

/obj/machinery/computer/monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PowerMonitor", name)
		ui.open()

/obj/machinery/computer/monitor/ui_data()
	var/datum/powernet/connected_powernet = get_powernet()
	var/list/data = list()
	data["stored"] = record_size
	data["interval"] = record_interval / 10
	data["attached"] = connected_powernet ? TRUE : FALSE
	data["history"] = history
	data["areas"] = list()

	if(connected_powernet)
		data["supply"] = DisplayPower(connected_powernet.viewavail)
		data["demand"] = DisplayPower(connected_powernet.viewload)
		for(var/obj/machinery/power/terminal/term in connected_powernet.nodes)
			var/obj/machinery/power/apc/A = term.master
			if(istype(A))
				var/cell_charge
				if(!A.cell)
					cell_charge = 0
				else
					cell_charge = A.cell.percent()
				data["areas"] += list(list(
					"name" = A.area.name,
					"charge" = cell_charge,
					"load" = DisplayPower(A.lastused_total),
					"charging" = A.charging,
					"eqp" = A.equipment,
					"lgt" = A.lighting,
					"env" = A.environ
				))

	return data
