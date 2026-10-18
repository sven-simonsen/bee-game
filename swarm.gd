class_name Swarm
extends Node2D

## Target for bees that have no target of their own.
@export var target: Node2D
@export var seek_mode := SeekAlgo.Mode.ARRIVE
