
extends RigidBody2D

var target
var speed = 1000.0

func _init():
	target = self.get_pos()-self.get_pos()
	set_process(true)

func _process(delta):
	if (target.length() < 1.0):
		print("removing bullet")
		self.get_child(0).set_texture(null)
		self.queue_free()
	else:
		var ds = target.normalized()*speed*delta + self.get_pos()
		target = target - target.normalized()*speed*delta
		var newTransform = Matrix32(0, ds)
		self.set_transform(newTransform)

func setPosition(pos, dir):
	var newTransform = Matrix32(0, pos)
	target = dir.normalized()*501
	self.set_transform(newTransform)