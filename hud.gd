extends CanvasLayer

var score = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cash.text = str('score: ', score)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_score(val: int):
	print("update_score called in HUD script")
	score += val
	$Cash.text = str('score: ', score)
	
func apples(val: int):
	print("apples")
	score += val
	$Cash.text = str('score: ', score)
