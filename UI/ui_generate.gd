extends CanvasLayer


@onready var value_seed =%SeedSlider
@onready var value_frequency =%FrequencySlider
@onready var value_lacunarity =%LacunaritySlider
@onready var value_noise =%NoiseTypeSlider

@onready var terrain_node = $"../Terrain"

signal generate_terrain_via_ui



func reasign_values():
	terrain_node.noise.seed = int(value_seed.value)
	terrain_node.noise.frequency = float(value_frequency.value)
	terrain_node.noise.fractal_lacunarity = float(value_lacunarity.value)
	terrain_node.noise.noise_type = float(value_noise.value)

func _on_generate_pressed():
	reasign_values()
	
	print(terrain_node.noise.seed)
	print(terrain_node.noise.frequency)
	generate_terrain_via_ui.emit()
