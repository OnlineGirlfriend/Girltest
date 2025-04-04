#define SENSORS_UPDATE_PERIOD 100 //How often the sensor data updates.

/obj/machinery/computer/crew
	name = "crew monitoring console"
	desc = "Used to monitor active health sensors built into most of the crew's uniforms."
	icon_screen = "crew"
	icon_keyboard = "med_key"
	use_power = IDLE_POWER_USE
	idle_power_usage = IDLE_DRAW_LOW
	active_power_usage = ACTIVE_DRAW_MEDIUM
	circuit = /obj/item/circuitboard/computer/crew

	light_color = LIGHT_COLOR_BLUE

/obj/machinery/computer/crew/retro
	icon = 'icons/obj/machines/retro_computer.dmi'
	icon_state = "computer-retro"
	deconpath = /obj/structure/frame/computer/retro

/obj/machinery/computer/crew/terragov
	icon = 'icons/obj/machines/retro_computer.dmi'
	icon_state = "computer-solgov"
	deconpath = /obj/structure/frame/computer/terragov

/obj/machinery/computer/crew/syndie
	icon_keyboard = "syndie_key"

/obj/machinery/computer/crew/interact(mob/user)
	GLOB.crewmonitor.show(user,src)

GLOBAL_DATUM_INIT(crewmonitor, /datum/crewmonitor, new)

/datum/crewmonitor
	var/list/ui_sources = list() //List of user -> ui source
	var/list/data_by_z = list()
	var/list/last_update = list()

/datum/crewmonitor/Destroy()
	return ..()

/datum/crewmonitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CrewConsole")
		ui.open()

/obj/machinery/computer/crew/examine_more(mob/user)
	. = ..()
	interact(user)

/datum/crewmonitor/ui_close(mob/user)
	ui_sources -= user
	return ..()

/datum/crewmonitor/proc/show(mob/M, source)
	ui_sources[M] = source
	ui_interact(M)

/datum/crewmonitor/ui_host(mob/user)
	return ui_sources[user]

/datum/crewmonitor/ui_data(mob/user)
	var/z = user.virtual_z()
	var/turf/T = get_turf(user)
	if(!z)
		z = T.virtual_z()
	var/list/zdata = update_data(z, T.virtual_level_trait(ZTRAIT_STATION))
	. = list()
	.["sensors"] = zdata
	.["link_allowed"] = isAI(user)

/datum/crewmonitor/proc/update_data(z, station)
	if(data_by_z["[z]"] && last_update["[z]"] && world.time <= last_update["[z]"] + SENSORS_UPDATE_PERIOD)
		return data_by_z["[z]"]

	var/list/results = list()

	for(var/i in GLOB.human_list)
		var/obj/item/clothing/under/U
		var/obj/item/card/id/I
		var/turf/pos
		var/ijob = JOB_DISPLAY_ORDER_DEFAULT
		var/name = "Unknown"
		var/assignment
		var/oxydam
		var/toxdam
		var/burndam
		var/brutedam
		var/area
		var/pos_x
		var/pos_y
		var/life_status

		var/mob/living/carbon/human/H = i
		var/nanite_sensors = FALSE
		if(H in SSnanites.nanite_monitored_mobs)
			nanite_sensors = TRUE
		// Check if their z-level is correct and if they are wearing a uniform.
		// Accept H.z==0 as well in case the mob is inside an object.
		// Accept any station zlevel if the console user is on a station zlevel
		if ((H.z == 0 || H.virtual_z() == z || (station && H.virtual_level_trait(ZTRAIT_STATION))) && (istype(H.w_uniform, /obj/item/clothing/under) || nanite_sensors))
			U = H.w_uniform

			// Are the suit sensors on?
			if (nanite_sensors || ((U.has_sensor > 0) && U.sensor_mode))
				pos = H.z == 0 || (nanite_sensors || U.sensor_mode == SENSOR_COORDS) ? get_turf(H) : null

				// Special case: If the mob is inside an object confirm the z-level on turf level.
				if (H.z == 0 && (!pos || (pos.virtual_z() != z)))
					continue

				I = H.wear_id ? H.wear_id.GetID() : null

				if (I)
					name = I.registered_name
					assignment = I.assignment
					if(I.assignment in GLOB.name_occupations)
						var/datum/job/assigned_job = GLOB.name_occupations[I.assignment]
						ijob = assigned_job.display_order

				if (nanite_sensors || U.sensor_mode >= SENSOR_LIVING)
					life_status = ((H.stat < DEAD) ? TRUE : FALSE) //So anything less that dead is marked as alive. (Soft crit, concious, unconcious)

				if (nanite_sensors || U.sensor_mode >= SENSOR_VITALS)
					oxydam = round(H.getOxyLoss(),1)
					toxdam = round(H.getToxLoss(),1)
					burndam = round(H.getFireLoss(),1)
					brutedam = round(H.getBruteLoss(),1)

				if (nanite_sensors || U.sensor_mode >= SENSOR_COORDS)
					if (!pos)
						pos = get_turf(H)
					area = get_area_name(H, TRUE)
					pos_x = pos.x
					pos_y = pos.y

				results[++results.len] = list("name" = name, "assignment" = assignment, "ijob" = ijob, "life_status" = life_status, "oxydam" = oxydam, "toxdam" = toxdam, "burndam" = burndam, "brutedam" = brutedam, "area" = area, "pos_x" = pos_x, "pos_y" = pos_y, "can_track" = H.can_track(null))

	data_by_z["[z]"] = sortTim(results, /proc/sensor_compare)
	last_update["[z]"] = world.time

	return results

/proc/sensor_compare(list/a,list/b)
	return a["ijob"] - b["ijob"]

/datum/crewmonitor/ui_act(action,params)
	. = ..()
	if(.)
		return
	var/mob/living/silicon/ai/AI = usr
	if(!istype(AI))
		return
	switch (action)
		if ("select_person")
			AI.ai_camera_track(params["name"])

#undef SENSORS_UPDATE_PERIOD
