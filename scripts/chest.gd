extends Area2D

@onready var sprite = $AnimatedSprite2D

var is_opened = false
var player_in_range = false

func _ready() -> void:
	# Connect signals if they're not already connected
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player near chest")
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player left chest area")
		player_in_range = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if player_in_range and not is_opened:
			var player = get_tree().get_first_node_in_group("player")
			if player and player.has_key:
				print("Opening chest with key!")
				open_chest()
			else:
				print("Need a key to open the chest!")

func open_chest() -> void:
	is_opened = true
	sprite.play("open")
