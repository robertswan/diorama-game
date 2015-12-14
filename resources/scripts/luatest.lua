local big_and_smooth = 
{
	random_seed = 57284398,

	landscape_params = 
	{
		scale = 256,
		octaves_max = 6,
		frequency_per_octave = 2.0,
		amplitude_per_octave = 0.5,
	},

	landscape =
	{
		perlin_scale = 1,
		perlin_translate = 0,

		solid_scale = 0.2 / 256,
		solid_translate = -0.1
	}
}

local regular_terrain = 
{
	random_seed = 0,

	landscape_params = 
	{
		scale = 128,
		octaves_max = 5,
		frequency_per_octave = 2.0,
		amplitude_per_octave = 0.5,
	},

	landscape =
	{
		perlin_scale = 1,
		perlin_translate = 0,

		solid_scale = 0.2 / 64,
		solid_translate = 0.1
	}
}

local big_twisting = 
{
	random_seed = 1234567,

	landscape_params = 
	{
		scale = 64,
		octaves_max = 4,
		frequency_per_octave = 2.0,
		amplitude_per_octave = 0.5,
	},

	landscape =
	{
		perlin_scale = 1,
		perlin_translate = 0,

		solid_scale = 0.0,
		solid_translate = 0.1
	}
}

local swiss_cheese = 
{
	random_seed = 453,

	landscape_params = 
	{
		scale = 16,
		octaves_max = 2,
		frequency_per_octave = 2.0,
		amplitude_per_octave = 0.5,
	},

	landscape =
	{
		perlin_scale = 1,
		perlin_translate = 0,

		solid_scale = 0.1 / 64.0,
		solid_translate = 0.1
	}
}

local dig_your_way_to_freedom =
{
	random_seed = 453,

	landscape_params = 
	{
		scale = 128,
		octaves_max = 6,
		frequency_per_octave = 2.0,
		amplitude_per_octave = 0.5,
	},

	landscape =
	{
		perlin_scale = 1,
		perlin_translate = 0,

		solid_scale = -0.3 / 64.0,
		solid_translate = 0.0
	}
}

terrain_settings = regular_terrain
