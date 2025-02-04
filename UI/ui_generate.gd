class_name UI_Generate
extends CanvasLayer


@onready var value_seed =%SeedSlider
@onready var value_frequency =%FrequencySlider
@onready var value_lacunarity =%LacunaritySlider
@onready var value_noise =%NoiseTypeSlider
@onready var preview= %Preview 
@onready var terrain_node = $"../Terrain"
@onready var load_screen = %LoadingScreen

var noisetexture = NoiseTexture2D.new() 
@export var noise: FastNoiseLite



signal generate_terrain_via_ui

func _ready():
	load_screen.hide()
	#noisetexture.width = 2048
	#noisetexture.height = 2048
	#noisetexture.noise = noise
	#var material : ShaderMaterial = preview.material
	preview.material.get("shader_parameter/noise_map").set("noise", noise)
	#preview.material = material





func reasign_values():
	noise.seed = int(value_seed.value)
	noise.frequency = float(value_frequency.value)
	noise.fractal_lacunarity = float(value_lacunarity.value)
	noise.noise_type = int(value_noise.value)
	preview.material.get("shader_parameter/noise_map").set("noise", noise)
	#noisetexture.noise = terrain_node.noise
	#var material : ShaderMaterial = preview.material
	#preview.material.set("shader_parameter/noise_map", noisetexture)
	#preview.material = material
	

func toggle_loading_screen():
	#print(%LoadingScreen.visible)
	if (load_screen.visible):
		load_screen.visible =false
	else:
		load_screen.visible = true


func _on_generate_pressed():
	reasign_values()
	
	generate_terrain_via_ui.emit()
