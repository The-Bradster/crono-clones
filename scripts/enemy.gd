extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 50.0
const GRAVITY = 980
var direction = -1  # -1 for left, 1 for right
var is_active = false

func _ready() -> void:
	# Start with walk animation
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
		sprite.play("walk")

func _physics_process(delta: float) -> void:
	# Check if we're on screen
	if not is_active:
		var camera = get_viewport().get_camera_2d()
		if camera and camera.is_position_in_viewport(global_position):
			is_active = true
	
	# Only move if active
	if is_active:
		# Apply gravity
		if not is_on_floor():
			velocity.y += GRAVITY * delta
		
		# Set horizontal velocity
		velocity.x = SPEED * direction
		
		# Flip sprite based on direction
		if sprite:
			sprite.flip_h = direction < 0
		
		# Move and handle collisions
		move_and_slide()
		
		# Check for wall collision and turn around
		if is_on_wall():
			direction *= -1  # Reverse direction
			if sprite:
				sprite.flip_h = direction < 0
