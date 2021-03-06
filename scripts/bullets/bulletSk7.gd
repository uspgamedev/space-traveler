
extends KinematicBody2D
var speed = 1000.0
var direction
var position
var movem
var index
var iniTime
var finished = 0
var alreadyCollided = []

var shooter

func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (movem.finished and finished==0):
		if (!get_child(1).get_overlapping_bodies().empty()):
			movem.moveTo(self.get_pos()+direction.normalized()*100)
			for i in get_child(1).get_overlapping_bodies():
				if (i.get_collision_mask() == 12 and not (i in alreadyCollided)):
					var damage = 200+(1.2*shooter.bar.AP)
					damage = i.bar.takeDamage(damage, 2, direction)
					shooter.bar.takeHeal(damage, 0.5, direction)
					alreadyCollided.append(i)
		else:
			self.get_parent().player.set_pos(self.get_pos())
			finished = 1
			get_parent().player.skillCoolDown[index][2] = 1
			get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
			self.queue_free()
	update()

func _draw():
	if (finished == 0):
		draw_circle(Vector2(0, 0), 30.0, Color(255.0/255, 160.0/255, 0.0/255, 0.5))

func shoot (pos, dir, i, shtr):
	shooter = shtr
	index = i
	movem = self.get_child(2)
	movem.setSpeed(speed)
	direction = dir
	movem.shouldRotate = true
	movem.setRotScene(self.get_child(0))
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*200)
	self.set_transform(newTransform)
