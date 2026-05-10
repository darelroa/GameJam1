extends Area2D

@export var target_scene: String = ""

var player_nearby: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	label.visible = false

func _process(_delta: float) -> void:
	if player_nearby:
		if Input.is_action_just_pressed("interact"):
			go_to_target_scene()

func _on_body_entered(body: Node) -> void:
	if body is Player:
		player_nearby = true
		label.visible = true

func _on_body_exited(body: Node) -> void:
	if body is Player:
		player_nearby = false
		label.visible = false

func go_to_target_scene() -> void:
	if target_scene == "":
		print("Portal error: no target scene set!")
		return
	get_tree().change_scene_to_file(target_scene)
