@tool
extends HBoxContainer

class_name ColorSelector


@onready var _label : Label = $Label
@onready var _color_picker : ColorPickerButton = $ColorPickerButton

@export var LabelText : String :
    set(value):
        LabelText = value
        if _label:
            _label.text = value
    get():
        return LabelText

func _ready():
    _label.text = LabelText

func GetData() -> Color:
    return _color_picker.color

func SetColor(clr : Color) -> void:
    _color_picker.color = clr
