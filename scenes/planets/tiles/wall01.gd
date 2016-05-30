
extends KinematicBody2D

var sprite

func _ready():
	sprite = self.get_child(0)
	sprite.set_pos(Vector2 (rand_range(-5,5), rand_range(-5,5)))
	sprite.set_rot(rand_range(-5.0/180,5.0/180))


