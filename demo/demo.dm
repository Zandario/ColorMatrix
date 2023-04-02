#define DEBUG

/world
	fps = 30
	mob = /mob/player

/atom
	var/base_icon_state
	var/variations

/atom/New(loc)
	. = ..()
	if(variations && base_icon_state)
		icon_state = "[base_icon_state][rand(0, variations)]"

/turf/grass
	icon       = 'turfs.dmi'
	icon_state = "grass0"
	base_icon_state = "grass"
	variations = 3

/mob
	icon       = 'mobs.dmi'
	icon_state = "mob0"
	base_icon_state = "mob"
	variations = 3

/mob/player
	icon_state = "mob0"
	base_icon_state = null
	variations = null

/mob/verb/Pick_Color(newColor as color)

	var/ColorMatrix/c = new(newColor)

	animate(client, color = c.matrix, time = 10)


/mob/verb/Pick_ColorSatContBright(s as num, c as num, b as num)

	var/ColorMatrix/cm = new(s, c, b)

	animate(client, color = cm.matrix, time = 10)


/mob/verb/Pick_ColorPreset(newColor in list("Invert", "BGR", "Greyscale", "Sepia", "Black & White", "Polaroid", "GRB", "RBG", "BRG", "GBR", "Normal", "avali"))

	if(newColor == "Normal")
		animate(client, color = null, time = 10)

	else
		var/ColorMatrix/c = new(newColor)
		animate(client, color = c.matrix, time = 10)


/mob/verb/Pick_ColorblinessPreset(newColor in list("monochromia", "achromatomaly", "achromatopsia", "deuteranopia", "deuteranomaly", "protanopia", "protanomaly", "tritanopia", "tritanomaly", "Normal"))

	if(newColor == "Normal")
		animate(client, color = null, time = 10)

	else
		var/ColorMatrix/c = new(newColor)
		animate(client, color = c.matrix, time = 10)
