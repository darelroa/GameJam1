extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_player_1_button_pressed() -> void:
	Global.selected_player ="player1"
	get_tree().change_scene_to_file("res://scences/world/level1.tscn")
	
func _on_player_2_button_pressed() -> void:
	Global.selected_player ="player2"
	get_tree().change_scene_to_file("res://scences/world/level1.tscn")
	
func _on_player_3_button_pressed() -> void:
	Global.selected_player ="player3"
	get_tree().change_scene_to_file("res://scences/world/level1.tscn")
	
func _on_player_4_button_pressed() -> void:
	Global.selected_player ="player4"
	get_tree().change_scene_to_file("res://scences/world/level1.tscn")
