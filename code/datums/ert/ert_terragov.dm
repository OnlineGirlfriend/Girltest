/datum/ert/terragov
	teamsize = 4
	opendoors = FALSE
	leader_role = /datum/antagonist/ert/terragov
	roles = list(/datum/antagonist/ert/terragov)
	mission = "Intervene in Solarian interests."
	rename_team = "TerraGov Shock Trooper Team"
	polldesc = "a TerraGov mercenary team"

/datum/ert/terragov/inspector
	teamsize = 1
	leader_role = /datum/antagonist/ert/terragov/inspector
	roles = list(/datum/antagonist/ert/terragov/inspector)
	rename_team = "TerraGov Inspector"
	polldesc = "a solarian inspector"
	spawn_at_outpost = FALSE

/datum/ert/terragov/inspector/New()
	mission = "Conduct a routine review on [station_name()]'s vessels."
