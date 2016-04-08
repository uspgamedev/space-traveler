
extends KinematicBody2D

var target
var remaining
var speed = 500.0
var direction
var camera
var bar

func _init():
	set_process(true)
	target = self.get_pos()-self.get_pos()
	remaining = self.get_pos()-self.get_pos()
	camera = get_node("Camera2D")	

func _ready():
	var barScene = load("res://scenes/HealthBar.scn")
	bar = barScene.instance()
	bar.initBar(500.0)
	add_child(bar)

func _process(delta):
	var ds
	remaining = remaining - target.normalized()*speed*delta
	if (target - remaining).length() < target.length():
		ds = target.normalized()*speed*delta
		direction = (target - self.get_pos()).normalized()
		move(ds)
		if (is_colliding()):
			var n = get_collision_normal().slide(ds)
			move(n)
	

func moveTo(pos):
	print("Moving to: ", pos)
	target = pos - self.get_pos()
	remaining = target

func Rotate (mousePos):
	get_child(0).set_rot(atan2(mousePos.x, mousePos.y)+PI)
