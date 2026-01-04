extends CharacterBody2D

var is_attacking = false
var MAX_JUMPS = 2
var JUMPS = MAX_JUMPS

const JUMP = -350
const WALK_SPEED = 350

var _gravity = ProjectSettings.get("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$AnimatedSprite2D.sprite_frames.set_animation_loop("attack", false)

func _physics_process(delta: float) -> void:
	velocity.y += _gravity * delta
	velocity.x = 0
	
	if is_on_floor():
		JUMPS = MAX_JUMPS		
	
	# Handle attack input
	if Input.is_action_just_pressed("attack") and !is_attacking:
		is_attacking = true
		$AnimatedSprite2D.animation = "attack"
		$AnimatedSprite2D.play()
	
	# Only process movement if not attacking
	if Input.is_action_just_pressed("jump"):  
		if JUMPS > 0:
			JUMPS -= 1
			velocity.y = JUMP
	
	if Input.is_action_pressed("move_right"):
		velocity.x = WALK_SPEED
		$AnimatedSprite2D.flip_h = false
		if !is_attacking:
			$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.play()
	elif Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
		$AnimatedSprite2D.flip_h = true
		if !is_attacking:
			$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.play()
	elif !Input.is_anything_pressed():
		if !is_attacking:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.play()
	

	
	move_and_slide()

func _on_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
