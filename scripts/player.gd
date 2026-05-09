class_name Player extends CharacterBody2D

@export var speed: float = 200.0
@export var gravity: float = 980.0
@export var jump_velocity: float = -400.0
@onready var anim: AnimatedSprite2D =$AnimatedSprite2D

func _ready() -> void:
	var frames_path = "res://assets/sprites/movement/%s.tres" % Global.selected_player
	anim.sprite_frames	 = load(frames_path)
	anim.play("idle")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("move_up") and is_on_floor():
			velocity.y = jump_velocity
	
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	if direction != 0:
		anim.play("run")
	else:
		anim.play("idle")
	
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false
