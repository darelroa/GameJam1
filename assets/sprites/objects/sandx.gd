extends Area2D



@onready var ui_prompt = $CanvasLayer/QuestionUI
@onready var answer_input = $CanvasLayer/QuestionUI/PanelContainer2/MarginContainer/VBoxContainer/LineEdit
@onready var submit_button = $CanvasLayer/QuestionUI/PanelContainer2/MarginContainer/VBoxContainer/Button

@onready var wrong_popup = $CanvasLayer/WrongAnswerPopUp
@onready var help_button = $CanvasLayer/WrongAnswerPopUp/PanelContainer2/MarginContainer/VBoxContainer/HelpButton
@onready var try_again_button = $CanvasLayer/WrongAnswerPopUp/PanelContainer2/MarginContainer/VBoxContainer/TryAgainButton


var is_active = true

func _ready():
	body_entered.connect(_on_body_entered)
	submit_button.pressed.connect(_on_submit_pressed)
	answer_input.text_submitted.connect(check_answer)
	help_button.pressed.connect(_on_help_pressed)
	try_again_button.pressed.connect(_on_try_again_pressed)
	
func _on_body_entered(body):
	if body.name =='player1' and is_active:
		show_question()

func show_question():
	ui_prompt.show()
	get_tree().paused = true
	answer_input.grab_focus()

func _on_submit_pressed():
	check_answer(answer_input.text)
	
func check_answer(player_answer):
	if player_answer == '(Reef, BareSpot)':
		ui_prompt.hide()
		wrong_popup.hide()
		get_tree().paused = false
		is_active = false
		level_up_drone()
	
	else:
		ui_prompt.hide()
		wrong_popup.show()
	
func _on_help_pressed():
	pass

func _on_try_again_pressed():
	wrong_popup.hide()
	show_question()

func level_up_drone():
	get_tree().call_group("sandx", "hide")
	var coral_instance = preload("res://assets/healthycoral.tscn").instantiate()
	coral_instance.global_position = global_position
	get_parent().add_child(coral_instance)
