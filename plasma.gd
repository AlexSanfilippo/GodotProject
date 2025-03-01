extends Node2D

#later: determined by weapon type
var speed = 10.0
var velocity = Vector2(0.0, -speed)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
