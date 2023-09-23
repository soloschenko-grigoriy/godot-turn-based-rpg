extends Node

@export var player_character: Node
@export var enemy_character: Node
@export var next_turn_delay: float = 1.0

signal character_begin_turn(character: Character)
signal character_end_turn(character: Character)

var current_character : Character
var game_over : bool = false

func _ready():
	await get_tree().create_timer(0.5).timeout
	begin_next_turn()
	
func begin_next_turn():
	if current_character == player_character:
		current_character = enemy_character
	else:
		current_character = player_character
		
	emit_signal("character_begin_turn", current_character)
	
func end_current_turn():
	emit_signal("character_end_turn", current_character)

	await get_tree().create_timer(next_turn_delay).timeout
	
	if !game_over:
		begin_next_turn()
	
func character_died(character: Character):
	game_over = true
	
	if character.is_player:
		print("Game over")
	else:
		print("You win")
