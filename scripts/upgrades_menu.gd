extends Control

signal modifierSelected(modifier: Modifier)

@onready var modifierOptions: Array[Callable] = [
	ModifierAdd.new,
	ModifierMult.new,
	ModifierStreakAdd.new,
	ModifierStreakMult.new
	]
	
func _ready() -> void:
	hide()
	generateUpgrades()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#for child in get_children():
			#child.queue_free()
		#generateUpgrades()

func generateUpgrades() -> void:
	for child in get_children():
		if child is Button:
			child.queue_free()
	for i in 3:
		print("Generating upgrade")
		var testLabel = Button.new()
		testLabel.autowrap_mode = TextServer.AUTOWRAP_WORD
		testLabel.custom_minimum_size.x = 400
		var modifier: Modifier = generateModifier()
		testLabel.add_child(modifier)
		print(modifier.choiceText)
		testLabel.text = modifier.choiceText
		testLabel.pressed.connect(
			func ():
				testLabel.remove_child(modifier)
				modifierSelected.emit(modifier)
				)
		add_child(testLabel)
	print("Generated all upgrades")
		
func generateModifier() -> Modifier:
	return modifierOptions.pick_random().call()
		
