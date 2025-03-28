/*
	The server logs all traffic and signal data. Once it records the signal, it sends
	it to the subspace broadcaster.

	Store a maximum of 100 logs and then deletes them.
*/

/obj/machinery/telecomms/server
	name = "telecommunication server"
	icon_state = "comm_server"
	desc = "A machine used to store data and network statistics."
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = IDLE_DRAW_MINIMAL
	circuit = /obj/item/circuitboard/machine/telecomms/server
	var/list/log_entries = list()
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)

/obj/machinery/telecomms/server/Initialize()
	. = ..()

/obj/machinery/telecomms/server/receive_information(datum/signal/subspace/vocal/signal, obj/machinery/telecomms/machine_from)
	// can't log non-vocal signals
	if(!istype(signal) || !signal.data["message"] || !is_freq_listening(signal))
		return

	if(traffic > 0)
		totaltraffic += traffic // add current traffic to total traffic

	// Delete particularly old logs
	if (log_entries.len >= 400)
		log_entries.Cut(1, 2)

	var/datum/comm_log_entry/log = new
	log.parameters["mobtype"] = signal.virt.source.type
	log.parameters["name"] = signal.data["name"]
	log.parameters["job"] = signal.data["job"]
	log.parameters["message"] = signal.data["message"]
	log.parameters["language"] = signal.language

	// If the signal is still compressed, make the log entry gibberish
	var/compression = signal.data["compression"]
	if(compression > 0)
		log.input_type = "Corrupt File"
		var/replace_characters = compression >= 20 ? TRUE : FALSE
		log.parameters["name"] = Gibberish(signal.data["name"], replace_characters)
		log.parameters["job"] = Gibberish(signal.data["job"], replace_characters)
		log.parameters["message"] = Gibberish(signal.data["message"], replace_characters)

	// Give the log a name and store it
	var/identifier = num2text(rand(-1000,1000) + world.time)
	log.name = "data packet ([md5(identifier)])"
	log_entries.Add(log)

	var/can_send = relay_information(signal, /obj/machinery/telecomms/hub)
	if(!can_send)
		relay_information(signal, /obj/machinery/telecomms/broadcaster)


// Simple log entry datum
/datum/comm_log_entry
	var/input_type = "Speech File"
	var/name = "data packet (#)"
	var/parameters = list()  // copied from signal.data above


// Preset Servers
/obj/machinery/telecomms/server/presets
	network = "tcommsat"

/obj/machinery/telecomms/server/presets/Initialize()
	. = ..()
	name = id


/obj/machinery/telecomms/server/presets/nanotrasen
	id = "Nanotrasen Server"
	freq_listening = list(FREQ_NANOTRASEN, FREQ_COMMON)
	autolinkers = list("nanotrasen", "broadcasterA")

/obj/machinery/telecomms/server/presets/terragov
	id = "TerraGov Server"
	freq_listening = list(FREQ_TERRAGOV, FREQ_COMMON)
	autolinkers = list("terragov", "broadcasterA")

/obj/machinery/telecomms/server/presets/syndicate
	id = "Syndicate Server"
	freq_listening = list(FREQ_SYNDICATE, FREQ_COMMON)
	autolinkers = list("syndicate", "broadcasterB")

/obj/machinery/telecomms/server/presets/minutemen
	id = "CLIP Server"
	freq_listening = list(FREQ_MINUTEMEN, FREQ_COMMON)
	autolinkers = list("minutemen", "broadcasterA")

/obj/machinery/telecomms/server/presets/inteq
	id = "IRMG Server"
	freq_listening = list(FREQ_INTEQ, FREQ_COMMON)
	autolinkers = list("inteq", "broadcasterB")

/obj/machinery/telecomms/server/presets/pirate
	id = "Pirate Server"
	freq_listening = list(FREQ_PIRATE, FREQ_COMMON)
	autolinkers = list("pirate", "broadcasterB")

/obj/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list()
	autolinkers = list("common", "broadcasterA")

//Common and other radio frequencies for people to freely use
/obj/machinery/telecomms/server/presets/common/Initialize()
	. = ..()
	for(var/i = MIN_FREQ, i <= MAX_FREQ, i += 2)
		freq_listening |= i

/obj/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(FREQ_EMERGENCY, FREQ_COMMON)
	autolinkers = list("command")

/obj/machinery/telecomms/server/presets/common/birdstation/Initialize()
	. = ..()
	freq_listening = list()
