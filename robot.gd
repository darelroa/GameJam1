extends Node2D

@export var flash_speed: float = 0.1


var _timer: float = 0.0
var _is_on: bool = false

func _ready() -> void:
	$AnimatedSprite2D.animation = "light"
	$AnimatedSprite2D.frame = 0

func _process(delta: float) -> void:
	_timer += delta
	if _timer >= flash_speed:
		_timer = 0.0
		_is_on = !_is_on
		$AnimatedSprite2D.frame = 1 if _is_on else 0
