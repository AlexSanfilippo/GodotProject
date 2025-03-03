extends Node2D

@export var plasma_scene: PackedScene
@export var asteroid_scene: PackedScene
@export var enemy_ship1_scene: PackedScene
@export var player_scene: PackedScene

signal update_score

var difficulty = 1
var current_level = []
var enemy_count = 0

var player = null

#define state of game
#main_menu, run_game, death_screen, victory_screen
#todo: change start state to main_menu
var state = "run_game"
var state_to_method = {
	"run_game": _run_game,
	"death_screen": _death_screen,
	"main_menu": _main_menu,
	"victory_screen": _victory_screen,
	}


func _run_game():
	self._run_level()
	
	
func _death_screen():
	pass
	
	
func _victory_screen():
	pass
	
	
func _main_menu():
	pass
	
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.current_level = self._generate_new_level(1)
	self.player = player_scene.instantiate()
	add_child(self.player)
	self.player.fired.connect(_on_player_fired)
	self.player.died.connect(_on_player_died)
	
	
	#connect signal from HUD try again to function in main to reset game
	$HUD/TryAgain.pressed.connect(_reset_game)
	
func _reset_game():
	#restart the game
	self.difficulty = 0
	self.current_level = []
	self.enemy_count = 0
	self.state = "run_game"
	
	#reset HUD
	$HUD.reset_score()
	$HUD/GameOver.visible = false
	$HUD/TryAgain.visible = false
	
	#reset level
		#how to clear all child nodes from tree?
			#not all nodes, just enemies we've spawned
	get_tree().call_group("enemies", "queue_free")
	#instantiate a new player
	self.player = player_scene.instantiate()
	self.player.fired.connect(_on_player_fired)
	self.player.died.connect(_on_player_died)
	add_child(self.player)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.state_to_method[self.state].call()
	


func _increase_score(amount: int):
	$HUD.score += amount

func _on_player_fired() -> void:	
	var plasma = plasma_scene.instantiate()
	plasma.position = self.player.position + Vector2(67.5, 0)
	add_child(plasma)
	
	
func _spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	asteroid.position = Vector2(randf_range(100,900), randf_range(-0.50, -150))
	add_child(asteroid)
	
func _spawn_enemy_ship():
	var ship = enemy_ship1_scene.instantiate()
	ship.position = Vector2(randf_range(100,900), randf_range(-0.50, -150))
	ship.died.connect(_update_score)
	add_child(ship)
	ship.add_to_group("enemies")
	
#todo: remove this
func _update_score():
	#update the scoreboard
	print("signal -died- received in main script")
	enemy_count -= 1
	print("enemy_count is now; ", enemy_count)
	$HUD.update_score(50)


func _on_timer_timeout() -> void:
	pass


var enemies_easy = ["asteroid", "ship1"]
var enemies_medium = ["asteroid", "ship1"]
var enemies_hard = ["asteroid", "ship1"]
var difficulty_to_enemies = {
	1: enemies_easy,
	2: enemies_easy,
	3: enemies_medium,
	4: enemies_medium,
	5: enemies_hard,
	}
var difficulty_to_quantity = {
	1: 3,
	2: 5,
	3: 7,
	4: 9,
	5: 10,
	}
var node_constructors = {"asteroid": _spawn_asteroid, "ship1": _spawn_enemy_ship}

func _generate_new_level(difficulty_new):
	#pick new enemies, spawn timers, rewards for new stage
	var multiplicy = 3
	self.difficulty = difficulty_new
	var quantity_per_wave = difficulty_to_quantity[self.difficulty]
	
	var waves_per_level = 1
	
	var level = []
	for i in waves_per_level:
		var wave = []
		for j in quantity_per_wave:
			wave.append(difficulty_to_enemies[self.difficulty].pick_random())
		level.append(wave)
	print("generated level: ", self.difficulty, ' --> ',level)
	return level 



func _run_level():
	if not self.current_level.is_empty():
		if self.enemy_count == 0:
			var wave = self.current_level.pop_back()	
			for enemy in wave:
				node_constructors[enemy].call()	
				if enemy == "ship1":
					self.enemy_count += 1
	else:
		if self.difficulty > 2:
			print("==========Wow, you win!=======")
			self.state = "victory_screen"
		else:
			self.difficulty += 1
			self.current_level = _generate_new_level(self.difficulty)
		
	
func _on_player_died() -> void:
	print("on player died in main")
	self.state = "death_screen"
	$HUD/GameOver.visible = true
	$HUD/TryAgain.visible = true
