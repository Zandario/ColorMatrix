/**
 * a color matrix datum
 */

/ColorMatrix

	var/list/matrix
	var/combined = 1

	var/const/lumR = 0.3086 //  or  0.2125
	var/const/lumG = 0.6094 //  or  0.7154
	var/const/lumB = 0.0820 //  or  0.0721

/**
 * Constructs a color matrix
 *
 * @param mat        a color, preset name, saturation number or a color matrix list
 * @param contrast   color matrix contrast
 * @param brightness color matrix brightness
 */
/ColorMatrix/New(mat, contrast = 1, brightness)
	..()

	if(istext(mat))

		SetPreset(mat)

		if(!matrix)
			SetColor(mat, contrast, brightness)

	else if(isnum(mat))

		SetSaturation(mat, contrast, brightness)
	else
		matrix = mat


/**
 * Resets color matrix list
 *
 */
/ColorMatrix/proc/Reset()
	matrix = list(
		1,0,0,
		0,1,0,
		0,0,1
	)

/**
 * Returns a new color matrix list with given contrast
 *
 * @param contrast  color matrix new contrast
 * @return mat      a new matrix with altered contrast
 */
/ColorMatrix/proc/Get(contrast = 1)

	var/list/mat = matrix
	mat = mat.Copy()

	for(var/i = 1 to min(mat.len, 12))
		mat[i] *= contrast

	return mat

/**
 * Sets new color matrix list based on saturation
 * You can also set contrast and brightness
 *
 * @param s  saturation
 * @param c  optional contrast
 * @param b  optional brightness
 */
/ColorMatrix/proc/SetSaturation(s, c = 1, b)

	var/sr = (1 - s) * lumR
	var/sg = (1 - s) * lumG
	var/sb = (1 - s) * lumB

	matrix = list(
		c * (sr + s), c * (sr),     c * (sr),
		c * (sg),     c * (sg + s), c * (sg),
		c * (sb),     c * (sb),     c * (sb + s)
	)

	SetBrightness(b)

/**
 * Sets color matrix brightness
 *
 * @param brightness  new brightness
 */
/ColorMatrix/proc/SetBrightness(brightness)
	if(isnull(brightness))
		return

	if(!matrix)
		Reset()


	if(matrix.len == 9 || matrix.len == 16)
		matrix += brightness
		matrix += brightness
		matrix += brightness

		if(matrix.len == 16)
			matrix += 0

	else if(matrix.len == 12)
		for(var/i = matrix.len to matrix.len - 3 step -1)
			matrix[i] = brightness

	else if(matrix.len == 3)
		for(var/i = matrix.len - 1 to matrix.len - 4 step -1)
			matrix[i] = brightness

/**
 * Converts 2 digit hex to decimal value
 *
 * @param hex     hex to convert
 * @return 0-255  decimal value
 */
/ColorMatrix/proc/hex2value(hex)
	var/num1 = copytext(hex, 1, 2)
	var/num2 = copytext(hex, 2)

	if(isnum(text2num(num1)))
		num1 = text2num(num1)
	else
		num1 = text2ascii(lowertext(num1)) - 87

	if(isnum(text2num(num1)))
		num2 = text2num(num1)
	else
		num2 = text2ascii(lowertext(num2)) - 87

	return num1 * 16 + num2

/**
 * Creates a color matrix based off a color
 *
 * @param color      color to base new matrix on
 * @param contrast   optional contrast
 * @param brightness optional brightness
 */
/ColorMatrix/proc/SetColor(color, contrast = 1, brightness)

	var/rr = hex2value(copytext(color, 2, 4)) / 255
	var/gg = hex2value(copytext(color, 4, 6)) / 255
	var/bb = hex2value(copytext(color, 6, 8)) / 255

	rr = round(rr * 1000) / 1000 * contrast
	gg = round(gg * 1000) / 1000 * contrast
	bb = round(bb * 1000) / 1000 * contrast

	matrix = list(
		list(rr, gg, bb),
		list(rr, gg, bb),
		list(rr, gg, bb),
	)

	SetBrightness(brightness)

/**
 * Sets color matrix list from a preset
 *
 * @param preset  preset to set
 */
/ColorMatrix/proc/SetPreset(preset)
	switch(lowertext(preset))
		if("invert")
			matrix = list(
				list(-1,  0,  0),
				list( 0, -1,  0),
				list( 0,  0, -1),
				list( 1,  1,  1),
			)
		if("greyscale", "monochromia")
			matrix = list(
				list(0.33, 0.33, 0.33),
				list(0.59, 0.59, 0.59),
				list(0.11, 0.11, 0.11),
			)
		if("sepia")
			matrix = list(
				list(0.393, 0.349, 0.272),
				list(0.769, 0.686, 0.534),
				list(0.189, 0.168, 0.131),
			)
		if("black & white")
			matrix = list(
				list( 1.5, 1.5, 1.5),
				list( 1.5, 1.5, 1.5),
				list( 1.5, 1.5, 1.5),
				list(-1,  -1,  -1  ),
			)
		if("polaroid")
			matrix = list(
				list( 1.438, -0.062, -0.062),
				list( 0.122,  1.378, -0.122),
				list( 0.016, -0.016,  1.483),
				list(-0.03,   0.05,  -0.02 ),
			)
		if("bgr")
			matrix = list(
				list(0, 0, 1),
				list(0, 1, 0),
				list(1, 0, 0),
			)
		if("brg")
			matrix = list(
				list(0, 0, 1),
				list(1, 0, 0),
				list(0, 1, 0),
			)
		if("gbr")
			matrix = list(
				list(0, 1, 0),
				list(0, 0, 1),
				list(1, 0, 0),
			)
		if("grb")
			matrix = list(
				list(0, 1, 0),
				list(1, 0, 0),
				list(0, 0, 1),
			)
		if("rbg")
			matrix = list(
				list(1, 0, 0),
				list(0, 0, 1),
				list(0, 1, 0),
			)
		if("rgb")
			matrix = list(
				list(1, 0, 0),
				list(0, 1, 0),
				list(0, 0, 1),
			)
		// Colorblindness matrices.
		if("achromatomaly")
			matrix = list(
				list(0.62, 0.32, 0.06),
				list(0.16, 0.78, 0.06),
				list(0.16, 0.32, 0.52),
			)
		if("achromatopsia")
			matrix = list(
				list(0.30, 0.59, 0.11),
				list(0.30, 0.59, 0.11),
				list(0.30, 0.59, 0.11),
			)
		if("deuteranomaly")
			matrix = list(
				list(0.80,0.20,0),
				list(0.26,0.74,0),
				list(0,0.14,0.86),
			)
		if("deuteranopia")
			matrix = list(
				list(0.63, 0.38, 0   ),
				list(0.70, 0.30, 0   ),
				list(0,    0.30, 0.70),
			)
		// monochromia would be here, but it's the same as greyscale.
		if("protanomaly")
			matrix = list(
				list(0.82, 0.18, 0   ),
				list(0.33, 0.67, 0   ),
				list(0,    0.13, 0.88),
			)
		if("protanopia")
			matrix = list(
				list(0.57, 0.43, 0   ),
				list(0.56, 0.44, 0   ),
				list(0,    0.24, 0.76),
			)
		if("tritanomaly")
			matrix = list(
				list(0.97, 0.03, 0   ),
				list(0,    0.73, 0.27),
				list(0,    0.18, 0.82),
			)
		if("tritanopia")
			matrix = list(
				list(0.95, 0.05, 0   ),
				list(0,    0.43, 0.57),
				list(0,    0.48, 0.53),
			)

		if("avali")
			matrix = list(
				list(
					0.5,    // RR
					0.25,    // RB
					0.25,    // RG
					1,    // RA
				),
				list(
					0.25, // GR
					0.5,    // GB
					0.25, // GG
					1,    // GA
				),
				list(
					0.25,  // BR
					0.25, // BB
					0.5,    // BG
					1,    // BA
				),
			)
			// matrix = list(
			// 	/* RR */ 1   , /* RB */ 0   , /* RG */ 1   ,
			// 	/* GR */ 1   , /* GB */ 0   , /* GG */ 0   ,
			// 	/* BR */ 0   , /* BB */ 0   , /* BG */ -1   ,
			// )

/**
 * Sets color matrix list to an average of two lists
 * it will not combine if the given list/matrix is using alpha while this one doesn't
 *
 * @param mat  matrix or list to combine with this one
 */
/ColorMatrix/proc/Combine(list/mat)
	if(!matrix)
		return

	if(istype(mat, /ColorMatrix))
		mat = mat:matrix

	if(mat.len % 3 != matrix.len % 3 || mat.len < 9 || matrix.len < 9)
		return

	for(var/i = 1 to matrix.len)
		matrix[i] = ((matrix[i] * combined) + mat[i]) / (combined + 1)

	combined++

/**
 * Removes previously combined color matrix list
 * it will not split if the given list/matrix is using alpha while this one doesn't
 *
 * @param mat  matrix to remove from this one
 */
/ColorMatrix/proc/Split(list/mat)
	if(!matrix)
		return

	if(istype(mat, /ColorMatrix))
		mat = mat:matrix

	if(mat.len % 3 != matrix.len % 3 || mat.len < 9 || matrix.len < 9)
		return

	for(var/i = 1 to matrix.len)
		matrix[i] = ((matrix[i] * combined) - mat[i]) / (combined - 1)

	combined--
