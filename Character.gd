extends Node2D
class_name Character

@export var is_player: bool
@export var current_hp: int = 25
@export var max_hp: int = 25

@export var combat_actions : Array
@export var opponent : Node

@export var texture: Texture2D
@export var flip_texture: bool
 
@onready var health_bar : ProgressBar = get_node("HealthBar")
@onready var health_text : Label = get_node("HealthBar/HealthText")

func _ready():
	$Sprite.texture = texture
	$Sprite.flip_h = flip_texture
	
	get_node("/root/BattleScene").character_begin_turn.connect(_on_character_begin_turn)
	health_bar.max_value = max_hp
	
	_update_health_bar()

func take_damage(damage: int):
	current_hp -= damage
	
	if current_hp <= 0:
		get_node("/root/BattleScene").character_died(self)
		queue_free()
	
	_update_health_bar()
		
func heal(amount: int):
	current_hp = clamp(current_hp + amount, 0, max_hp)
	_update_health_bar()
	
func _update_health_bar():
	health_bar.value = current_hp
	health_text.text = str(current_hp, "/", max_hp)

func _on_character_begin_turn(character):
	if character == self and !is_player:
		decide_combat_action()

func cast_combat_action(action):
	if action.damage > 0:
		opponent.take_damage(action.damage)
	elif action.heal > 0:
		heal(action.heal)
	
	get_node("/root/BattleScene").end_current_turn()
		

func decide_combat_action():
	var health_percent = float(current_hp) / float(max_hp)
	
	for i in combat_actions:
		var action = i as CombatAction
		
		if action.heal > 0:
			if randf() > health_percent + 0.2:
				cast_combat_action(action)
				return
			else:
				continue
		else:
			cast_combat_action(action)
			return
				
				
