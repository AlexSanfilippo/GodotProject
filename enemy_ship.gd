extends Node2D

signal fired
signal died

@export var plasma_scene : PackedScene

var alive = true
var velocity = Vector2.ZERO
var move_state = ""
var cash_reward = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_state = "descend"
	cash_reward = 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		$AnimatedSprite2D.play("default")
		self._move()
	else:
		if not $AnimatedSprite2D.is_playing():
			queue_free()
		
func _move():
	#enemy should first descend into view, then move back and forth while shooting
	if move_state == "descend":
		if self.position.y < randi_range(64, 600):
			self.velocity = Vector2(0.0, 3.0)
		else:
			move_state = "side_to_side"
			self.velocity = Vector2(3.0, 0.0)
	elif move_state == "side_to_side":
		#do some math with distance vectors to move the ship back and forth
		if self.position.x < 100:
			self.velocity = Vector2(3.0, 0.0)
		elif self.position.x > 1000:
			self.velocity = Vector2(-3.0, 0.0)
		#self.velocity = Vector2.ZERO
	self.position += self.velocity


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if alive:
		$AnimatedSprite2D.play("death")
		print("emit ship.died")
		emit_signal("died")
	
	alive = false 
	

func _on_timer_timeout() -> void:
	emit_signal("fired")
	
	var plasma = plasma_scene.instantiate()
	plasma.position = $AnimatedSprite2D.position
	plasma.velocity = Vector2(0, -plasma.speed)
	
	plasma.get_node("AnimatedSprite2D/Area2D").set_collision_mask_value(2, false)
	plasma.get_node("AnimatedSprite2D/Area2D").set_collision_mask_value(3, false)
	plasma.get_node("AnimatedSprite2D/Area2D").set_collision_mask_value(4, false)
	plasma.get_node("AnimatedSprite2D/Area2D").set_collision_mask_value(3, true)
	plasma.get_node("AnimatedSprite2D/Area2D").set_collision_mask_value(1, true)
	plasma.get_node("AnimatedSprite2D/Area2D").set_collision_mask_value(5, true)
	
	plasma.get_node("AnimatedSprite2D/Area2D").set_collision_layer_value(5, false)
	plasma.get_node("AnimatedSprite2D/Area2D").set_collision_layer_value(4, true)
	
	add_child(plasma)

	
