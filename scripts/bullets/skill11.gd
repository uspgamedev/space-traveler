
extends Node2D

var index
var charges = 1
var initTime = 0.0
var endTime = 3.0
var shouldDraw = 0

var periodReflex = 0.2
var lastReflex
var initHealth = 0.0

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 3.0
	get_parent().player.skillCoolDown[i][0] = 3.0
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.AD += 30
	get_parent().player.bar.vampirism += 0.1
	get_parent().player.bar.armor += 40
	get_parent().player.bar.shield += 40
	get_parent().player.bar.maxHp += 200
	endTime = get_parent().player.skillCoolDown[i][0]

func setup (i):
	set_fixed_process(true)
	shouldDraw = 1
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	initTime = OS.get_ticks_msec()/1000.0
	endTime += initTime
	lastReflex = initTime
	initHealth = float(get_parent().player.bar.curHp + get_parent().player.bar.barrier)

func _fixed_process(delta):
	self.set_pos(get_parent().player.get_pos())
	update()
	if (OS.get_ticks_msec()/1000.0 > endTime):
		get_parent().player.skillCoolDown[index][2] = 1
		get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
		self.queue_free()
	elif (OS.get_ticks_msec()/1000.0 > periodReflex + lastReflex) :
		var curHealth = float(get_parent().player.bar.curHp + get_parent().player.bar.barrier)
		var damage = 1.0*get_parent().player.bar.AP*periodReflex
		if (initHealth - curHealth > 0):
			damage += (initHealth - curHealth)*(get_parent().player.bar.armor + get_parent().player.bar.shield)/200.0
		print(damage, (get_parent().player.bar.armor + get_parent().player.bar.shield)/200.0)
		if (damage > 1):
			for i in get_child(0).get_overlapping_bodies():
				if (i.get_collision_mask() == 12):
					var newDamage = i.bar.takeDamage(damage, 2, (i.get_pos() + i.get_parent().get_pos()) - self.get_pos())
					get_parent().player.bar.takeHeal(newDamage*(get_parent().player.bar.vampirism*1.5), 0, self.get_pos() - (i.get_pos() + i.get_parent().get_pos()))
		initHealth = float(get_parent().player.bar.curHp + get_parent().player.bar.barrier)
		lastReflex = OS.get_ticks_msec()/1000.0

func _draw():
	if (shouldDraw):
		draw_circle(Vector2(0, 0), 300.0, Color(156.0/255, 39.0/255, 176.0/255, 0.05+(1+sin(2*PI*(OS.get_ticks_msec()/1000.0 - lastReflex)/periodReflex))/40.0))

func setPosition(pos, dir):
	pass
