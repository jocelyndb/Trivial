extends TextureRect

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var spiral_player: AnimationPlayer = $SpiralPlayer
@onready var bounce_player: AnimationPlayer = $BouncePlayer

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bounce_player.play("bounce")

func correct(duration: float = 2.0):
	spiral_player.play(&"Correct Spiral In")
	await get_tree().create_timer(duration).timeout
	spiral_player.play(&"Correct Spiral Out")
	
func incorrect(duration: float = 2.0):
	spiral_player.play(&"Incorrect Spiral In")
	await get_tree().create_timer(duration).timeout
	spiral_player.play(&"Incorrect Spiral Out")
