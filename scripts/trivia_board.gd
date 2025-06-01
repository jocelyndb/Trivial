extends Control
		
signal answered(question: Question, correct: bool)
	
@onready var questionLabel: Label = $BoardSeparator/Top/Question
@onready var mc_options: GridContainer = $BoardSeparator/Bottom/MCOptions
@onready var optionButtons: Array[Node] = $BoardSeparator/Bottom/MCOptions.get_children()

	
var currentQuestion: Question

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_select")):
		print("Setting question")
		setQuestion(Question.newQuestion(
			"test question text", 
			5, 
			{
				"First choice, incorrect":0,
				"Second choice, correct":1,
				"Third choice, correct":1,
				"Fourth choice, disabled correct":-1,
				# NOTE: ideally no more choices as these are read in order
				"Fifth choice, disabled incorrect":-2,
				#"Sixth choice, incorrect":0 
			}))
	pass
	
func setQuestion(question: Question) -> void:
	currentQuestion = question
	# Disconnect all existing button signals
	for button in optionButtons:
		button.disconnect("pressed", onMCPressed)
	questionLabel.text = question.question
	#var optionButtons: Array[Node] = $BoardSeparator/Bottom/MCOptions.get_children()
	optionButtons.shuffle()
	# Check for an enabled correct answer option
	var correctOptionIndex: int = question.options.values().find(1)
	# If correct option present, assign it to first button
	var finalButtonIndex = optionButtons.size()
	if correctOptionIndex >= 0:
		setMCButton(optionButtons.back(), question.options.keys()[correctOptionIndex])
		finalButtonIndex -= 1
	# Add other answer options in order to shuffled buttons
	var buttonIndex = 0
	for optionIndex in question.options.size():
		# Skip already set correct option (will never trigger if one not found)
		if optionIndex == correctOptionIndex or question.options.values()[optionIndex] < 0:
			optionIndex += 1
			continue
		# End if reached already set last button
		if buttonIndex == finalButtonIndex:
			break
		setMCButton(optionButtons[buttonIndex], question.options.keys()[optionIndex])
		print("Set button: %d" % buttonIndex)
		optionIndex += 1
		buttonIndex += 1
	# Hide buttons not assigned an answer choice
	# TODO: make this a look instead of hiding
	while (buttonIndex < finalButtonIndex):
		optionButtons[buttonIndex].hide()
		print("Hiding: %d" % buttonIndex)
		buttonIndex += 1
		
	print(correctOptionIndex)
	print(question.options.size())
	print(optionButtons.size())

func setMCButton(button: Button, text: String):
	print(text)
	button.connect("pressed", onMCPressed.bind(text))
	button.text = text
	button.show()
	pass
	
func onMCPressed(answer: String):
	print(answer)
	print(currentQuestion.options[answer])
	answered.emit(currentQuestion, currentQuestion.options[answer] == 1)
