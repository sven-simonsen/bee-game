extends Node2D

@export var target: Node2D
@export var max_speed := 250.0
@export var max_force := 400.0
## Within this distance the boid slows down instead of overshooting.
@export var arrive_radius := 120.0

var velocity := Vector2.ZERO


func _process(delta):
	if target:
		velocity += seek(target.global_position) * delta
	position += velocity * delta
	if velocity.length_squared() > 1.0:
		rotation = velocity.angle()


# Reynolds steering: steer = desired velocity - current velocity, capped at max_force.
func seek(point: Vector2) -> Vector2:
	var offset := point - global_position
	var distance := offset.length()
	var desired_speed := max_speed
	if distance < arrive_radius:
		desired_speed = max_speed * distance / arrive_radius
	var desired := offset.normalized() * desired_speed
	return (desired - velocity).limit_length(max_force)
