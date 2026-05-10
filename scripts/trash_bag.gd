extends Area2D

@export var bag_colour: String = "yellow"  
@export var bin_position: Vector2 = Vector2(300, 0)  

const PUZZLES = {
	"yellow": {
		"prompt": "Complete each part of the if-elif-else statement by filling in the blanks:",
		"fixed_line": " colour == \"yellow\":",
		"placeholder1": "if / elif / else",
		"placeholder2": "Write a print statement to say \"This belongs in the recycling bin!\"",
		"answer1": "if",
		"answer2": "print(\"This belongs in the recycling bin!\")"
	},
	"red": {
		"prompt": "Complete each part of the if-elif-else statement by filling in the blanks:",
		"fixed_line": " colour == \"black\":",
		"placeholder1": "if / elif / else",
		"placeholder2": "Write a print statement to say \"This belongs in the general waste bin!\"",
		"answer1": "elif",
		"answer2": "print(\"This belongs in the general waste bin!\")"
	},
	"green": {
		"prompt": "Complete each part of the if-elif-else statement by filling in the blanks:",
		"fixed_line": ":",
		"placeholder1": "if / elif / else",
		"placeholder2": "Write a print statement to say \"This belongs in the organic waste bin!\"",
		"answer1": "else",
		"answer2": "print(\"This belongs in the organic waste bin!\")"
	}
}

func open_dialog() -> void:
	var dialog = get_tree().get_root().find_child("TaskDialog", true, false)
	if dialog:
		var puzzle = PUZZLES[bag_colour]
		dialog.open(
			puzzle["prompt"],
			puzzle["fixed_line"],
			puzzle["placeholder1"],
			puzzle["placeholder2"],
			puzzle["answer1"],
			puzzle["answer2"],
			self
		)

var player_nearby: bool = false   
var is_solved: bool = false       

@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	
	sprite.texture = load("res://assets/sprites/trash/bag_%s.png" % bag_colour)
	label.visible = false  

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_nearby and not is_solved:
		if Input.is_action_just_pressed("interact"):
			open_dialog()

func _on_body_entered(body: Node) -> void:
	if body is Player:
		player_nearby = true
		label.visible = true   

func _on_body_exited(body: Node) -> void:
	if body is Player:
		player_nearby = false
		label.visible = false  

func solve() -> void:
	is_solved = true
	label.visible = false
	play_sort_animation()

func play_sort_animation() -> void:
	var start = global_position
	var end = bin_position
	
	var mid = (start + end) / 2.0
	mid.y -= 300.0
	
	var duration = 1.4
	var steps = 40
	
	var tween = create_tween()
	
	for i in range(1, steps + 1):
		var t = float(i) / float(steps)
		var point = (1 - t) * (1 - t) * start \
				  + 2 * (1 - t) * t * mid \
				  + t * t * end
		
		tween.tween_property(self, "global_position", point, duration / steps)
	
	tween.tween_callback(queue_free)
