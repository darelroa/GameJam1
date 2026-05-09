extends Area2D

# ─── Configuration (set these in the Inspector for each bag) ───────────────────
@export var bag_colour: String = "yellow"   # "yellow", "red", or "green"
@export var bin_position: Vector2 = Vector2(300, 0)  # where the matching bin is

# ─── The fill-in-the-blank puzzle data for each bag ────────────────────────────
# Each bag has its own puzzle prompt and the correct answer the player must type.
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

# ─── Internal state ─────────────────────────────────────────────────────────────
var player_nearby: bool = false   # is the player inside our Area2D?
var is_solved: bool = false       # has this bag been correctly sorted?

# ─── Node references ────────────────────────────────────────────────────────────
@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Load the correct bag image based on bag_colour
	sprite.texture = load("res://assets/sprites/trash/bag_%s.png" % bag_colour)
	label.visible = false  # hide the hint label until the player is nearby

	# Connect the Area2D signals so we know when the player enters/exits
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	# Every frame, check if the player is nearby AND pressed E
	if player_nearby and not is_solved:
		if Input.is_action_just_pressed("interact"):
			open_dialog()

func _on_body_entered(body: Node) -> void:
	# This runs when something walks into our Area2D
	if body is Player:
		player_nearby = true
		label.visible = true   # show "Press E to interact"

func _on_body_exited(body: Node) -> void:
	# This runs when something walks out of our Area2D
	if body is Player:
		player_nearby = false
		label.visible = false  # hide the hint

func solve() -> void:
	# Called by the dialog when the player enters the correct answer
	is_solved = true
	label.visible = false
	play_sort_animation()

func play_sort_animation() -> void:
	var start = global_position
	var end = bin_position
	
	# Calculate a midpoint above both the bag and bin to create the arc
	var mid = (start + end) / 2.0
	mid.y -= 300.0  # how high the arc goes — increase this for a bigger curve
	
	var duration = 1.4  # total flight time in seconds — increase for slower
	var steps = 40      # how many steps the curve is broken into — more = smoother
	
	var tween = create_tween()
	
	for i in range(1, steps + 1):
		var t = float(i) / float(steps)  # t goes from 0.0 to 1.0
		
		# Quadratic bezier formula: calculates a point along the curved path
		# P = (1-t)² * start  +  2(1-t)t * mid  +  t² * end
		var point = (1 - t) * (1 - t) * start \
				  + 2 * (1 - t) * t * mid \
				  + t * t * end
		
		tween.tween_property(self, "global_position", point, duration / steps)
	
	# After the arc finishes, delete the bag
	tween.tween_callback(queue_free)
