extends Node

@onready var hover: AudioStreamPlayer = $hover
@onready var press: AudioStreamPlayer = $press
@onready var correct: AudioStreamPlayer = $correct
@onready var incorrect: AudioStreamPlayer = $incorrect
@onready var bgmusic: AudioStreamPlayer = $bgmusic

func _ready() -> void:
	bgmusic.play()


func playHover() -> void:
	hover.play()
	
func playPress() -> void:
	press.play()
	
func playCorrect() -> void:
	correct.play()
	
func playIncorrect() -> void:
	incorrect.play()
	
func _on_bgmusic_finished() -> void:
	bgmusic.play()
