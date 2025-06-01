@tool
extends HBoxContainer

@export var audioBusName = "Master"
@export var text: String

@onready var label: Label = $Label
@onready var slider: HSlider = $Slider
@onready var bus = AudioServer.get_bus_index(audioBusName)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	
func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(slider.value))
