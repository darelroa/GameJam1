extends Control

func _ready() -> void:
	pass

func _start_cutscene() -> void:
	Global.cutscene_slides = [
		"res://assets/sprites/codeclass/classprint.PNG",
		"res://assets/sprites/codeclass/classvariable1.PNG",
		"res://assets/sprites/codeclass/classvariable2.PNG",
		"res://assets/sprites/cutscene/citycutscene.PNG"
	]
	Global.cutscene_next_scene = "res://scences/world/level1.tscn"
	get_tree().change_scene_to_file("res://scences/cutscene.tscn")

func _on_player_1_button_pressed() -> void:
	Global.selected_player = "player1"
	_start_cutscene()

func _on_player_2_button_pressed() -> void:
	Global.selected_player = "player2"
	_start_cutscene()

func _on_player_3_button_pressed() -> void:
	Global.selected_player = "player3"
	_start_cutscene()

func _on_player_4_button_pressed() -> void:
	Global.selected_player = "player4"
	_start_cutscene()
