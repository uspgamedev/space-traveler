
extends Node

var target
var remaining
var speed = 500.0
var direction
var finished = 0

var shouldRotate = 0

var rotScene


func _init():
	set_process(true)
	target = Vector2(0, 0)
	remaining = Vector2(0, 0)

func _ready():
	pass

func _process(delta):
	var ds
	remaining = remaining - target.normalized()*speed*delta
	if (target - remaining).length() < target.length():
		ds = target.normalized()*speed*delta
		direction = (target - get_parent().get_pos()).normalized()
		get_parent().move(ds)
		if (get_parent().is_colliding()):
			var n = get_parent().get_collision_normal().slide(ds)
			get_parent().move(n)
	else :
		finished = 1
	if (shouldRotate) :
		rotate(target)

func moveTo(pos):
	target = pos - get_parent().get_pos()
	remaining = target

func rotate (pos):
	rotScene.set_rot(atan2(pos.x, pos.y)+PI)

func setRotScene (rotScn) :
	rotScene = rotScn
	shouldRotate = 1
