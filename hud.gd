extends CanvasLayer

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cash.text = str('credits: ', score)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_score(val: int):
	score += val
	$Cash.text = str('credits: ', score)
	
func reset_score():
	score = 0
	$Cash.text = str('credits: ', score)
