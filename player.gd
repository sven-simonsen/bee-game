extends Node2D

@export var speed := 400.0

var velocity := Vector2.ZERO


func _process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed
	position += velocity * delta
