extends HSlider

@export var audioBusName = "Master"

@onready var bus = AudioServer.get_bus_index(audioBusName)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(bus))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	pass
