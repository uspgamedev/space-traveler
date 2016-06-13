
extends Node2D

func _ready():
	pass

func save_game():
	var savegame = File.new()
	savegame.open("res://space-traveler.save", File.WRITE)
	
	var savenodes = get_tree().get_nodes_in_group("Persist")
	for i in savenodes:
		var nodedata = i.save()
		savegame.store_line(nodedata.to_json())
	savegame.close()

func load_game():
	var savegame = File.new()
	if !savegame.file_exists("res://space-traveler.save"):
		self.get_parent().player.skillPath[0] = "res://scenes/bullets/BasicAttack1.xscn"
		self.get_parent().player.skillPath[1] = "res://scenes/bullets/Skill5.xscn"
		self.get_parent().player.skillPath[2] = "res://scenes/bullets/Skill3.xscn"
		self.get_parent().player.skillPath[3] = "res://scenes/bullets/Skill2.xscn"
		return
	
	var savenodes = get_tree().get_nodes_in_group("Persist")
	var currentline = {}
	savegame.open("res://space-traveler.save", File.READ)
	while (!savegame.eof_reached()):
		currentline.parse_json(savegame.get_line())
		if (currentline["tag"] == "player"):
			self.get_parent().player.loadG(currentline)
	savegame.close()
