extends Node2D

@export var speed := 400.0

var velocity := Vector2.ZERO


func _process(delta):
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
	position += velocity * delta
