extends Control

@export var questionsPath = "res://resources/questions.json"
@export var roundsBetweenModifiers: int = 3
@export var totalRounds: int = 12
@export var goal: int = 3500

@onready var questions: Array[Question] = loadQuestions()
@onready var QuestionRequest: HTTPRequest = $QuestionRequest

#var currentQuestionIndex: int = -1
var modifiers: Array[Modifier] = []
var currentScore: int = 0 
var currentRound: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	displayRoundInfo(0)
	
	#var questions: Array[Question] = loadQuestions()
	#$TriviaBoard.setQuestion(questions[1])
	#$TriviaBoard.setQuestion(questions[2])
	setNextQuestion()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loadQuestions() -> Array[Question]:
	if not FileAccess.file_exists(questionsPath):
		print("Missing questions file")
		return []
		
	var questions: Array[Question] = []
	var questionsFile = FileAccess.open(questionsPath, FileAccess.READ)
	var questionsArray = JSON.parse_string(questionsFile.get_as_text())
	for question in questionsArray:
		questions.append(Question.newQuestion(
			question["question"],
			question["difficulty"],
			question["options"],
			question["subject"]))
	# TODO: read questions from file
	#var q
	#Question.new()
	return questions
	
#func save_data() -> void:
	#var save_file = FileAccess.open("user://game_data.save", FileAccess.WRITE)
	#var json_string = JSON.stringify(highScore)
	#print(json_string)
	#save_file.store_line(json_string)
	#save_file.close()

func displayText(text: String):
	print(text)
	
	# TODO: display on screen
	
func displayRoundInfo(score: int):
	$HBoxContainer/RoundInfo/Score.text = "Score: %d/%d\nLast: %d\nRound: %d/%d" % [currentScore, goal, score, currentRound + 1, totalRounds]

func calcScore(question: Question, correct: bool):
	var score = 1 if correct else 0
	score *= (5 + 2 * question.difficulty) * 10
	if correct:
		print()
	score = applyModifiers(score, question, correct)
	score *= question.difficulty
	print(score)
	currentScore += score
	currentRound += 1
	displayRoundInfo(score)
	if currentRound == totalRounds:
		# TODO: change to score calc end of game scene
		PlayerInfo.lastScore = currentScore
		PlayerInfo.highScore = max(PlayerInfo.highScore, currentScore)
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	elif currentRound % roundsBetweenModifiers == 0:
		presentModifierOptions()
	else:
		setNextQuestion()

	

func applyModifiers(score: int, question: Question, correct: bool) -> int:
	for modifier in modifiers:
		# TODO: call modifyScoreWithContext instead
		#		and add in context
		score = modifier.modifyScoreWithContext(
			score, 
			correct, 
			question.difficulty,
			question.subject)
	return score
	
func presentModifierOptions():
	$UpgradesMenu.generateUpgrades()
	$UpgradesMenu.show()
	$HBoxContainer/TriviaBoard.process_mode = Node.PROCESS_MODE_DISABLED
	pass
	
func setNextQuestion() -> void:
	#currentQuestionIndex += 1
	# handle picking new question
	# reactivate board
	$HBoxContainer/TriviaBoard.process_mode = Node.PROCESS_MODE_INHERIT
	# grab new Qs in background if running low
	if questions.size() < 6:
		QuestionRequest.makeRequest()
	$HBoxContainer/TriviaBoard.setQuestion(questions.pop_at(randi_range(0, questions.size()-1)))


func modifier_selected(modifier: Modifier) -> void:
	modifiers.append(modifier)
	$UpgradesMenu.hide()
	$HBoxContainer/Modifiers/Modifiers.text = $HBoxContainer/Modifiers/Modifiers.text + "\n\n" + modifier.choiceText
	#for m in modifiers:
		#print(m.choiceText)
	setNextQuestion()
	pass # Replace with function body.


# TODO: change to take in a question
func _on_trivia_board_answered(question: Question, correct: bool) -> void:
	print(("Correctly" if correct else "Incorrectly") + " answered "
		+ ("easy" if question.difficulty == 1 else ("medium" if question.difficulty == 2 else "hard"))
		+ " question.")
	calcScore(question, correct)
	pass # Replace with function body.
