
extends RigidBody2D

var target
var remaining
var speed = 500.0
var direction

func _init():
	set_process(true)
	target = self.get_pos()-self.get_pos()
	remaining = self.get_pos()-self.get_pos()

func _process(delta):
	remaining = remaining - target.normalized()*speed*delta
	if (target - remaining).length() < target.length():
		var ds = target.normalized()*speed*delta + self.get_pos()
		var newTransform = Matrix32(0, ds)
		direction = (target - self.get_pos()).normalized()
		self.set_transform(newTransform)

func moveTo(pos):
	print("Moving to: ", pos)
	target = pos - self.get_pos()
	remaining = target
	