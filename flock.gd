class_name Flock
extends Node2D

## Target for bees that have no target of their own.
@export var target: Node2D
@export var seek_mode := SeekAlgo.Mode.ARRIVE
@export var arrive_radius := 120.0
