
extends KinematicBody2D
var speed = 1000.0
var direction
var index
var charges = 1

var speedBoost = 200

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
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(50)
		get_parent().player.movem.speedAdds -= speedBoost
		self.queue_free()
	elif (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		get_parent().player.movem.speedAdds -= speedBoost
		self.queue_free()

func shoot(pos, dir, index):
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	if (index != -1):
		get_parent().player.skillCoolDown[index][2] = 1
		get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	get_parent().player.movem.speedAdds += speedBoost
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*500)
	self.set_transform(newTransform)
