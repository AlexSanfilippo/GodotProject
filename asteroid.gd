extends Node2D

var velocity =  Vector2(0.0, 2.0)
var alive = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(randf_range(-1.0, 1.0), randf_range(1.0, 5.0)) # Replace with function body.

var death_animation_played = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		$AnimatedSprite2D.play("default")
		self._do_movement()
	else:
		if not $AnimatedSprite2D.is_playing():
			queue_free()
		#
func _do_movement():
	self.position += velocity
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	$AnimatedSprite2D.play("death")
	alive = false
	
