extends HSlider


@export var label :Label

func _ready():
	label.text = str(value)
	value_changed.connect(_change_text_label)
	

func _change_text_label(value: float):
	label.text = str(value)
