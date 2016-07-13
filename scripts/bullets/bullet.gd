
extends KinematicBody2D
var speed = 1000.0
var direction
var index
var charges = 1

var shooter

var movem

func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (movem.finished):
		get_parent().player.skillCoolDown[index][2] = 1
		get_parent().player.skillPre[0].didHitLast = 0
		self.queue_free()
	elif (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			var critChance = get_parent().player.bar.luck*(0.5+get_parent().player.skillPre[0].didHitLast/4.0)/(get_child(1).get_overlapping_bodies()[0].bar.armor + get_parent().player.bar.luck*(0.5+get_parent().player.skillPre[0].didHitLast/4.0))
			#print ("dhl", get_parent().player.skillPre[0].didHitLast)
			#print ("critc = ", critChance)
			if (randf() <= critChance):
				var damage = shooter.bar.AD
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1.5, direction)
				shooter.bar.curHp += damage*shooter.bar.vampirism*0.6
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism*0.8, 0.5, shooter.get_pos() - self.get_pos())
			else :
				var damage = shooter.bar.AD
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1, direction)
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism*0.8, 0.5, shooter.get_pos() - self.get_pos())
			get_parent().player.skillPre[0].didHitLast += 2
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() != 9):
			get_parent().player.skillPre[0].didHitLast -= 1
			get_parent().player.skillCoolDown[index][2] = 1
			self.queue_free()

func shoot(pos, dir, idx, shtr):
	shooter = shtr
	index = idx
	direction = dir
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	get_parent().player.skillCoolDown[index][2] = 1
	get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*500)
	self.set_transform(newTransform)
