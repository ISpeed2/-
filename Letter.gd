extends Control

@onready var icon: ColorRect = $LetterIcon

signal opened

func show_letter():
	scale = Vector2.ZERO
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)

func hide_letter():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	visible = false
	modulate.a = 1.0
	scale = Vector2.ONE
	opened.emit()
