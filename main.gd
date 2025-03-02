extends Node2D

@export var plasma_scene: PackedScene
@export var asteroid_scene: PackedScene
@export var enemy_ship1_scene: PackedScene

signal update_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._spawn_enemy_ship()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _increase_score(amount: int):
	$HUD.score += amount

func _on_player_fired() -> void:	
	var plasma = plasma_scene.instantiate()
	plasma.position = $Player.position + Vector2(67.5, 0)
	add_child(plasma)
	
	
func _spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	asteroid.position = Vector2(randf_range(100,900), randf_range(-0.50, -150))
	add_child(asteroid)
	
func _spawn_enemy_ship():
	var ship = enemy_ship1_scene.instantiate()
	ship.position = Vector2(randf_range(100,900), randf_range(-0.50, -150))
	#ship.fired.connect(_on_enemy_fired)
	#ship.died.connect(_update_score)
	#ship.died.connect($HUD.update_score)
	#$HUD.update_score(50) 
	#How can I connect the signal directly to the func in node HUD? Possible?
	ship.died.connect(_update_score)
	#ship.died.connect($HUD.apples)
	add_child(ship)
	
#todo: remove this
func _update_score():
	#update the scoreboard
	print("signal -died- received in main script")
	$HUD.update_score(50)


func _on_timer_timeout() -> void:
	var choice = randi_range(0,1)
	self._spawn_enemy_ship()
	#if choice == 0:
		#self._spawn_asteroid()
	#if choice == 1:
		#self._spawn_enemy_ship()
	
func _generate_new_level():
	#pick new enemies, spawn timers, rewards for new stage
	pass
