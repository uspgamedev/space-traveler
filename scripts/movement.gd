
extends Node

var target
var remaining

var ociStart
var ociTarget
var period

var speed0 = 500.0
var speed = 500.0

var direction
var finished = 0

var shouldRotate = 0

var rotScene

var del = 0.012

var thread = Thread.new()

func _init():
	set_process(true)
	target = Vector2(0, 0)
	remaining = Vector2(0, 0)

func _ready():
	pass

func _process(delta):
	var ds
	del = delta
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

func setSpeed (var sp):
	speed0 = sp

func moveTo(pos, s = speed0):
	speed = s
	target = pos - get_parent().get_pos()
	remaining = target

func rotate (pos):
	rotScene.set_rot(atan2(pos.x, pos.y)+PI)

func setRotScene (rotScn) :
	rotScene = rotScn
	shouldRotate = 1

func ocilateBetween (pos, T) :
	period = T
	ociTarget = pos
	ociStart = self.get_parent().get_pos()
	thread.start(self, thOcilateBetween(), null)

func thOcilateBetween () :
	var r = ((ociTarget-ociStart)/2)
	while (1) :
		var ang = atan2(((self.get_parent().get_pos() - ociStart - r)*(1/r.length())).x, ((self.get_parent().get_pos() - ociStart - r)*(1/r.length())).y)
		var ds = cos(del/period + ang)*r+r
		get_parent().move(ds)
		#yield(get_tree(), "idle_frame")
