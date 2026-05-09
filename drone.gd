extends Area2D

@onready var ui_prompt = $CanvasLayer/QuestionUI
@onready var answer_input = $CanvasLayer/QuestionUI/LineEdits

var is_active = true

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group('player1') and is_active:
		show_question()

func show_question():
	ui_prompt.show()
	get_tree().paused = true
	answer_input.grab_focus()
	
func check_answer(player_answer):
	if player_answer == '4':
		level_up_drone()

func level_up_drone():
	var tween = create_tween()
	tween.tween_property(self, 'position: y', position.y - 50, 1.5)
	
	
