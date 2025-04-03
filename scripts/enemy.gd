extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 50.0
const GRAVITY = 980
var direction = -1  # -1 for left, 1 for right

# Advanced patrol options
@export var prevent_stairs = false  # If true, enemy won't go down stairs
@export var activate_on_screen = false  # If true, enemy only activates when visible
@export var patrol_left_bound = -1000.0  # Left boundary for patrol
@export var patrol_right_bound = 1000.0  # Right boundary for patrol

var is_active = false

func _ready() -> void:
	# Start with walk animation
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
		sprite.play("walk")
	
	# If not activating on screen, start active
	if not activate_on_screen:
		is_active = true

func _physics_process(delta: float) -> void:
	# Check if we should activate (when on screen)
	if activate_on_screen and not is_active:
		var camera = get_viewport().get_camera_2d()
		if camera:
			var screen_rect = camera.get_viewport_rect()
			var camera_pos = camera.global_position
			var enemy_pos = global_position
			
			# Check if enemy is within the camera's view
			if enemy_pos.x >= camera_pos.x - screen_rect.size.x/2 and \
			   enemy_pos.x <= camera_pos.x + screen_rect.size.x/2 and \
			   enemy_pos.y >= camera_pos.y - screen_rect.size.y/2 and \
			   enemy_pos.y <= camera_pos.y + screen_rect.size.y/2:
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
		
		# Check for patrol boundaries
		if global_position.x <= patrol_left_bound:
			direction = 1  # Turn right
			if sprite:
				sprite.flip_h = false
		elif global_position.x >= patrol_right_bound:
			direction = -1  # Turn left
			if sprite:
				sprite.flip_h = true
		
		# Check for stairs if prevent_stairs is enabled
		if prevent_stairs and is_on_floor():
			# Cast a ray downward to check for stairs
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 20))
			query.exclude = [self]
			var result = space_state.intersect_ray(query)
			
			# If there's no ground ahead, turn around
			if not result:
				direction *= -1
				if sprite:
					sprite.flip_h = direction < 0
