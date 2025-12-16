extends CanvasLayer
class_name DialogBox

@onready var name_label: Label = $Bg/MarginContainer/VBoxContainer/NameLabel
@onready var dialog_label: RichTextLabel = $Bg/MarginContainer/VBoxContainer/DialogLabel
@onready var next_button: TextureButton = $Bg/MarginContainer/VBoxContainer/NextButton
@onready var voice_player: AudioStreamPlayer = $VoicePlayer

var dialogues: Array[String] = []
var current_dialogue_index: int = 0
var current_char_index: int = 0
var is_typing: bool = false
var char_delay: float = 0.05

signal dialogue_ended

func start_dialogue(name_text: String, texts: Array[String]):
	visible = true
	name_label.text = name_text
	dialogues = texts
	current_dialogue_index = 0
	next_button.visible = false
	type_next_line()

func type_next_line():
	if current_dialogue_index >= dialogues.size():
		end_dialogue()
		return
	is_typing = true
	dialog_label.text = ""
	current_char_index = 0
	type_next_char()

func type_next_char():
	if current_char_index < dialogues[current_dialogue_index].length():
		dialog_label.text += dialogues[current_dialogue_index][current_char_index]
		if voice_player.stream: voice_player.play()
		current_char_index += 1
		await get_tree().create_timer(char_delay).timeout
		type_next_char()
	else:
		is_typing = false
		next_button.visible = true

func _on_next_button_pressed():
	if is_typing:
		dialog_label.text = dialogues[current_dialogue_index]
		voice_player.stop()
		is_typing = false
		next_button.visible = true
	else:
		current_dialogue_index += 1
		next_button.visible = false
		type_next_line()

func end_dialogue():
	visible = false
	dialogue_ended.emit()

func _input(event):
	if visible and event.is_action_pressed("ui_accept"):
		_on_next_button_pressed()
		get_viewport().set_input_as_handled()

func _ready():
	next_button.pressed.connect(_on_next_button_pressed)
