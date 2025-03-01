extends Node2D

@export var plasma_scene: PackedScene
@export var asteroid_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_fired() -> void:
	var plasma = plasma_scene.instantiate()
	plasma.position = $Player.position + Vector2(67.5, 0)
	add_child(plasma)
	
	
func _spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	asteroid.position = Vector2(randf_range(100,900), randf_range(-0.50, -150))
	add_child(asteroid)
	

func _on_timer_timeout() -> void:
	self._spawn_asteroid()
	
func _generate_new_level():
	#pick new enemies, spawn timers, rewards for new stage
	pass
