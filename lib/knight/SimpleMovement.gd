extends Node

export(float) var velocity := 1.0

export (NodePath) var entity_path
onready var entity = get_node(entity_path) as KinematicBody2D

enum Direction {NO_MOVE, UP,DOWN,LEFT,RIGHT}

func move(direction):
	var v = Vector2.ZERO
	match direction:
		Direction.UP:
			v = Vector2.UP
		Direction.DOWN:
			v = Vector2.DOWN
		Direction.LEFT:
			v = Vector2.LEFT
		Direction.RIGHT:
			v = Vector2.RIGHT
		_ : 
			pass

	entity.move_and_slide(velocity*v)

