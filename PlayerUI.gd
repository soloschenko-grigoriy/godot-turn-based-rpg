extends VBoxContainer

@export var buttons: Array

func _ready():
	get_node("/root/BattleScene").character_begin_turn.connect(_on_character_begin_turn)
	get_node("/root/BattleScene").character_end_turn.connect(_on_character_end_turn)
	
func _on_character_begin_turn(character: Character):
	visible = character.is_player
	
	if character.is_player:
		_display_combat_actions(character.combat_actions)
	
func _on_character_end_turn(_character: Character):
	visible = false

func _display_combat_actions(combat_actions):
	for i in len(buttons):
		var btn = get_node(buttons[i])
		
		if i < len(combat_actions):
			btn.visible = true
			btn.text = combat_actions[i].display_name
			btn.combat_action = combat_actions[i]
		else:
			btn.visible = false
