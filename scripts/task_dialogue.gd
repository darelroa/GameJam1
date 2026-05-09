extends CanvasLayer

# References to child nodes
@onready var prompt_label: Label = $Panel/VBoxContainer/PromptLabel
@onready var line_edit: LineEdit = $Panel/VBoxContainer/LineEdit
@onready var error_label: Label = $Panel/VBoxContainer/ErrorLabel
@onready var submit_button: Button = $Panel/VBoxContainer/SubmitButton
@onready var panel: Panel = $Panel

# We store the correct answer and the bag that called us
var correct_answer: String = ""
var calling_bag = null   # reference to the TrashBag node

func _ready() -> void:
	panel.visible = false   # dialog starts hidden
	# Connect the Submit button's "pressed" signal to our function
	submit_button.pressed.connect(_on_submit_pressed)

func open(prompt_text: String, answer: String, bag) -> void:
	# Called by the TrashBag script to open this dialog
	correct_answer = answer
	calling_bag = bag
	prompt_label.text = prompt_text
	line_edit.text = ""         # clear any previous input
	error_label.visible = false # hide error from last attempt
	panel.visible = true
	line_edit.grab_focus()      # put the cursor in the text box automatically

	# Freeze the player while the dialog is open
	get_tree().paused = true
	# Note: the CanvasLayer itself must be set to process while paused.
	# Set this node's Process Mode to "Always" in the Inspector.

func _on_submit_pressed() -> void:
	var player_input: String = line_edit.text.strip_edges()
	# strip_edges() removes accidental spaces at the start/end

	if player_input == correct_answer:
		# Correct!
		panel.visible = false
		get_tree().paused = false   # unfreeze the game
		calling_bag.solve()         # tell the bag it was solved
	else:
		# Wrong answer — show the error and let them try again
		error_label.visible = true
		line_edit.text = ""
		line_edit.grab_focus()

func _input(event: InputEvent) -> void:
	# Allow pressing Enter to submit instead of clicking the button
	if panel.visible and event.is_action_pressed("ui_accept"):
		_on_submit_pressed()
