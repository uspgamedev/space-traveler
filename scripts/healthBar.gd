
extends Node

var barrier = 0.0
var maxHp = 1.0
var curHp = 1.0
var aprHp = 1.0
var healthRegen = 0.025
var armor = 0.0
var shield = 0.0
var barPos

func _ready():
	set_process(true)

func initBar(newhp):
	barPos = Vector2(0, -50)
	maxHp = newhp
	curHp = newhp
	aprHp = newhp

func takeDamage(damage, nature, dir):
	var DamageScene = load("res://scenes/DamageLabel.xscn")
	var Damage = DamageScene.instance()
	add_child(Damage)
	Damage.showDamage (damage, dir, nature)
	if nature == 1 :
		damage = damage*(100.0/(100.0+armor))
		if barrier > 0 :
			barrier -= damage
			if barrier < 0 :
				damage = -barrier
				barrier = 0
			else :
				damage = 0
		curHp -= damage
	elif nature == 2 :
		damage = damage*(100.0/(100.0+shield))
		if barrier > 0 :
			barrier -= damage
			if barrier < 0 :
				damage = -barrier
				barrier = 0
			else :
				damage = 0
		curHp -= damage
	if (curHp < 0):
		curHp=0
		print("MORREU")

func _process(delta):
	curHp += healthRegen*maxHp*delta
	if curHp > maxHp :
		curHp = maxHp
	if barrier > 0 :
		barrier -= 2
	update()

func _draw():
	var tempMax = maxHp
	if (barrier + curHp > maxHp):
		tempMax = barrier + curHp
	
	draw_rect (Rect2(Vector2(-52, barPos.y-2), Vector2(104, 14)), Color(158.0/255, 158.0/255, 158.0/255, 1.0))
	draw_rect (Rect2(Vector2(-50, barPos.y), Vector2(100, 10)), Color(117.0/255, 117.0/255, 117.0/255, 1.0))
	draw_rect (Rect2(Vector2(-50, barPos.y), Vector2(curHp/tempMax*100.0, 10)), Color(0.0/255, 230.0/255, 118.0/255, 0.8))
	if (barrier > 0) :
		draw_rect (Rect2(Vector2(-50 + curHp/tempMax*100.0, barPos.y), Vector2(barrier/tempMax*100.0, 10)), Color(224.0/255, 224.0/255, 224.0/255, 0.8))
	
	if (curHp < aprHp) :
		draw_rect (Rect2(Vector2(-50 + curHp/tempMax*100.0, barPos.y), Vector2((aprHp-curHp)/tempMax*100.0, 10)), Color(244.0/255, 67.0/255, 54.0/255, 0.8))
		aprHp -= 0.01*maxHp
		if (aprHp < curHp):
			aprHp = curHp
	elif (curHp > aprHp) :
		draw_rect (Rect2(Vector2(-50 + aprHp/tempMax*100.0, barPos.y), Vector2((curHp-aprHp)/tempMax*100.0, 10)), Color(185.0/255, 246.0/255, 202.0/255, 0.8))
		aprHp += 0.01*maxHp
		if (aprHp > curHp):
			aprHp = curHp
	
	var indexHP = 100
	while indexHP < tempMax :
		print (indexHP)
		if (indexHP%1000 != 0):
			draw_line(Vector2(-50.0 + indexHP/tempMax*100.0, barPos.y ), Vector2(-50.0 + indexHP/tempMax*100.0, barPos.y + 6), Color(117.0/255, 117.0/255, 117.0/255, 0.8), 1)
		else:
			draw_line(Vector2(-50.0 + indexHP/tempMax*100.0, barPos.y ), Vector2(-50.0 + indexHP/tempMax*100.0, barPos.y + 6), Color(117.0/255, 117.0/255, 117.0/255, 0.8), 2)
		indexHP += 100
