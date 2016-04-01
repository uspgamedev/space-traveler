
extends KinematicBody2D

var target
var remaining
var speed = 1000.0
var direction

func _init():
	target = self.get_pos()-self.get_pos()
	set_fixed_process(true)

func _fixed_process(delta):
	remaining = remaining - target.normalized()*speed*delta
	if (is_colliding() and get_collider().get_collision_mask_bit(0)):
		print("collide")
		self.queue_free()
	if (target - remaining).length() > target.length():
		self.get_child(0).set_texture(null)
		self.queue_free()
	else:
		var ds = target.normalized()*speed*delta
		direction = (target - self.get_pos()).normalized()
		move (ds)

func setPosition(pos, dir):
	var newTransform = Matrix32(0, pos)
	target = dir.normalized()*400
	remaining = target
	self.set_transform(newTransform)
