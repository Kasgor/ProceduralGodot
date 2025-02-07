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
	Signals.connect("toggle_load_screen", toggle_loading_screen_generate)
	Signals.connect("reasign_values_signal", reasign_values)
	Signals.toggle_load_screen.emit(false)
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
	

func toggle_loading_screen_generate(generate: bool):
	#print(%LoadingScreen.visible)
	if (load_screen.visible):
		load_screen.hide()
	else:
		load_screen.show()
	await RenderingServer.frame_post_draw
	await get_tree().process_frame
	if (generate):
		Signals.generate_terrain_via_ui.emit()
	#Signals.finished.emit()
	


func _on_generate_pressed():
	reasign_values()
	Signals.emit_signal("toggle_load_screen", true)
	#await Signals.finished
	
	
	


func _on_change_material_pressed():
	Signals.emit_signal("change_material_of_the_mesh_signal")# Replace with function body.
