extends Control

class Question:
	# Question text
	var question: String
	# Correct answer
	var answer: String
	# Alternate answers to confuse player
	# Dictionary[String, int]
	# Int is one of:
	# 	- -1 Disabled
	#	- 0  Enabled, Incorrect
	# 	- 1	 Enabled, Correct
	var options: Dictionary
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setQuestion(question: Question) -> void:
	$BoardSeparator/Top/Question.text = question.question
	for ansText in question.options.keys():
		# TODO: set answer options
		pass
	pass
