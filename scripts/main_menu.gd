extends Control
@onready var exit: TextureButton = %Exit
@onready var new_game: TextureButton = %"New Game"

func _ready() -> void:
	new_game.pressed.connect(play)
	exit.pressed.connect(quit)

func play() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func quit() -> void:
	get_tree().quit()
