
extends Node

var barrier = 0.0
var curHp = 1.0
var aprHp = 1.0
var buffs = []
var nerfs = []
var states = []

var maxHp = 1.0
var speed = 0.0
var armor = 0.0
var shield = 0.0
var AP = 0.0
var AD = 0.0
var luck = 0.0
var vampirism = 0.0

var speedBase = 0.0
var speedMul = 1.0
var speedAdd = 0.0
var armorBase = 0.0
var armorMul = 1.0
var armorAdd = 0.0
var shieldBase = 0.0
var shieldMul = 1.0
var shieldAdd = 0.0
var apBase = 0.0
var apMul = 1.0
var apAdd = 0.0
var adBase = 0.0
var adMul = 1.0
var adAdd = 0.0

var barPos
var time = 0.0
var frames = 0

var speedK = 15.0

func _ready():
	set_process(true)

func initBar(newhp):
	barPos = Vector2(0, -50)
	maxHp = newhp
	curHp = newhp
	aprHp = newhp
	speedBase = 0.0
	speedMul = 1.0
	speedAdd = 0.0
	armorBase = 0.0
	armorMul = 1.0
	armorAdd = 0.0
	shieldBase = 0.0
	shieldMul = 1.0
	shieldAdd = 0.0
	apBase = 0.0
	apMul = 1.0
	apAdd = 0.0
	adBase = 0.0
	adMul = 1.0
	adAdd = 0.0

func setSpeed(Speed):
	speedBase = Speed
	speed = (speedBase + speedAdd)*speedMul
	get_parent().movem.setSpeed(speedK*sqrt(speed))

func setArmor(Armor):
	armorBase = Armor
	armor = (armorBase + armorAdd)*armorMul

func setShield(Shield):
	shieldBase = Shield
	shield = (shieldBase + shieldAdd)*shieldMul

func setAp(Ap):
	apBase = Ap
	AP = (apBase + apAdd)*apMul

func setAd(Ad):
	adBase = Ad
	AD = (adBase + adAdd)*adMul

func addToList(element, list):
	var i = 0
	if (list.empty()):
		list.append(element)
		return
	while i < list.size() :
		if list[i][0] <= -1 or element[0] < list[i][0] :
			list.insert(i, element)
			return
		i += 1

func checkList(list, type):
	for i in list :
		if i[0] >= OS.get_ticks_msec()/1000.0 :
			return
		else :
			if (i[0] <= 0):
				return
			list.remove(list.find(i))
			if (type == 0):
				pass
			elif (type == 1):
				takeNerf(i[1], i[2], 0)
			elif (type == 2):
				takeBuff(i[1], i[2], 0)

func removeItemFX():
	var temp = []
	var count = 0
	for i in buffs :
		if i[0] > -1 :
			temp.append(i)
			count += 1
		else :
			takeNerf(i[1], i[2], 0)
	#buffs = []
	buffs = temp
	temp = []
	for i in nerfs :
		if i[0] > -1 :
			temp.append(i)
			count += 1
		else :
			takeBuff(i[1], i[2], 0)
	nerfs = temp

func takeState (state, time):
	pass

func takeNerf(nerf, nature, time):
	if (nature == 0):
		speedAdd -= nerf
		speed = (speedBase + speedAdd)*speedMul
		get_parent().movem.setSpeed(speedK*sqrt(speed))
	elif (nature == 0.5):
		speedMul /= nerf
		speed = (speedBase + speedAdd)*speedMul
		get_parent().movem.setSpeed(speedK*sqrt(speed))
	elif (nature == 1):
		armorAdd -= nerf
		armor = (armorBase + armorAdd)*armorMul
	elif (nature == 1.5):
		armorMul /= nerf
		armor = (armorBase + armorAdd)*armorMul
	elif (nature == 2):
		shieldAdd -= nerf
		shield = (shieldBase + shieldAdd)*shieldMul
	elif (nature == 2.5):
		shieldMul /= nerf
		shield = (shieldBase + shieldAdd)*shieldMul
	elif (nature == 3):
		apAdd -= nerf
		AP = (apBase + apAdd)*apMul
	elif (nature == 3.5):
		apMul /= nerf
		AP = (apBase + apAdd)*apMul
	elif (nature == 4):
		adAdd -= nerf
		AD = (adBase + adAdd)*adMul
	elif (nature == 4.5):
		adMul /= nerf
		AD = (adBase + adAdd)*adMul
	if time > 0 :
		var nerfItem = [time + OS.get_ticks_msec()/1000.0, nerf, nature]
		addToList(nerfItem, nerfs)
	elif (time <= -1):
		var nerfItem = [time, nerf, nature]
		nerfs.append(nerfItem)

func takeBuff(buff, nature, time):
	if (nature == 0):
		speedAdd += buff
		speed = (speedBase + speedAdd)*speedMul
		get_parent().movem.setSpeed(speedK*sqrt(speed))
	elif (nature == 0.5):
		speedMul *= buff
		speed = (speedBase + speedAdd)*speedMul
		get_parent().movem.setSpeed(speedK*sqrt(speed))
	elif (nature == 1):
		armorAdd += buff
		armor = (armorBase + armorAdd)*armorMul
	elif (nature == 1.5):
		armorMul *= buff
		armor = (armorBase + armorAdd)*armorMul
	elif (nature == 2):
		shieldAdd += buff
		shield = (shieldBase + shieldAdd)*shieldMul
	elif (nature == 2.5):
		shieldMul *= buff
		shield = (shieldBase + shieldAdd)*shieldMul
	elif (nature == 3):
		apAdd += buff
		AP = (apBase + apAdd)*apMul
	elif (nature == 3.5):
		apMul *= buff
		AP = (apBase + apAdd)*apMul
	elif (nature == 4):
		adAdd += buff
		AD = (adBase + adAdd)*adMul
	elif (nature == 4.5):
		adMul *= buff
		AD = (adBase + adAdd)*adMul
	if time > 0 :
		var buffItem = [time + OS.get_ticks_msec()/1000.0, buff, nature]
		addToList(buffItem, buffs)
	elif (time <= -1):
		var buffItem = [time, buff, nature]
		buffs.append(buffItem)

func takeHeal(heal, nature, dir):
	var DamageScene = load("res://scenes/DamageLabel.xscn")
	var Damage = DamageScene.instance()
	add_child(Damage)
	if nature == 0 :
		if (curHp+barrier > maxHp):
			heal = heal*100/(100+(curHp+barrier-maxHp)/2)
			barrier += heal
		barrier += heal
		Damage.showHeal(heal, dir, nature)
	elif nature == 0.5 :
		if (curHp + heal > maxHp):
			heal -= (maxHp - curHp)
			if (curHp+barrier > maxHp):
				heal = heal*100/(100+(curHp+barrier-maxHp)/2)
				barrier += heal
			else :
				barrier += heal
			heal += (maxHp - curHp)
			curHp = maxHp
		else : 
			curHp += heal
		Damage.showHeal(heal, dir, nature)
	return heal

func takeDamage(damage, nature, dir):
	var DamageScene = load("res://scenes/DamageLabel.xscn")
	var Damage = DamageScene.instance()
	add_child(Damage)
	if nature == 0 :
		Damage.showDamage(damage, dir, nature)
		if barrier > 0 :
			barrier -= damage
			if barrier < 0 :
				damage = -barrier
				barrier = 0
			else :
				damage = 0
		curHp -= damage
	elif nature == 1 :
		damage = damage*(100.0/(100.0+armor))
		Damage.showDamage(damage, dir, nature)
		if barrier > 0 :
			barrier -= damage
			if barrier < 0 :
				damage = -barrier
				barrier = 0
			else :
				damage = 0
		curHp -= damage
	elif nature == 1.5 :
		damage = damage
		Damage.showDamage(damage, dir, nature)
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
		Damage.showDamage(damage, dir, nature)
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
	return damage

func _process(delta):
	time += delta
	if (time >= 1):
		time = 0.0
		if(curHp < maxHp):
			takeHeal(vampirism/10.0*maxHp, 0.5, Vector2(0, 1))
	checkList(states, 0)
	checkList(buffs, 1)
	checkList(nerfs, 2)
	#print("Base = ", speedBase, "Add = ", speedAdd, "Mul = ", speedMul, "Cur = ", speed)
	if curHp > maxHp :
		curHp = maxHp
	if barrier > 0 :
		barrier -= 4*vampirism/10.0*maxHp*delta
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
		aprHp -= 0.007*maxHp
		if (aprHp < curHp):
			aprHp = curHp
	elif (curHp > aprHp) :
		draw_rect (Rect2(Vector2(-50 + aprHp/tempMax*100.0, barPos.y), Vector2((curHp-aprHp)/tempMax*100.0, 10)), Color(185.0/255, 246.0/255, 202.0/255, 0.8))
		aprHp += 0.01*maxHp
		if (aprHp > curHp):
			aprHp = curHp
	
	var indexHP = 100
	while indexHP < tempMax :
		if (indexHP%1000 != 0):
			draw_line(Vector2(-50.0 + indexHP/tempMax*100.0, barPos.y ), Vector2(-50.0 + indexHP/tempMax*100.0, barPos.y + 6), Color(117.0/255, 117.0/255, 117.0/255, 0.8), 1)
		else:
			draw_line(Vector2(-50.0 + indexHP/tempMax*100.0, barPos.y ), Vector2(-50.0 + indexHP/tempMax*100.0, barPos.y + 6), Color(117.0/255, 117.0/255, 117.0/255, 0.8), 2)
		indexHP += 100
