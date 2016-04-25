
extends Node

var maxHp = 1.0
var curHp = 1.0
var armor = 0.0

func _ready():
	pass

func initBar(newhp):
	get_child(0).set_pos(Vector2(0, -40))
	maxHp = newhp
	curHp = newhp

func takeDamage(damage):
	curHp -= damage*(100/(100+armor))
	updateBar()

func updateBar():
	if (curHp < 0):
		curHp=0
		print("MORREU")
	get_child(0).set_scale(Vector2(curHp/maxHp*0.05, 0.005))
	get_child(0).set_pos(Vector2(-(maxHp-curHp)/maxHp*100/2, get_child(0).get_pos().y))
	
