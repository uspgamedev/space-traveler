
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
		get_parent().player.skillCoolDown[index][2] = 1
		get_parent().player.skillPre[0].didHitLast = 0
		self.queue_free()
	elif (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			var critChance = get_parent().player.bar.crit*(0.5+get_parent().player.skillPre[0].didHitLast/4.0)/(get_child(1).get_overlapping_bodies()[0].bar.armor + get_parent().player.bar.crit*(0.5+get_parent().player.skillPre[0].didHitLast/4.0))
			print ("dhl", get_parent().player.skillPre[0].didHitLast)
			print ("critc = ", critChance)
			if (randf() <= critChance):
				get_child(1).get_overlapping_bodies()[0].bar.takeDamage(get_parent().player.bar.AD, 1.5, direction)
			else :
				get_child(1).get_overlapping_bodies()[0].bar.takeDamage(get_parent().player.bar.AD, 1, direction)
			get_parent().player.skillPre[0].didHitLast += 2
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() != 9):
			get_parent().player.skillPre[0].didHitLast -= 1
			get_parent().player.movem.speedAdds -= speedBoost
			get_parent().player.skillCoolDown[index][2] = 1
			self.queue_free()

func shoot(pos, dir, idx):
	index = idx
	direction = dir
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	if (index != -1):
		get_parent().player.skillCoolDown[index][2] = 0
		get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	get_parent().player.movem.speedAdds += speedBoost
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*500)
	self.set_transform(newTransform)
