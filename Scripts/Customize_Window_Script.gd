extends Window


@onready var LabelFontColor : ColorSelector = $"Scroll Container/VBoxContainer/LabelFontColor"
@onready var LabelBg : ColorSelector = $"Scroll Container/VBoxContainer/LabelBackground"
@onready var ButtonFontColor : ColorSelector = $"Scroll Container/VBoxContainer/ButtonFontColor"
@onready var ButtonBgNormalColor : ColorSelector = $"Scroll Container/VBoxContainer/ButtonBgNColor"
@onready var ButtonBgPressedColor : ColorSelector = $"Scroll Container/VBoxContainer/ButtonBgPColor"
@onready var BackGroundColor : ColorSelector = $"Scroll Container/VBoxContainer/BackgroundColor"
@onready var WindowColor : ColorSelector = $"Scroll Container/VBoxContainer/WindowColor"
@onready var FontSize : LineEdit = $"Scroll Container/VBoxContainer/Hbox/LineEdit"

@onready var WarningLabel : FadingLabel = $"Scroll Container/VBoxContainer/Warning"

@onready var SubmitButton : Button = $Button

func _ready():
    Global.has_active_window = true
    _load_in_options()
    SubmitButton.connect("pressed", _on_submit)
    connect("close_requested", queue_free)

func _exit_tree() -> void:
    Global.has_active_window = false

func _load_in_options() -> void:
    LabelFontColor.SetColor(Global.App_Settings.LabelFontColor)
    LabelBg.SetColor(Global.App_Settings.LabelBg)
    ButtonFontColor.SetColor(Global.App_Settings.ButtonFontColor)
    ButtonBgNormalColor.SetColor(Global.App_Settings.ButtonBgNormalColor)
    ButtonBgPressedColor.SetColor(Global.App_Settings.ButtonBgPressedColor)
    BackGroundColor.SetColor(Global.App_Settings.BackGroundColor)
    WindowColor.SetColor(Global.App_Settings.WindowColor)
    FontSize.text = str(Global.App_Settings.FontSize)

func _font_size_is_integer() -> bool:
    return FontSize.text.is_valid_int()

func _check_validity() -> bool:
    var valid : bool = _font_size_is_integer()
    if(not valid):
        WarningLabel.text = "Invalid options!"
        WarningLabel.FadeIn()
    return valid

func _on_submit() -> void:
    if(not _check_validity()): return
    Global.App_Settings.LabelFontColor = LabelFontColor.GetData()
    Global.App_Settings.LabelBg = LabelBg.GetData()
    Global.App_Settings.ButtonFontColor = ButtonFontColor.GetData()
    Global.App_Settings.ButtonBgNormalColor = ButtonBgNormalColor.GetData()
    Global.App_Settings.ButtonBgPressedColor = ButtonBgPressedColor.GetData()
    Global.App_Settings.BackGroundColor = BackGroundColor.GetData()
    Global.App_Settings.WindowColor = WindowColor.GetData()
    Global.App_Settings.FontSize = int(FontSize.text)
    
    Global.SaveSettings()
    Global.App_Settings.EmitChange()
    queue_free()


func _input(event: InputEvent) -> void:
    if(event is InputEventKey):
        if(event.pressed and event.keycode == KEY_ENTER):
            _on_submit()