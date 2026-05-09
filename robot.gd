extends Area2D

@export var dialogue_text: String = ""
@export var task_text: String = ""

@onready var dialogue = $DialogueBubble
@onready var label = $DialogueBubble/Panel/Label

func _ready() -> void:
	dialogue.visible = false
	label.text = dialogue_text + "\n\n" + task_text

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		dialogue.visible = !dialogue.visible 
