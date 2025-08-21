extends Resource
class_name Settings

signal OnChange()

@export var LabelFontColor: Color = Color.WHITE
@export var LabelBg: Color = Color(0.09,0.09,0.09,1)
@export var ButtonFontColor: Color = Color.WHITE
@export var ButtonBgNormalColor: Color = Color.BLACK
@export var ButtonBgPressedColor: Color = Color(0, 0.54, 1, 1)
@export var BackGroundColor: Color = Color(0.02, 0.18, 0.24, 0.98)
@export var WindowColor: Color = Color(0.85, 0, 0.35, 1)
@export var FontSize: int = 32

func EmitChange():
    print_debug("Emitting Settings change")
    OnChange.emit()
