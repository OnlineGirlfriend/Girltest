//Pastry is a food that is made from dough which is made from wheat or rye flour.
//This file contains pastries that don't fit any existing categories.
////////////////////////////////////////////DONUTS////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack."
	icon = 'icons/obj/food/donuts.dmi'
	icon_state = "donut"
	bitesize = 5
	bonus_reagents = list(/datum/reagent/consumable/sugar = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/sugar = 2)
	filling_color = "#D2691E"
	tastes = list("donut" = 1)
	foodtype = JUNKFOOD | GRAIN | FRIED | SUGAR | BREAKFAST
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_SMALL
	var/decorated_icon = "donut_homer"
	var/is_decorated = FALSE
	var/extra_reagent = null
	var/decorated_adjective = "sprinkled"

/obj/item/reagent_containers/food/snacks/donut/Initialize()
	. = ..()
	if(prob(30))
		decorate_donut()

/obj/item/reagent_containers/food/snacks/donut/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/reagent_containers/food/snacks/donut/proc/decorate_donut()
	if(is_decorated || !decorated_icon)
		return
	is_decorated = TRUE
	name = "[decorated_adjective] [name]"
	icon_state = decorated_icon //delish~!
	reagents.add_reagent(/datum/reagent/consumable/sprinkles, 1)
	filling_color = "#FF69B4"
	return TRUE

/// Returns the sprite of the donut while in a donut box
/obj/item/reagent_containers/food/snacks/donut/proc/in_box_sprite()
	return "[icon_state]_inbox"

/obj/item/reagent_containers/food/snacks/donut/checkLiked(fraction, mob/M)	//Sec officers always love donuts
	if(last_check_time + 50 < world.time)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(HAS_TRAIT(H.mind, TRAIT_LAW_ENFORCEMENT_METABOLISM) && !HAS_TRAIT(H, TRAIT_AGEUSIA))
				to_chat(H,span_notice("I love this taste!"))
				H.adjust_disgust(-5 + -2.5 * fraction)
				SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "fav_food", /datum/mood_event/favorite_food)
				last_check_time = world.time
				return
	..()

/obj/item/reagent_containers/food/snacks/donut/plain
	//Use this donut ingame

/obj/item/reagent_containers/food/snacks/donut/chaos
	name = "chaos donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one causes your eyes to strain to perceive it."
	icon_state = "donut_chaos"
	bitesize = 10
	tastes = list("donut" = 3, "chaos" = 1)
	is_decorated = TRUE

/obj/item/reagent_containers/food/snacks/donut/chaos/Initialize()
	. = ..()
	extra_reagent = pick(/datum/reagent/consumable/nutriment, /datum/reagent/consumable/capsaicin, /datum/reagent/consumable/frostoil, /datum/reagent/toxin/plasma, /datum/reagent/consumable/coco, /datum/reagent/toxin/slimejelly, /datum/reagent/consumable/banana, /datum/reagent/consumable/berryjuice, /datum/reagent/medicine/omnizine)
	reagents.add_reagent(extra_reagent, 3)

/obj/item/reagent_containers/food/snacks/donut/meat
	name = "Meat Donut"
	desc = "A pastry(?) composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one is filled with ground meat of some sort, which has soaked the dough."
	icon_state = "donut_meat"
	bonus_reagents = list(/datum/reagent/consumable/ketchup = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/ketchup = 2)
	tastes = list("meat" = 1)
	foodtype = JUNKFOOD | MEAT | GORE | FRIED | BREAKFAST
	is_decorated = TRUE

/obj/item/reagent_containers/food/snacks/donut/berry
	name = "pink donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has berry-flavored frosting on the top."
	icon_state = "donut_pink"
	bonus_reagents = list(/datum/reagent/consumable/berryjuice = 3, /datum/reagent/consumable/sprinkles = 1) //Extra sprinkles to reward frosting
	filling_color = "#E57d9A"
	decorated_icon = "donut_homer"

/obj/item/reagent_containers/food/snacks/donut/trumpet
	name = "spaceman's donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has polypyr-flavored frosting on the top."
	icon_state = "donut_purple"
	bonus_reagents = list(/datum/reagent/medicine/polypyr = 3, /datum/reagent/consumable/sprinkles = 1)
	tastes = list("donut" = 3, "violets" = 1)
	is_decorated = TRUE
	filling_color = "#8739BF"

/obj/item/reagent_containers/food/snacks/donut/apple
	name = "apple donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has apple-flavored frosting."
	icon_state = "donut_green"
	bonus_reagents = list(/datum/reagent/consumable/applejuice = 3, /datum/reagent/consumable/sprinkles = 1)
	tastes = list("donut" = 3, "green apples" = 1)
	is_decorated = TRUE
	filling_color = "#6ABE30"

/obj/item/reagent_containers/food/snacks/donut/caramel
	name = "caramel donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has caramel-flavored frosting."
	icon_state = "donut_beige"
	bonus_reagents = list(/datum/reagent/consumable/caramel = 3, /datum/reagent/consumable/sprinkles = 1)
	tastes = list("donut" = 3, "buttery sweetness" = 1)
	is_decorated = TRUE
	filling_color = "#D4AD5B"

/obj/item/reagent_containers/food/snacks/donut/choco
	name = "chocolate donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has chocolate frosting."
	icon_state = "donut_choc"
	bonus_reagents = list(/datum/reagent/consumable/hot_coco = 3, /datum/reagent/consumable/sprinkles = 1) //the coco reagent is just bitter.
	tastes = list("donut" = 4, "bitterness" = 1)
	decorated_icon = "donut_choc_sprinkles"
	filling_color = "#4F230D"

/obj/item/reagent_containers/food/snacks/donut/blumpkin
	name = "blumpkin donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has chlorine-flavored(?) frosting."
	icon_state = "donut_blue"
	bonus_reagents = list(/datum/reagent/consumable/blumpkinjuice = 3, /datum/reagent/consumable/sprinkles = 1)
	tastes = list("donut" = 2, "blumpkin" = 1)
	is_decorated = TRUE
	filling_color = "#2788C4"

/obj/item/reagent_containers/food/snacks/donut/bungo
	name = "bungo donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has citrus/banana/tropical-esque-flavored frosting."
	icon_state = "donut_yellow"
	bonus_reagents = list(/datum/reagent/consumable/bungojuice = 3, /datum/reagent/consumable/sprinkles = 1)
	tastes = list("donut" = 3, "tropical sweetness" = 1)
	is_decorated = TRUE
	filling_color = "#DEC128"

/obj/item/reagent_containers/food/snacks/donut/matcha
	name = "matcha donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has a matcha-flavored frosting."
	icon_state = "donut_olive"
	bonus_reagents = list(/datum/reagent/toxin/teapowder = 3, /datum/reagent/consumable/sprinkles = 1)
	tastes = list("donut" = 3, "matcha" = 1)
	is_decorated = TRUE
	filling_color = "#879630"

//////////////////////JELLY DONUTS/////////////////////////

/obj/item/reagent_containers/food/snacks/donut/jelly
	name = "jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly."
	icon_state = "jelly"
	decorated_icon = "jelly_homer"
	bonus_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	extra_reagent = /datum/reagent/consumable/berryjuice
	tastes = list("jelly" = 1, "donut" = 3)
	foodtype = JUNKFOOD | GRAIN | FRIED | FRUIT | SUGAR | BREAKFAST

// Jelly donuts don't have holes, but look the same on the outside
/obj/item/reagent_containers/food/snacks/donut/jelly/in_box_sprite()
	return "[replacetext(icon_state, "jelly", "donut")]_inbox"

/obj/item/reagent_containers/food/snacks/donut/jelly/Initialize()
	. = ..()
	if(extra_reagent)
		reagents.add_reagent(extra_reagent, 3)

/obj/item/reagent_containers/food/snacks/donut/jelly/plain //use this ingame to avoid inheritance related crafting issues.

/obj/item/reagent_containers/food/snacks/donut/jelly/berry
	name = "pink jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one's berry-flavored."
	icon_state = "jelly_pink"
	bonus_reagents = list(/datum/reagent/consumable/berryjuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1) //Extra sprinkles to reward frosting.
	filling_color = "#E57d9A"
	decorated_icon = "jelly_homer"

/obj/item/reagent_containers/food/snacks/donut/jelly/trumpet
	name = "spaceman's jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is polypyr-flavored."
	icon_state = "jelly_purple"
	bonus_reagents = list(/datum/reagent/medicine/polypyr = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "violets" = 1)
	is_decorated = TRUE
	filling_color = "#8739BF"

/obj/item/reagent_containers/food/snacks/donut/jelly/apple
	name = "apple jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is apple-flavored."
	icon_state = "jelly_green"
	bonus_reagents = list(/datum/reagent/consumable/applejuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "green apples" = 1)
	is_decorated = TRUE
	filling_color = "#6ABE30"

/obj/item/reagent_containers/food/snacks/donut/jelly/caramel
	name = "caramel jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a flavored jelly. This one is caramel-flavored."
	icon_state = "jelly_beige"
	bonus_reagents = list(/datum/reagent/consumable/caramel = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "buttery sweetness" = 1)
	is_decorated = TRUE
	filling_color = "#D4AD5B"

/obj/item/reagent_containers/food/snacks/donut/jelly/choco
	name = "chocolate jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a flavored jelly. This one is chocolate."
	icon_state = "jelly_choc"
	bonus_reagents = list(/datum/reagent/consumable/hot_coco = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1) //the coco reagent is just bitter.
	tastes = list("jelly" = 1, "donut" = 4, "bitterness" = 1)
	decorated_icon = "jelly_choc_sprinkles"
	filling_color = "#4F230D"

/obj/item/reagent_containers/food/snacks/donut/jelly/blumpkin
	name = "blumpkin jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is chlorine(?)-flavored."
	icon_state = "jelly_blue"
	bonus_reagents = list(/datum/reagent/consumable/blumpkinjuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 2, "blumpkin" = 1)
	is_decorated = TRUE
	filling_color = "#2788C4"

/obj/item/reagent_containers/food/snacks/donut/jelly/bungo
	name = "bungo jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is citrus/banana/tropical-esque-flavored."
	icon_state = "jelly_yellow"
	bonus_reagents = list(/datum/reagent/consumable/bungojuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "tropical sweetness" = 1)
	is_decorated = TRUE
	filling_color = "#DEC128"

/obj/item/reagent_containers/food/snacks/donut/jelly/matcha
	name = "matcha jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is matcha-flavored."
	icon_state = "jelly_olive"
	bonus_reagents = list(/datum/reagent/toxin/teapowder = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "matcha" = 1)
	is_decorated = TRUE
	filling_color = "#879630"

//////////////////////////SLIME DONUTS/////////////////////////

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly
	name = "jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. The smell from this one is odd."
	icon_state = "jelly"
	extra_reagent = /datum/reagent/toxin/slimejelly
	foodtype = JUNKFOOD | GRAIN | FRIED | TOXIC | SUGAR | BREAKFAST

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/plain

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/berry
	name = "pink jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with berry-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_pink"
	bonus_reagents = list(/datum/reagent/consumable/berryjuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1) //Extra sprinkles to reward frosting
	filling_color = "#E57d9A"

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/trumpet
	name = "spaceman's jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with polypyr-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_purple"
	bonus_reagents = list(/datum/reagent/medicine/polypyr = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "violets" = 1)
	is_decorated = TRUE
	filling_color = "#8739BF"

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/apple
	name = "apple jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with apple-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_green"
	bonus_reagents = list(/datum/reagent/consumable/applejuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "green apples" = 1)
	is_decorated = TRUE
	filling_color = "#6ABE30"

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/caramel
	name = "caramel jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with caramel-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_beige"
	bonus_reagents = list(/datum/reagent/consumable/caramel = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "buttery sweetness" = 1)
	is_decorated = TRUE
	filling_color = "#D4AD5B"

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/choco
	name = "chocolate jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with chocolate-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_choc"
	bonus_reagents = list(/datum/reagent/consumable/hot_coco = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 4, "chocolate" = 1)
	decorated_icon = "jelly_choc_sprinkles"
	filling_color = "#4F230D"

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/blumpkin
	name = "blumpkin jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with chlorine(?)-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_blue"
	bonus_reagents = list(/datum/reagent/consumable/blumpkinjuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 2, "blumpkin" = 1)
	is_decorated = TRUE
	filling_color = "#2788C4"

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/bungo
	name = "bungo jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with citrus/banana/tropical-esque-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_yellow"
	bonus_reagents = list(/datum/reagent/consumable/bungojuice = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "tropical sweetness" = 1)
	is_decorated = TRUE
	filling_color = "#DEC128"

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/matcha
	name = "matcha jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with matcha-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_olive"
	bonus_reagents = list(/datum/reagent/toxin/teapowder = 3, /datum/reagent/consumable/sprinkles = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("jelly" = 1, "donut" = 3, "matcha" = 1)
	is_decorated = TRUE
	filling_color = "#879630"

////////////////////////////////////////////MUFFINS////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/muffin
	name = "muffin"
	desc = "A sweetened quickbread confection, originating from Earth. Commonly comes with toppings, but this one is plain."
	icon_state = "muffin"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6)
	filling_color = "#F4A460"
	tastes = list("muffin" = 1)
	foodtype = GRAIN | SUGAR | BREAKFAST
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/muffin/berry
	name = "berry muffin"
	icon_state = "berrymuffin"
	desc = "A sweetened quickbread confection, filled with berries."
	tastes = list("muffin" = 3, "berry" = 1)
	foodtype = GRAIN | FRUIT | SUGAR | BREAKFAST

/obj/item/reagent_containers/food/snacks/muffin/booberry
	name = "booberry muffin"
	icon_state = "berrymuffin"
	alpha = 125
	desc = "A sweetened quickbread confection, filled with berries(?). The muffin shudders and moves slightly."
	tastes = list("muffin" = 3, "spookiness" = 1)
	foodtype = GRAIN | FRUIT | SUGAR | BREAKFAST

/obj/item/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A savory egg custard originating from Earth, named after being prepared by being steamed in a tea bowl or teacup."
	icon_state = "chawanmushi"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	filling_color = "#FFE4E1"
	tastes = list("custard" = 1)
	foodtype = GRAIN | MEAT | VEGETABLES

////////////////////////////////////////////WAFFLES////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "A breakfast item made from batter that's been fried between two heated, shaped plates."
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#D2691E"
	tastes = list("waffles" = 1)
	foodtype = GRAIN | SUGAR | BREAKFAST

/obj/item/reagent_containers/food/snacks/soylentgreen
	name = "\improper Reclamation Biscuit"
	desc = "A failed research project by SUNS into retooling the agricultural \"biogenerators\" to accept and process proteins into more nutritionally-efficient foodstuffs. Dubbed the reclamation biscuit, this quickly fell under controversy under an accusation of biogenerators being capable of processing human and other sophonts' flesh. Of course, the rumors were never confirmed, but the project was shuttered."
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#9ACD32"
	tastes = list("waffle" = 2, "savory batter" = 2, "filling nutrient-paste batter" = 1)
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/soylenviridians
	name = "\improper Reclamation Biscuit?"
	desc = "A failed research project by SUNS into retooling the agricultural \"biogenerators\" to accept and process proteins into more nutritionally-efficient foodstuffs. Dubbed the reclamation biscuit, this quickly fell under controversy under an accusation of biogenerators being capable of processing human and other sophonts' flesh. Of course, the rumors were never confirmed, but the project was shuttered. This one, however, just looks like a vegan waffle."
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#9ACD32"
	tastes = list("waffles" = 7, "the colour green" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/rofflewaffles
	name = "skroffles"
	desc = "A sort of waffle-esque prepared from hallucinogenic mushrooms. While seemingly only colonist cuisine, this one became popular among a scifi fans for being reminiscent of a popular fictional species of aliens, who purportedly can eat wildly hallucinogenic foodstuffs without issue."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	bitesize = 4
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/drug/mushroomhallucinogen = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	filling_color = "#00BFFF"
	tastes = list("waffle" = 1, "mushrooms" = 1, "warbling" = 1)
	foodtype = GRAIN | VEGETABLES | SUGAR | BREAKFAST
////////////////////////////////////////////DONK POCKETS////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/donkpocket
	name = "\improper Donk-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. Purportedly reinforced with nutrients in some way."
	icon_state = "donkpocket"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	cooked_type = /obj/item/reagent_containers/food/snacks/donkpocket/warm
	filling_color = "#CD853F"
	tastes = list("meat" = 2, "dough" = 2, "coldness throughout" = 1)
	foodtype = GRAIN
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/donkpocket/warm
	name = "warm Donk-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. Purportedly reinforced with nutrients in some way."
	bonus_reagents = list(/datum/reagent/medicine/omnizine = 3) //The original donk pocket has the most omnizine, can't beat the original on everything...
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/omnizine = 3)
	cooked_type = null
	tastes = list("meat" = 2, "dough" = 2, "cold center" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/dankpocket
	name = "\improper Dank-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers, this one is an unlicensed product that is sold recreationally..."
	icon_state = "dankpocket"
	list_reagents = list(/datum/reagent/drug/retukemi = 3, /datum/reagent/consumable/nutriment = 4)
	filling_color = "#00FF00"
	tastes = list("meat" = 2, "dough" = 2)
	foodtype = GRAIN | VEGETABLES

/obj/item/reagent_containers/food/snacks/donkpocket/spicy
	name = "\improper Spicy-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's filled with spicier fillings."
	icon_state = "donkpocketspicy"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/capsaicin = 2)
	cooked_type = /obj/item/reagent_containers/food/snacks/donkpocket/warm/spicy
	filling_color = "#CD853F"
	tastes = list("meat" = 2, "dough" = 2, "spice" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/warm/spicy
	name = "warm Spicy-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's filled with spicier fillings."
	icon_state = "donkpocketspicy"
	bonus_reagents = list(/datum/reagent/medicine/omnizine = 1, /datum/reagent/consumable/capsaicin = 3)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/omnizine = 1, /datum/reagent/consumable/capsaicin = 2)
	tastes = list("meat" = 2, "dough" = 2, "weird spices" = 2)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/teriyaki
	name = "\improper Teriyaki-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's filled with teriyaki-flavored fillings."
	icon_state = "donkpocketteriyaki"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/soysauce = 2)
	cooked_type = /obj/item/reagent_containers/food/snacks/donkpocket/warm/teriyaki
	filling_color = "#CD853F"
	tastes = list("meat" = 2, "dough" = 2, "soy sauce" = 2)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/warm/teriyaki
	name = "warm Teriyaki-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's filled with teriyaki-flavored fillings."
	icon_state = "donkpocketteriyaki"
	bonus_reagents = list(/datum/reagent/medicine/omnizine = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/omnizine = 1, /datum/reagent/consumable/soysauce = 2)
	tastes = list("meat" = 2, "dough" = 2, "soy sauce" = 2)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/pizza
	name = "\improper Pizza-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's filled with pizza-esque fillings."
	icon_state = "donkpocketpizza"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/tomatojuice = 2)
	cooked_type = /obj/item/reagent_containers/food/snacks/donkpocket/warm/pizza
	filling_color = "#CD853F"
	tastes = list("meat" = 2, "dough" = 2, "cheese"= 2)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/warm/pizza
	name = "warm Pizza-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's filled with pizza-esque fillings."
	icon_state = "donkpocketpizza"
	bonus_reagents = list(/datum/reagent/medicine/omnizine = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/omnizine = 1, /datum/reagent/consumable/tomatojuice = 2)
	tastes = list("meat" = 2, "dough" = 2, "melty cheese"= 2)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/honk
	name = "\improper Honk-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's marketed towards kids."
	icon_state = "donkpocketbanana"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/banana = 4)
	cooked_type = /obj/item/reagent_containers/food/snacks/donkpocket/warm/honk
	filling_color = "#XXXXXX"
	tastes = list("banana" = 2, "dough" = 2, "artificial banana flavoring" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/warm/honk
	name = "warm Honk-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's marketed towards kids."
	icon_state = "donkpocketbanana"
	bonus_reagents = list(/datum/reagent/medicine/omnizine = 1, /datum/reagent/consumable/laughter = 3)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/omnizine = 1, /datum/reagent/consumable/banana = 4, /datum/reagent/consumable/laughter = 3)
	tastes = list("dough" = 2, "artificial banana flavoring" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/berry
	name = "\improper Berry-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's marketed as a dessert item..."
	icon_state = "donkpocketberry"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/berryjuice = 3)
	cooked_type = /obj/item/reagent_containers/food/snacks/donkpocket/warm/berry
	filling_color = "#CD853F"
	tastes = list("dough" = 2, "jam" = 2)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/warm/berry
	name = "warm Berry-pocket"
	desc = "A microwave-prepared turnover filled with a variety of fillings, made by Donk! Corporation under their many flagship shell companies. Popularly eaten among students and spacers. This one's marketed as a dessert item..."
	icon_state = "donkpocketberry"
	bonus_reagents = list(/datum/reagent/medicine/omnizine = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/omnizine = 1, /datum/reagent/consumable/berryjuice = 3)
	tastes = list("dough" = 2, "warm jam" = 2)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/gondola
	name = "\improper Gondola-pocket"
	desc = "The choice to use real gondola meat in the recipe is controversial, to say the least." //Only a monster would craft this.
	icon_state = "donkpocketgondola"
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	cooked_type = /obj/item/reagent_containers/food/snacks/donkpocket/warm/gondola
	filling_color = "#CD853F"
	tastes = list("meat" = 2, "dough" = 2, "inner peace" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/donkpocket/warm/gondola
	name = "warm Gondola-pocket"
	desc = "The choice to use real gondola meat in the recipe is controversial, to say the least."
	icon_state = "donkpocketgondola"
	bonus_reagents = list(/datum/reagent/medicine/omnizine = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/omnizine = 1)
	tastes = list("meat" = 2, "dough" = 2, "inner peace" = 1)
	foodtype = GRAIN

////////////////////////////////////////////OTHER////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/cookie
	name = "cookie"
	desc = "A chocolate chip-embedded cookie."
	icon_state = "COOKIE!!!"
	bitesize = 1
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	filling_color = "#F0E68C"
	tastes = list("cookie" = 1)
	foodtype = GRAIN | SUGAR
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/cookie/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/reagent_containers/food/snacks/cookie/sleepy
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/chloralhydrate = 10)

/obj/item/reagent_containers/food/snacks/fortunecookie
	name = "fortune cookie"
	desc = "Originating from Terra, the fortune cookie is a small, sweet pastry that contains a written slip of paper with a little platitude written on it."
	icon_state = "fortune_cookie"
	trash = /obj/item/paper/paperslip
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	filling_color = "#F4A460"
	tastes = list("cookie" = 1)
	foodtype = GRAIN | SUGAR
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/fortunecookie/proc/get_fortune()
	var/atom/drop_location = drop_location()
	var/obj/item/paper/fortune = locate(/obj/item/paper) in src
	// If a fortune exists, use that.
	if (fortune)
		fortune.forceMove(drop_location)
		return fortune

	// Otherwise, use a generic one
	var/obj/item/paper/paperslip/fortune_slip = new trash(drop_location)
	fortune_slip.name = "fortune slip"
	// if someone adds lottery tickets in the future, be sure to add random numbers to this
	fortune_slip.add_raw_text(pick(GLOB.wisdoms))

	return fortune_slip

/obj/item/reagent_containers/food/snacks/fortunecookie/generate_trash()
	if(trash)
		get_fortune()

/obj/item/reagent_containers/food/snacks/poppypretzel
	name = "poppy pretzel"
	desc = "A baked pastry consisting of baked dough that's been shaped into a knot. This one is seasoned with poppy seeds."
	icon_state = "poppypretzel"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	filling_color = "#F0E68C"
	tastes = list("pretzel" = 1)
	foodtype = GRAIN | SUGAR
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_SMALL

/*/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit //PENTEST REMOVAL - Start
	name = "plump helmet biscuit"
	desc = "A baked pastry prepared primarily from a buttery and savory domestic mushroom grown across Syeben'Altch."
	icon_state = "phelmbiscuit"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	filling_color = "#F0E68C"
	tastes = list("mushroom" = 1, "biscuit" = 1)
	foodtype = GRAIN | VEGETABLES
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit/Initialize()
	var/fey = prob(10)
	if(fey)
		name = "exceptional plump helmet biscuit"
		desc = "A baked pastry prepared primarily from a buttery and savory domestic mushroom grown across Syeben'Altch. Rarely, plump helmets can excrete a medicinal substance."
		bonus_reagents = list(/datum/reagent/medicine/omnizine = 5, /datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	. = ..()
	if(fey)
		reagents.add_reagent(/datum/reagent/medicine/omnizine, 5)*/
		//PENTEST REMOVAL - End

/obj/item/reagent_containers/food/snacks/cracker
	name = "cracker"
	desc = "A thin, dry baked biscuit."
	icon_state = "cracker"
	bitesize = 1
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	filling_color = "#F0E68C"
	tastes = list("cracker" = 1)
	foodtype = GRAIN
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "A meal consisting of a sausage placed in a specially-shaped bun to hold it with your hands."
	icon_state = "hotdog"
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 3)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/ketchup = 3, /datum/reagent/consumable/nutriment/vitamin = 3)
	filling_color = "#8B0000"
	tastes = list("bun" = 3, "meat" = 2)
	foodtype = GRAIN | MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/meatbun
	name = "baozi"
	desc = "A steamed bun, filled with ground meat and prepared in batches."
	icon_state = "meatbun"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	filling_color = "#8B0000"
	tastes = list("bun" = 3, "meat" = 2)
	foodtype = GRAIN | MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/khachapuri
	name = "khachapuri"
	desc = "A loaf of bread filled with cheese, eggs, and spices. A traditional meal from Earth."
	icon_state = "khachapuri"
	list_reagents = list(/datum/reagent/consumable/nutriment = 12, /datum/reagent/consumable/nutriment/vitamin = 2)
	filling_color = "#FFFF4D"
	tastes = list("bread" = 1, "egg" = 1, "cheese" = 1)
	foodtype = GRAIN | MEAT | DAIRY


/obj/item/reagent_containers/food/snacks/sugarcookie
	name = "sugar cookie"
	desc = "A sugar-dusted cookie, known for its simplicity and sweetness."
	icon_state = "sugarcookie"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3)
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 3)
	filling_color = "#CD853F"
	tastes = list("sweetness" = 1)
	foodtype = GRAIN | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/sugarcookie/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/reagent_containers/food/snacks/chococornet
	name = "chocolate cornet"
	desc = "An Earth pastry consisting of a skewed cone filled with chocolate custard. It's a little rude to eat the frosting first with your tongue."
	icon_state = "chococornet"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#FFE4C4"
	tastes = list("biscuit" = 3, "chocolate" = 1)
	foodtype = GRAIN | JUNKFOOD

/obj/item/reagent_containers/food/snacks/oatmealcookie
	name = "oatmeal cookie"
	desc = "A cookie with sweetened oatmeal-based dough. Typically chewy."
	icon_state = "oatmealcookie"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#D2691E"
	tastes = list("cookie" = 2, "oat" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/oatmealcookie/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/reagent_containers/food/snacks/raisincookie
	name = "raisin cookie"
	desc = "A cookie with sweetened oatmeal-based dough and mixed with a dried fruit of choice."
	icon_state = "raisincookie"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#F0E68C"
	tastes = list("cookie" = 1, "raisins" = 1)
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/raisincookie/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/reagent_containers/food/snacks/cherrycupcake
	name = "cherry cupcake"
	desc = "A small cake served in a thin cup. This one has cherry-flavored icing."
	icon_state = "cherrycupcake"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 3)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#F0E68C"
	tastes = list("cake" = 3, "cherry" = 1)
	foodtype = GRAIN | FRUIT | SUGAR
	/*food_flags = FOOD_FINGER_FOOD*/
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/snacks/cherrycupcake/blue
	name = "blue cherry cupcake"
	desc = "A small cake served in a thin cup. This one has the recently genetically engineered blue cherry-flavored icing."
	icon_state = "bluecherrycupcake"
	tastes = list("cake" = 3, "blue cherry" = 1)

/obj/item/reagent_containers/food/snacks/honeybun
	name = "honey bun"
	desc = "A flat, sweetened bun that's been coated with honey."
	icon_state = "honeybun"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/honey = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/honey = 5)
	filling_color = "#F2CE91"
	tastes = list("pastry" = 1, "sweetness" = 1)
	foodtype = GRAIN | SUGAR

#define PANCAKE_MAX_STACK 10

/obj/item/reagent_containers/food/snacks/pancakes
	name = "pancake"
	desc = "A flat cake consisting of pan-frying batter, considered the sister to the other popular breakfast pastry."
	icon_state = "pancakes_1"
	item_state = "pancakes"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#D2691E"
	tastes = list("pancakes" = 1)
	foodtype = GRAIN | SUGAR | BREAKFAST

/obj/item/reagent_containers/food/snacks/pancakes/blueberry
	name = "blueberry pancake"
	desc = "A flat cake consisting of pan-frying blueberry-mixed batter, considered the sister to the other popular breakfast pastry."
	icon_state = "bbpancakes_1"
	item_state = "bbpancakes"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("pancakes" = 1, "blueberries" = 1)

/obj/item/reagent_containers/food/snacks/pancakes/chocolatechip
	name = "chocolate chip pancake"
	desc = "A flat cake consisting of pan-frying chocolate chip-mixed batter, considered the sister to the other popular breakfast pastry."
	icon_state = "ccpancakes_1"
	item_state = "ccpancakes"
	bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 2)
	list_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 3)
	tastes = list("pancakes" = 1, "chocolate" = 1)

/obj/item/reagent_containers/food/snacks/pancakes/Initialize()
	. = ..()
	update_appearance()

/obj/item/food/pancakes/update_name()
	name = contents.len ? "stack of pancakes" : initial(name)
	return ..()

/obj/item/food/pancakes/update_icon(updates=ALL)
	if(!(updates & UPDATE_OVERLAYS))
		return ..()

	updates &= ~UPDATE_OVERLAYS
	. = ..() // Don't update overlays. We're doing that here

	if(contents.len < LAZYLEN(overlays))
		overlays -= overlays[overlays.len]
	. |= UPDATE_OVERLAYS

/obj/item/reagent_containers/food/snacks/pancakes/examine(mob/user)
	var/ingredients_listed = ""
	var/pancakeCount = contents.len
	switch(pancakeCount)
		if(0)
			desc = initial(desc)
		if(1 to 2)
			desc = "A stack of fluffy pancakes."
		if(3 to 6)
			desc = "A greater stack of fluffy pancakes, leaning under its weight."
		if(7 to 9)
			desc = "A grand tower of fluffy  pancakes, which lacks structural integrity."
		if(PANCAKE_MAX_STACK to INFINITY)
			desc = "A terror-inducing spire of fluffy pancakes. By all means, it should have collapsed under its own weight, and yet..."
	var/originalBites = bitecount
	if (pancakeCount)
		var/obj/item/reagent_containers/food/snacks/S = contents[pancakeCount]
		bitecount = S.bitecount
	. = ..()
	if (pancakeCount)
		for(var/obj/item/reagent_containers/food/snacks/pancakes/ING in contents)
			ingredients_listed += "[ING.name], "
		. += "It contains [contents.len?"[ingredients_listed]":"no ingredient, "]on top of a [initial(name)]."
	bitecount = originalBites

/obj/item/reagent_containers/food/snacks/pancakes/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/pancakes/))
		var/obj/item/reagent_containers/food/snacks/pancakes/P = I
		if((contents.len >= PANCAKE_MAX_STACK) || ((P.contents.len + contents.len) > PANCAKE_MAX_STACK) || (reagents.total_volume >= volume))
			to_chat(user, span_warning("You can't add that many pancakes to [src]!"))
		else
			if(!user.transferItemToLoc(I, src))
				return
			to_chat(user, span_notice("You add the [I] to the [name]."))
			P.name = initial(P.name)
			contents += P
			update_customizable_overlays(P)
			if (P.contents.len)
				for(var/V in P.contents)
					P = V
					P.name = initial(P.name)
					contents += P
					update_customizable_overlays(P)
			P = I
			P.contents.Cut()
		return
	else if(contents.len)
		var/obj/O = contents[contents.len]
		return O.attackby(I, user, params)
	..()

/obj/item/reagent_containers/food/snacks/pancakes/update_customizable_overlays(obj/item/reagent_containers/food/snacks/P)
	var/mutable_appearance/pancake = mutable_appearance(icon, "[P.item_state]_[rand(1,3)]")
	pancake.pixel_x = rand(-1,1)
	pancake.pixel_y = 3 * contents.len - 1
	add_overlay(pancake)
	update_appearance()

/obj/item/reagent_containers/food/snacks/pancakes/attack(mob/M, mob/user, def_zone, stacked = TRUE)
	if(user.a_intent == INTENT_HARM || !contents.len || !stacked)
		return ..()
	var/obj/item/O = contents[contents.len]
	. = O.attack(M, user, def_zone, FALSE)
	update_appearance()

#undef PANCAKE_MAX_STACK

/obj/item/reagent_containers/food/snacks/cannoli
	name = "cannoli"
	desc = "A pastry consisting of a shell of fried dough, then filled with a sweetened cheese known as ricotta."
	icon_state = "cannoli"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	filling_color = "#ffffff"
	tastes = list("pastry" = 1)
	foodtype = GRAIN | DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/donut/laugh
	name = "sweet pea donut"
	desc = "A pastry composed of sweetened fried dough, shaped into a ring. Commonly enjoyed as a breakfast or snack. This one has a sweet pea-flavored frosting."
	icon_state = "donut_laugh"
	bonus_reagents = list(/datum/reagent/consumable/laughter = 3)
	tastes = list("donut" = 3, "fizzing, fruity peas" = 1,)
	is_decorated = TRUE
	filling_color = "#803280"

/obj/item/reagent_containers/food/snacks/donut/jelly/laugh
	name = "sweet pea jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with sweet pea-flavored jelly."
	icon_state = "jelly_laugh"
	bonus_reagents = list(/datum/reagent/consumable/laughter = 3)
	tastes = list("jelly" = 3, "donut" = 1, "fizzing, fruity peas" = 1)
	is_decorated = TRUE
	filling_color = "#803280"

/obj/item/reagent_containers/food/snacks/donut/jelly/slimejelly/laugh
	name = "sweet pea jelly donut"
	desc = "A pastry composed of sweetened fried dough and filled with a fruit jelly. This one is filled with sweet pea-flavored jelly, but the smell from this one is odd."
	icon_state = "jelly_laugh"
	bonus_reagents = list(/datum/reagent/consumable/laughter = 3)
	tastes = list("jelly" = 3, "donut" = 1, "fizzy, fruity peas" = 1)
	is_decorated = TRUE
	filling_color = "#803280"
