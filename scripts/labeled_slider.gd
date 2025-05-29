extends HBoxContainer

@export var text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = text
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
