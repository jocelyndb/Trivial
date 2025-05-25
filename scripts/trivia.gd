extends Control

# TODO: put questions in file
@export var questionsPath = "res://resources/questions.json"
@onready var questions: Array[Question] = loadQuestions()
@onready var currentQuestionIndex: int = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	questions.shuffle()
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

func setNextQuestion() -> void:
	currentQuestionIndex += 1
	$TriviaBoard.setQuestion(questions[currentQuestionIndex])
	


func _on_trivia_board_answered(correct: int, difficulty: int) -> void:
	print(("Correctly" if correct > 0 else "Incorrectly") + " answered "
		+ ("easy" if difficulty == 1 else ("medium" if difficulty == 2 else "hard"))
		+ " question.")
	setNextQuestion()
	pass # Replace with function body.
