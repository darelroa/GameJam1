extends Area2D

@onready var ui_prompt = $CanvasLayer/question_ui
@onready var answer_input = $CanvasLayer/question_ui/LineEdits

var is_active = true

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group('player') and is_active:
		show_question()

func show_question():
	ui_prompt.show()
	get_tree().paused = true
	answer_input.grab_focus()
	
func check_answer(player_answer)
	
