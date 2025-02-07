extends HSlider

#@onready var preview = %Preview 

@export var label :Label

func _ready():
	label.text = str(value)
	value_changed.connect(_change_text_label)
	

func _change_text_label(value: float):
	#preview.material.get("shader_parameter/noise_map").get("noise").set("seed", self.value)
	Signals.reasign_values_signal.emit()
	label.text = str(value)
