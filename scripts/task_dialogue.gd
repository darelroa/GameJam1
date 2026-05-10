extends CanvasLayer

@onready var prompt_label: Label = $Panel/VBoxContainer/PromptLabel
@onready var line_edit1: LineEdit = $Panel/VBoxContainer/HBoxContainer/LineEdit1
@onready var line_fixed_label: Label = $Panel/VBoxContainer/HBoxContainer/LineFixedLabel
@onready var line_edit2: LineEdit = $Panel/VBoxContainer/HBoxContainer2/LineEdit2
@onready var error_label: Label = $Panel/VBoxContainer/ErrorLabel
@onready var hint_label: Label = $Panel/VBoxContainer/HintLabel
@onready var answer_label: Label = $Panel/VBoxContainer/AnswerLabel
@onready var hint_button: Button = $Panel/VBoxContainer/HBoxContainer3/HintButton
@onready var submit_button: Button = $Panel/VBoxContainer/HBoxContainer3/SubmitButton
@onready var quit_button: Button = $Panel/VBoxContainer/HBoxContainer3/QuitButton
@onready var panel: Panel = $Panel

var correct_answer1: String = ""
var correct_answer2: String = ""
var calling_bag = null

var hint_state: int = 0

func _ready() -> void:
	var font = load("res://assets/fonts/PixelOperator8.ttf")
	var font_bold = load("res://assets/fonts/PixelOperator8-Bold.ttf")
	prompt_label.add_theme_font_override("font", font_bold)
	line_edit1.add_theme_font_override("font", font)
	line_edit2.add_theme_font_override("font", font)
	line_fixed_label.add_theme_font_override("font", font)
	error_label.add_theme_font_override("font", font)
	hint_label.add_theme_font_override("font", font)
	answer_label.add_theme_font_override("font", font_bold)
	hint_button.add_theme_font_override("font", font_bold)
	submit_button.add_theme_font_override("font", font_bold)
	quit_button.add_theme_font_override("font", font_bold)

	panel.visible = false
	hint_button.visible = false  

	submit_button.pressed.connect(_on_submit_pressed)
	hint_button.pressed.connect(_on_hint_button_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func open(prompt_text: String, fixed_line: String, placeholder1: String,
		  placeholder2: String, answer1: String, answer2: String, bag) -> void:
	correct_answer1 = answer1
	correct_answer2 = answer2
	calling_bag = bag

	prompt_label.text = prompt_text
	line_fixed_label.text = fixed_line

	line_edit1.placeholder_text = placeholder1
	line_edit2.placeholder_text = placeholder2
	line_edit1.text = ""
	line_edit2.text = ""

	error_label.visible = false
	hint_label.visible = false
	answer_label.visible = false
	hint_button.visible = false
	hint_button.text = "Need a hint?"
	hint_state = 0

	panel.visible = true
	line_edit1.grab_focus()
	get_tree().paused = true

func _on_submit_pressed() -> void:
	var input1: String = line_edit1.text.strip_edges()
	var input2: String = line_edit2.text.strip_edges()

	if input1 == correct_answer1 and input2 == correct_answer2:
		panel.visible = false
		get_tree().paused = false
		calling_bag.solve()
	else:
		# Show which field is wrong
		if input1 != correct_answer1 and input2 != correct_answer2:
			error_label.text = "Both answers are incorrect. Try again!"
		elif input1 != correct_answer1:
			error_label.text = "The if/elif/else line is incorrect. Try again!"
		else:
			error_label.text = "The print statement is incorrect. Try again!"
		error_label.visible = true

		hint_button.visible = true

func _on_hint_button_pressed() -> void:
	if hint_state == 0:
		
		hint_label.text = "Hint: The first blank is one of the keywords if/elif/else.
		Which one comes first? Second? Third?\n" \
						+ "The second blank should be in the format print(\"...\")"
		hint_label.visible = true
		hint_button.text = "Click to reveal answer"
		hint_state = 1

	elif hint_state == 1:
		
		answer_label.text = "Answer:\n  Line 1: %s\n  Line 2: %s" \
							% [correct_answer1, correct_answer2]
		answer_label.visible = true
		hint_button.visible = false  
		hint_state = 2

func _on_quit_pressed() -> void:
	
	panel.visible = false
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if panel.visible and event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			_on_submit_pressed()
