-- Eldritch is a community-driven dark theme inspired by Lovecraftian horror. With tones from the dark abyss and an emphasis on green and blue, it caters to those who appreciate the darker side of life.
-- https://github.com/eldritch-theme/eldritch.nvim

-- Configuration
function Config()
	return {
		transparent = false, -- set the background transparent
	}
end

-- Setup
return {
	"eldritch-theme/eldritch.nvim",
	lazy = false,
	priority = 1000,
	config = Config(),
}
