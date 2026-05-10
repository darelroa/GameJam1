extends Control

var images: Array[String] = []
var next_scene: String = ""
var current_index: int = 0
var transitioning: bool = false

@onready var texture_rect: TextureRect = $TextureRect
@onready var click_label: Label = $ClickLabel

func _ready() -> void:
	images = Global.cutscene_slides
	next_scene = Global.cutscene_next_scene

	if images.is_empty():
		get_tree().change_scene_to_file(next_scene)
		return

	show_slide(0)

func show_slide(index: int) -> void:
	var tex = load(images[index])
	texture_rect.texture = tex

	# Update label on last slide
	if index >= images.size() - 1:
		click_label.text = "Click or press any key to start"
	else:
		click_label.text = "Click or press any key to continue"

func advance() -> void:
	if transitioning:
		return
	transitioning = true

	current_index += 1
	if current_index >= images.size():
		get_tree().change_scene_to_file(next_scene)
	else:
		show_slide(current_index)
		transitioning = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			advance()
	elif event is InputEventKey:
		if event.pressed and not event.echo:
			advance()
