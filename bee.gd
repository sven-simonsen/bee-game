class_name Bee
extends Node2D

## Overrides the flock's target when set.
@export var target: Node2D
@export var max_speed := 250.0
@export var max_turn_rate := 2.0

var velocity := Vector2.ZERO

## Force needed to turn at max_turn_rate while flying at max_speed.
var max_force: float:
	get:
		return max_turn_rate * max_speed

@onready var flock := get_parent() as Flock

var heading: float:
	## read-only
	get:
		return velocity.angle() if velocity.length_squared() > 1.0 else rotation


func _process(delta):
	var goal := target if target else flock.target
	if goal:
		velocity += SeekAlgo.steer(flock.seek_mode, self, goal, delta)
	position += velocity * delta
	if velocity.length_squared() > 1.0:
		rotation = velocity.angle()
