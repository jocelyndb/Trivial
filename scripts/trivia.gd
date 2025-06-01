extends Control

@export var questionsPath = "res://resources/questions.json"
@export var questionsBetweenModifiers: int = 3
#@export var totalRounds: int = 12
@export var goals: Array[int] = [150, 300, 500, 1000, 2000, 5000, 8000]

@onready var questions: Array[Question] = loadQuestions()
@onready var QuestionRequest: HTTPRequest = $QuestionRequest
@onready var upgrades_menu: HBoxContainer = $UpgradesMenu
@onready var trivia_board: MarginContainer = $HBoxContainer/TriviaBoard
@onready var score_label: Label = $HBoxContainer/RoundInfo/Score
@onready var modifiers_container: VBoxContainer = $HBoxContainer/ScrollContainer/Modifiers
@onready var background: TextureRect = $Background

#var currentQuestionIndex: int = -1
var modifiers: Array[Modifier] = []
var currentScore: int = 0 
var roundScore: int = 0
var currentRound: int = 0
var answeredThisRound = 0
var roundGoal: int = goals[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	displayRoundInfo(0)
	setNextQuestion()

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
	score_label.text = "Round %d
		%d/%d
		Question %d/%d" % [
			currentRound + 1, 
			roundScore, 
			roundGoal, 
			answeredThisRound + 1, 
			questionsBetweenModifiers, 
			#score,
		]

func calcScore(question: Question, correct: bool):
	var score = 1 if correct else 0
	score *= (5 + 2 * question.difficulty) * 10
	if correct:
		print()
	score = applyModifiers(score, question, correct)
	score *= question.difficulty
	print(score)
	currentScore += score
	roundScore += score
	answeredThisRound += 1
	# Handle moving to next question/round
	if answeredThisRound == questionsBetweenModifiers:
		endOfRound()
	displayRoundInfo(score)
	setNextQuestion()

func endOfRound() -> void:
	PlayerInfo.lastScore = currentScore
	PlayerInfo.highScore = max(PlayerInfo.highScore, currentScore)
	PlayerInfo.highestRound = max(PlayerInfo.highestRound, currentRound + 1)
	PlayerInfo.save_data()
	if roundScore >= roundGoal:
		currentRound += 1
		roundScore = 0
		answeredThisRound = 0
		if currentRound >= goals.size():
			roundGoal = goals.back()
		else:
			roundGoal = goals[currentRound]
		presentModifierOptions()
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

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
	trivia_board.process_mode = Node.PROCESS_MODE_DISABLED
	upgrades_menu.generateUpgrades()
	upgrades_menu.show()
	
func setNextQuestion() -> void:
	# grab new Qs in background if running low
	if questions.size() < 6:
		QuestionRequest.makeRequest()
	if questions.size() <= 1:
		roundScore = 0
		endOfRound()
	# handle pick new question
	trivia_board.setQuestion(questions.pop_at(randi_range(0, questions.size()-1)))


func modifier_selected(modifier: Modifier) -> void:
	modifiers.append(modifier)
	
	# Hide upgrades menu and reactivate questions
	upgrades_menu.hide()
	trivia_board.process_mode = Node.PROCESS_MODE_INHERIT
	var modifierCard: Button = SFXButton.new()
	modifierCard.autowrap_mode = TextServer.AUTOWRAP_WORD
	modifierCard.disabled = true
	modifierCard.text = modifier.choiceText
	#modifierCard.set_anchors_preset(PRESET_CENTER)
	modifierCard.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	#modifierCard.horizontal_alignhorizontal_alignment
	modifierCard.add_theme_font_size_override("font_size", 32)
	modifiers_container.add_child(modifierCard)
	
	
	#$HBoxContainer/Modifiers/Modifiers.text = $HBoxContainer/Modifiers/Modifiers.text + "\n\n" + modifier.choiceText
	#for m in modifiers:
		#print(m.choiceText)
	setNextQuestion()
	pass # Replace with function body.


# TODO: change to take in a question
func _on_trivia_board_answered(question: Question, correct: bool) -> void:
	print(("Correctly" if correct else "Incorrectly") + " answered "
		+ ("easy" if question.difficulty == 1 else ("medium" if question.difficulty == 2 else "hard"))
		+ " question.")
	background.material.set_shader_parameter(&"correct", correct)
	if correct:
		SoundManager.playCorrect()
	else:
		SoundManager.playIncorrect()
	calcScore(question, correct)
	pass # Replace with function body.
