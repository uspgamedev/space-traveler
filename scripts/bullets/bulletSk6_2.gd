
extends KinematicBody2D
var speed = 2000.0
var direction
var position
var movem
var index
var finished = 0
var alreadyCollided = []

func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (movem.finished and finished==0):
		self.get_parent().get_parent().player.set_pos(self.get_parent().iniPos)
		finished = 1
		self.get_parent().finish()
	update()
	if (!get_child(1).get_overlapping_bodies().empty()):
		for i in get_child(1).get_overlapping_bodies():
			if (i.get_collision_mask() == 12 and not (i in alreadyCollided)):
				var damage = 150+(i.bar.maxHp - i.bar.curHp)*(0.20+0.15/100.0*get_parent().get_parent().player.bar.speed)
				damage = i.bar.takeDamage(damage, 0, direction)
				get_parent().get_parent().player.bar.takeHeal(damage*get_parent().get_parent().player.bar.vampirism, 0.5, direction)
				alreadyCollided.append(i)
	for j in alreadyCollided:
		if (not j in get_child(1).get_overlapping_bodies()):
			alreadyCollided.remove(alreadyCollided.find(j))

func _draw():
	if (finished == 0):
		draw_circle(Vector2(0, 0), 30.0, Color(255.0/255, 160.0/255, 0.0/255, 0.5))

func troll (pos, dir):
	movem = self.get_child(2)
	movem.setSpeed(speed)
	direction = (dir-self.get_parent().get_parent().player.get_pos()).normalized()
	movem.shouldRotate = true
	movem.setRotScene(self.get_child(0))
	var newTransform = Matrix32(0, self.get_parent().get_parent().player.get_pos()-self.get_parent().get_pos())
	movem.moveTo(dir-self.get_parent().get_parent().player.get_pos())
	self.set_transform(newTransform)
