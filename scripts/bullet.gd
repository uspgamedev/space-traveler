
extends RigidBody2D

var target
var remaining
var speed = 1000.0
var direction

func _init():
	target = self.get_pos()-self.get_pos()
	set_process(true)

func _process(delta):
	remaining = remaining - target.normalized()*speed*delta
	if (target - remaining).length() > target.length():
		self.get_child(0).set_texture(null)
		self.queue_free()
	else:
		var ds = target.normalized()*speed*delta + self.get_pos()
		var newTransform = Matrix32(0, ds)
		direction = (target - self.get_pos()).normalized()
		self.set_transform(newTransform)

func setPosition(pos, dir):
	var newTransform = Matrix32(0, pos)
	target = dir.normalized()*400
	remaining = target
	self.set_transform(newTransform)
