
extends KinematicBody2D
var speed = 1000.0
var direction
var index
var charges = 1

var speedBoost = 30

var movem

func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (movem.finished):
		get_parent().player.movem.speedAdds -= speedBoost
		self.queue_free()
	elif (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(50+0.8*get_parent().player.bar.AD, 1, direction)
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(1.0*get_parent().player.bar.AP, 2, direction)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() != 9):
			get_parent().player.movem.speedAdds -= speedBoost
			self.queue_free()

func shoot(pos, dir, index):
	direction = dir
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	if (index != -1):
		get_parent().player.skillCoolDown[index][2] = 1
		get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	get_parent().player.movem.speedAdds += speedBoost
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*500)
	self.set_transform(newTransform)
