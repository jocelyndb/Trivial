extends HBoxContainer

@export var text: String
@export var audioBusName = "Master"

@onready var bus = AudioServer.get_bus_index(audioBusName)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Label.text = text
	$VolumeSlider.bus = bus
	$VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	pass # Replace with function body.
