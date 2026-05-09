extends Area2D

# ─── Configuration (set these in the Inspector for each bag) ───────────────────
@export var bag_colour: String = "yellow"   # "yellow", "red", or "green"
@export var bin_position: Vector2 = Vector2(300, 0)  # where the matching bin is

# ─── The fill-in-the-blank puzzle data for each bag ────────────────────────────
# Each bag has its own puzzle prompt and the correct answer the player must type.
const PUZZLES = {
	"yellow": {
		"prompt": "[Fill in the blank]:\n_______________________\nprint(\"This goes in the recycling bin!\")\n[Fill in the blank]:\nprint(\"This goes in the general waste bin!\")\n[Fill in the blank]:\nprint(\"This goes in the natural waste bin!\")",
		"answer": "if colour == \"yellow\""
	},
	"red": {
		"prompt": "if colour == \"yellow\":\nprint(\"This goes in the recycling bin!\")\n[Fill in the blank]:\n_______________________\n[Fill in the blank]:\nprint(\"This goes in the natural waste bin!\")",
		"answer": "elif colour == \"red\""
	},
	"green": {
		"prompt": "if colour == \"yellow\":\nprint(\"This goes in the recycling bin!\")\nelif colour == \"red\":\nprint(\"This goes in the general waste bin!\")\n[Fill in the blank]:\n_______________________",
		"answer": "elif colour == \"green\""
	}
}

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

func open_dialog() -> void:
	# Tell the dialog UI to open with this bag's puzzle
	var dialog = get_tree().get_root().find_child("TaskDialog", true, false)
	if dialog:
		dialog.open(PUZZLES[bag_colour]["prompt"], PUZZLES[bag_colour]["answer"], self)

func solve() -> void:
	# Called by the dialog when the player enters the correct answer
	is_solved = true
	label.visible = false
	play_sort_animation()

func play_sort_animation() -> void:
	# Animate the bag flying toward the bin position, then disappear
	var tween = create_tween()
	tween.tween_property(self, "position", bin_position, 0.6)\
		 .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(queue_free)  # remove the bag from the scene when done
