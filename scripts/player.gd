extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 90.0  # Lower base speed like Celeste
const AIR_SPEED = 90.0  # Full air control like Celeste
const JUMP_VELOCITY = -315.0  # Higher jump velocity like Celeste
const COYOTE_TIME = 0.1  # Same as Celeste
const ACCELERATION = 1000.0  # How quickly we reach max speed
const DECELERATION = 1000.0  # How quickly we slow down
const JUMP_GRAVITY_MULTIPLIER = 0.4  # Lower gravity while holding jump
const JUMP_BUFFER_TIME = 0.1  # How long to remember a jump input before landing

var coyote_timer = 0.0
var was_on_floor = false
var can_double_jump = true  # Track if double jump is available
var jump_gravity_multiplier = 1.0  # Current gravity multiplier
var jump_buffer_timer = 0.0  # Timer for jump buffer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		# Apply variable gravity based on jump button
		if Input.is_action_pressed("jump") and velocity.y < 0:
			jump_gravity_multiplier = JUMP_GRAVITY_MULTIPLIER
		else:
			jump_gravity_multiplier = 1.0
		velocity += get_gravity() * delta * jump_gravity_multiplier
		# Play jumping animation when moving upward, falling animation when moving downward
		if velocity.y < 0 and sprite.animation != "jump":
			sprite.play("jump")
		elif velocity.y > 0 and sprite.animation != "jump_fall":
			sprite.play("jump_fall")
	else:
		# Reset coyote timer and double jump when on floor
		coyote_timer = COYOTE_TIME
		was_on_floor = true
		can_double_jump = true  # Reset double jump when landing
		jump_gravity_multiplier = 1.0  # Reset gravity multiplier on landing
		
		# Check for buffered jump
		if jump_buffer_timer > 0:
			velocity.y = JUMP_VELOCITY
			sprite.play("jump")
			jump_buffer_timer = 0  # Reset buffer after using it

	# Update coyote timer
	if not is_on_floor() and was_on_floor:
		coyote_timer -= delta
		if coyote_timer <= 0:
			was_on_floor = false

	# Update jump buffer timer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_timer > 0:
			# Normal jump
			velocity.y = JUMP_VELOCITY
			sprite.play("jump")
			coyote_timer = 0  # Reset coyote timer after jumping
		elif can_double_jump:
			# Double jump
			velocity.y = JUMP_VELOCITY
			sprite.play("jump")  # Play jump animation for double jump
			can_double_jump = false  # Use up the double jump
		else:
			# Buffer the jump if we're in the air and can't double jump
			jump_buffer_timer = JUMP_BUFFER_TIME

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		# Smooth acceleration like Celeste
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		# Flip the sprite based on movement direction
		sprite.flip_h = direction < 0
		# Play running animation when moving on the ground
		if is_on_floor() and sprite.animation != "run":
			sprite.play("run")
	else:
		# Smooth deceleration like Celeste
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		# Play idle animation when standing still on the ground
		if is_on_floor() and sprite.animation != "idle":
			sprite.play("idle")

	move_and_slide()
