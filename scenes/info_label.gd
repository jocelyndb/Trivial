@tool
extends Label

@export var infoVariable: String = "highScore"
@export var labelText: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = labelText + str(PlayerInfo[infoVariable])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
