extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
<<<<<<< HEAD
	get_tree().change_scene_to_file("res://scences/world/level1.tscn")
=======
	get_tree().change_scene_to_file("res://scences/world/level_1.tscn")
>>>>>>> 7fd5d9593471f91949fd08b332a3276329a9938c


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _on_character_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scences/menu/character_selection.tscn")
