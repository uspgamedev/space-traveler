
extends KinematicBody2D
var speed = 1000.0
var direction
var ndirection
var movem
var index
var charges = 1
var acel = 700.0;
var alreadyCollided = []
var indicatorRadious = 20;

func _init():
	set_fixed_process(true)

func _ready():
	movem = self.get_child(2)
	movem.setSpeed(-800.0)
	for skill in get_parent().skills :
		if (skill[1] == (self.get_filename())):
			index = get_parent().skills.find(skill)
	if (get_parent().player.skillCharges[index] == -1) :
		get_parent().player.skillCharges[index] = charges
	get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	get_parent().player.skillCharges[index] -= 1

func _fixed_process(delta):
	var pos = self.get_parent().player.get_pos()
	#print(movem.target, "--", movem.remaining)
	movem.moveTo(pos)
	movem.setSpeed(movem.speed0+acel*delta)
	acel+=15.0
	if (movem.finished):
		self.queue_free()
	if (!get_child(1).get_overlapping_bodies().empty()):
		for i in get_child(1).get_overlapping_bodies():
			if (i.get_collision_mask() == 12 and not (i in alreadyCollided)):
				i.bar.takeDamage(acel/10)
				alreadyCollided.append(i)
	for j in alreadyCollided:
		if (not j in get_child(1).get_overlapping_bodies()):
			alreadyCollided.remove(alreadyCollided.find(j))
	if (!get_child(1).get_overlapping_areas().empty()):
		pass
	update()

func _draw():
	draw_circle(Vector2(0,0), indicatorRadious, Color((255.0*((acel-400.0)/acel)/255.0), 80.0/255, 80.0/255, 0.5))
	#print("v1 = ",(255.0*(acel/(700.0+acel)))/255.0)
	#print("v2 = ",(255.0*((acel-200.0)/acel)/255.0))

func setPosition(pos, dir):
	direction = dir
	movem.shouldRotate = true
	movem.setRotScene(self.get_child(0))
	var newTransform = Matrix32(0, pos)
	self.set_transform(newTransform)
	self.set_pos(pos+dir.normalized()*50)
	movem.moveTo(self.get_parent().player.get_pos())
