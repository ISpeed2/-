extends Node2D

@onready var school_label: Label = $SchoolLabel
@onready var knock_player: AudioStreamPlayer = $KnockPlayer
@onready var letter: Node = $Letter
@onready var open_prompt: Label = $OpenPrompt
@onready var dialog_box: CanvasLayer = $DialogBox

var opened_letter: bool = false

func _ready():
	school_label.modulate.a = 0.0
	school_label.scale = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_property(school_label, "scale", Vector2(1.1, 1.1), 1.5)
	tween.parallel().tween_property(school_label, "modulate:a", 1.0, 1.5)
	await tween.finished
	
	await get_tree().create_timer(3.0).timeout
	
	knock_player.play()
	await knock_player.finished
	
	letter.show_letter()
	await get_tree().create_timer(0.5).timeout
	
	open_prompt.visible = true
	var prompt_tween = create_tween()
	prompt_tween.tween_property(open_prompt, "modulate:a", 0.3, 0.7)
	prompt_tween.tween_property(open_prompt, "modulate:a", 1.0, 0.7)
	prompt_tween.set_loops()

func _input(event):
	if open_prompt.visible and event.is_action_pressed("ui_accept") and not opened_letter:
		opened_letter = true
		open_prompt.visible = false
		letter.hide_letter()
		await get_tree().create_timer(0.5).timeout
		show_council_dialog()

func show_council_dialog():
	dialog_box.visible = true
	dialog_box.start_dialogue("Высший Совет", [
        "Тебя вызывает Высший Совет для твоего первого задания"
	])
