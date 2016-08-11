
extends Node2D

var charges = 1
var finished = 0
var index
var didUseSkill
var duration = 3.5

var hitStacks = []

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 1.0
	get_parent().player.skillCoolDown[i][0] = 1.0
	get_parent().skills[i].append(self.get_path())
	set_process(true)
	get_parent().player.bar.takeBuff(40, 4, -(index+1))
	get_parent().player.bar.takeBuff(25, 1, -(index+1))
	get_parent().player.bar.takeBuff(25, 2, -(index+1))
	get_parent().player.bar.luck += 40
	get_parent().player.bar.maxHp += 100
	get_parent().player.bar.vampirism += 0.1

func setup (i, caster) :
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[i][2] = 0
	get_parent().setBullet(i, "res://scenes/bullets/BulletBa3.xscn")
	finished = 1

func addStack (target) :
	for i in hitStacks :
		if i[0] == target :
			i[2] = OS.get_ticks_msec()/1000.0
			if (i[1] < 6):
				i[1] += 1
			return i[1]
	var obj = [target, 1, OS.get_ticks_msec()/1000.0]
	hitStacks.append(obj)
	return 1

func _draw():
	for i in hitStacks :
		if weakref(i[0]).get_ref() and weakref(i[0].get_parent()).get_ref() :
			draw_empty_circle(i[0].get_pos()+i[0].get_parent().get_pos()-self.get_pos(), Vector2(-36, -36), 12, i[1])

func draw_empty_circle(circle_center, circle_radius, thickness, stacks):
	var resolution = 5
	var draw_counter = resolution
	var line_origin = circle_radius + circle_center
	var line_end = line_origin
	var angle = stacks * 90.0
	var color
	if stacks < 5 :
		color = Color(233.0/255, 30.0/255, 99.0/255, 0.25+0.15*stacks)
	else :
		color = Color(136.0/255, 14.0/255, 79.0/255, 1.0)
	while draw_counter <= angle:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color, thickness)
		draw_counter += resolution
		line_origin = line_end

func _process(delta):
	for i in hitStacks :
		if i[2] + duration < OS.get_ticks_msec()/1000.0 or not weakref(i[0]).get_ref() :
			hitStacks.remove(hitStacks.find(i))
	update()
