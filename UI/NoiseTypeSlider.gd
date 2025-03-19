extends HSlider


@export var label :Label

func _ready():
	label.text = "smoth simple"
	value_changed.connect(_change_text_label)
	

func _change_text_label(value: float):
	#print
	label.text = choose_label_name_depending_on_noise_type(value)
	Signals.reasign_values_signal.emit()
	
func choose_label_name_depending_on_noise_type(value:int):
	var text
	match value:
		0:
			text ="1 simple"
		1:
			text ="smoth simple"
		2:
			text ="cellurar"
		3:
			text ="perlin"
		4:
			text ="cubic of value"
		5:
			text ="value"
	
	""" 
	match value:
		0:
			text ="TYPE_SIMPLEX"
		1:
			text ="TYPE_SIMPLEX_SMOOTH"
		2:
			text ="TYPE_CELLULAR"
		3:
			text ="TYPE_PERLIN"
		4:
			text ="TYPE_VALUE_CUBIC"
		5:
			text ="TYPE_VALUE"
	"""
	return text
