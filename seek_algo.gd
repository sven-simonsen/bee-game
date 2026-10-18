class_name SeekAlgo

enum Mode {
	STOP,
	RUSH,
	SEEK,
	ARRIVE,
}


static func steer(mode: Mode, bee: Bee, target: Node2D, delta: float) -> Vector2:
	match mode:
		Mode.STOP:
			return _stop(bee)
		Mode.RUSH:
			return _rush(bee, target.global_position, delta)
		Mode.SEEK:
			return _seek(bee, target.global_position, delta)
		Mode.ARRIVE:
			return _arrive(bee, target.global_position, delta)
	return Vector2.ZERO


static func _stop(bee: Bee) -> Vector2:
	return -bee.velocity


static func _rush(bee: Bee, target: Vector2, delta: float) -> Vector2:
	var heading = rotate_toward(
		bee.heading,
		(target - bee.global_position).angle(),
		bee.max_turn_rate * delta,
	)
	return Vector2.from_angle(heading) * bee.max_speed - bee.velocity


# Reynolds steering: steer = desired velocity - current velocity, capped at max_force.
static func _reynolds_steer(bee: Bee, desired: Vector2) -> Vector2:
	return (desired - bee.velocity).limit_length(bee.max_force)


static func _seek(bee: Bee, point: Vector2, delta: float) -> Vector2:
	var desired := (point - bee.global_position).normalized() * bee.max_speed
	return _reynolds_steer(bee, desired) * delta


# Like seek, but slows down within bee.arrive_radius instead of overshooting.
static func _arrive(bee: Bee, point: Vector2, delta: float) -> Vector2:
	var offset := point - bee.global_position
	var distance := offset.length()
	var speed := bee.max_speed * minf(distance / bee.arrive_radius, 1.0)
	return _reynolds_steer(bee, offset.normalized() * speed) * delta
