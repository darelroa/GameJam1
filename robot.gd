extends Area2D

@export var dialogue_text: String = ""
@export var task_text: String = ""

@onready var dialogue = $DialogueBubble
@onready var context_label = $DialogueBubble/Control/Panel/ContextLabel
@onready var task_label = $DialogueBubble/Control/Panel/TaskLabel
@onready var next_button =$DialogueBubble/Control/Panel/Button


enum State { CLOSED, CONTEXT, TASK}
var current_state = State.CLOSED

func _ready() -> void:
	dialogue.visible = false
	context_label.text = dialogue_text
	task_label.text = task_text
	context_label.visible = true
	task_label.visible = false
	next_button.pressed.connect(advance)

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("robot clicked!")
		advance()

func advance() -> void:
	print("state: ", current_state)
	match current_state:
		State.CLOSED:
			dialogue.visible = true
			context_label.visible = true
			task_label.visible = false
			current_state = State.CONTEXT
		State.CONTEXT:
			context_label.visible = false 
			task_label.visible = true
			current_state = State.TASK
		State.TASK:
			dialogue.visible = false
			current_state = State.CLOSED
		
