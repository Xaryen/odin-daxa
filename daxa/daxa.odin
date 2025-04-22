package daxa

@(extra_linker_flags="/NODEFAULTLIB:libcmt /NODEFAULTLIB:libucrt")
@(export)foreign import lib "daxa.lib"


@(require)
foreign import __ "vulkan-1.lib"

@(require)
foreign import ___ "imgui_windows_x64.lib"

