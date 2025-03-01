extends Node2D


#create a signal for when the shoots a shot
signal fired

var alive = true
var velocity = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var plasma_scene: PackedScene



func _do_movement():
	var force_acceleration = 4.25
	var vector_acceleration = Vector2.ZERO
	var any_acceleration = false
	var velocity_updated = Vector2.ZERO
	
	#maximum ship speed to be set by engine type later on
	var speed_limit = 20.0
	
	#How fast ship slows to stop when no user input
	var force_friction = 0.7
	
	if alive:
		if Input.is_action_pressed("move_right"):
			if (velocity + Vector2(force_acceleration, 0.0)).length() < speed_limit:
				vector_acceleration.x += force_acceleration
				any_acceleration = true
		if Input.is_action_pressed("move_left"):
			if (velocity - Vector2(force_acceleration, 0.0)).length() < speed_limit:
				vector_acceleration.x -= force_acceleration
				any_acceleration = true
		if Input.is_action_pressed("move_down"):
			if (velocity + Vector2(0.0, force_acceleration)).length() < speed_limit:
				vector_acceleration.y += force_acceleration
				any_acceleration = true
		if Input.is_action_pressed("move_up"):
			if (velocity - Vector2(0.0, force_acceleration)).length() < speed_limit:
				vector_acceleration.y -= force_acceleration
				any_acceleration = true
			
		#normalize the acceleration (for diagonal movement)
		if vector_acceleration.length() > force_acceleration:
			vector_acceleration *= 0.7071
		#accelerate the ship
		velocity += vector_acceleration
		#auto-break the ship if no player input
		if not any_acceleration:
			self.velocity *= force_friction
	
	
	
	
	self.position += velocity
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#how fast the ship reaches max speed.  Set by engine type later on
	self._do_movement()
	
	#plays the sprite animation
	if alive:
		$PlayerSprite.play("default") 
		if Input.is_action_just_pressed("fire_primary"):
			emit_signal("fired")
	else:
		if not $PlayerSprite.is_playing():
			queue_free()
	

		

		
func _player_death():
	alive = false
	print("ship hit!")
	$PlayerSprite.play("death")


func _on_area_2d_area_entered(area: Area2D) -> void:
	self._player_death()
