
extends KinematicBody2D
var speed = 1000.0
var direction
var index
var charges = 1

var shooter

var speedBoost = 0
var period = 0.500
var angle0
var angle
var collisions = []

var movem

func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (angle >= angle0 + PI):
		get_parent().player.movem.speedAdds -= speedBoost
		get_parent().player.skillCoolDown[index][2] = 1
		self.queue_free()
	elif (!get_child(1).get_overlapping_bodies().empty()):
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12 and not (get_child(1).get_overlapping_bodies()[0] in collisions)):
			collisions.append(get_child(1).get_overlapping_bodies()[0])
			var stacks = shooter.skillPre[0].addStack(get_child(1).get_overlapping_bodies()[0])
			var critChance = get_parent().player.bar.luck/(get_child(1).get_overlapping_bodies()[0].bar.armor + get_parent().player.bar.luck)
			var damage = (1.0+stacks*(critChance/2+0.2))*shooter.bar.AD
			get_parent().player.bar.takeBuff(50*critChance*stacks, 0, period)
			damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1, direction)
			get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism*0.8, 0.5, shooter.get_pos() - self.get_pos())
			if stacks == 5 :
				var damage = 2*(critChance/2+0.2)*5*shooter.bar.AD
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 0, direction)
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism*0.8, 0.5, shooter.get_pos() - self.get_pos())
			elif stacks == 6 :
				var damage = 3*(critChance/2+0.2)*shooter.bar.AD
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 0, direction)
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism*0.8, 0.5, shooter.get_pos() - self.get_pos())
	angle += PI*delta/period
	self.set_rot(angle)
	self.set_pos(shooter.get_pos())

func shoot(pos, dir, idx, shtr):
	shooter = shtr
	index = idx
	direction = dir
	angle0 = atan2(dir.x, dir.y)+PI
	angle = angle0
	period = 1.0/(shooter.bar.speed/shooter.STDSPEED)
	get_parent().player.skillCoolDown[index][2] = 1
	get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0

