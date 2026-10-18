class_name Bee
extends Node2D

## Overrides the swarm's target when set.
@export var target: Node2D
@export var max_speed := 250.0
@export var max_turn_rate := 2.0
@export var arrive_radius := 120.0
## Steering decisions per second. Between decisions bees fly straight, so lower = jerkier.
@export_range(1.0, 60.0) var steer_rate := 4.0
## Average sideways darts per second.
@export var dart_rate := 1.0
## Sideways velocity kick of a dart, in px/s.
@export var dart_strength := 300.0

var velocity := Vector2.ZERO

var _since_steer := 0.0
# Seeded from the node name, so each bee flies the same path on every run.
var _rng := RandomNumberGenerator.new()

## Force needed to turn at max_turn_rate while flying at max_speed.
var max_force: float:
	get:
		return max_turn_rate * max_speed

@onready var swarm := get_parent() as Swarm

var heading: float:
	## read-only
	get:
		return velocity.angle() if velocity.length_squared() > 1.0 else rotation


func _ready():
	_rng.seed = String(name).hash()
	# Random phase so the bees don't all change direction at the same moment.
	_since_steer = _rng.randf() / steer_rate


# Steering decisions happen at steer_rate; movement happens every frame. Moving exactly up to
# each decision time keeps the path independent of the frame rate.
func _process(delta: float):
	var interval := 1.0 / steer_rate
	var remaining := delta
	while _since_steer + remaining >= interval:
		var step := maxf(interval - _since_steer, 0.0) # steer_rate may be raised live
		position += velocity * step
		remaining -= step
		_since_steer = 0.0
		_steer(interval)
	position += velocity * remaining
	_since_steer += remaining
	if velocity.length_squared() > 1.0:
		rotation = velocity.angle()


# Applies the velocity change for a whole decision interval at once.
func _steer(interval: float):
	var goal := target if target else swarm.target
	if goal:
		velocity += SeekAlgo.steer(swarm.seek_mode, self, goal, interval)
	_maybe_dart(interval)


# Random sideways kick. The chance is scaled by delta so the dart rate doesn't depend on the
# steer rate, and the kick itself is a one-off impulse, so it isn't scaled by delta.
func _maybe_dart(delta):
	if _rng.randf() < 1.0 - exp(-dart_rate * delta):
		var side := 1.0 if _rng.randf() < 0.5 else -1.0
		velocity += velocity.orthogonal().normalized() * side * dart_strength
