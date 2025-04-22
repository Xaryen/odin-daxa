package main


import "base:runtime"
import "core:fmt"
import "core:log"
import "vendor:glfw"
import vk "vendor:vulkan"
import "daxa"

Context :: struct {
	ctx: runtime.Context,
	window: glfw.WindowHandle,
	w, h: i32,
	framebuffer_resized: bool,
}

ctx := Context{}

result :: proc(res: daxa.Result)
{
    if res != .SUCCESS {
        fmt.eprintf("DAXA ERROR: %d\n", res);
        assert(false, "result failed");
    }
}


get_native_handle :: proc() -> daxa.NativeWindowHandle
{
	return glfw.GetWin32Window(ctx.window)
}

get_native_platform :: proc() -> daxa.NativeWindowPlatform
{
	switch glfw.GetPlatform() {
	case glfw.PLATFORM_WIN32: return daxa.NativeWindowPlatform.WIN32_API
	case: panic("Unsupported Platform.")
	}
}

set_mouse_capture :: #force_inline proc(should_capture: bool)
{
	glfw.SetCursorPos(ctx.window, cast(f64)(ctx.w / 2.), cast(f64)(ctx.h / 2.));
	glfw.SetInputMode(ctx.window, glfw.CURSOR, should_capture ? glfw.CURSOR_DISABLED : glfw.CURSOR_NORMAL);
	glfw.SetInputMode(ctx.window, glfw.RAW_MOUSE_MOTION, i32(should_capture));
}

should_close :: #force_inline proc() -> bool
{
	return bool(glfw.WindowShouldClose(ctx.window))
}
    
update :: #force_inline proc()
{
	glfw.PollEvents()
	//glfw.SwapBuffers(ctx.window)
}
    
//get_glfw_window :: #force_inline proc() -> glfw.WindowHandle
//{
//	return g_window;
//}

glfw_error_callback :: proc "c" (code: i32, description: cstring) {
	context = ctx.ctx
	log.errorf("glfw: %i: %s", code, description)
}

main :: proc()
{
	context.logger = log.create_console_logger()
	ctx.ctx = context

	glfw.SetErrorCallback(glfw_error_callback)

	if !glfw.Init() {log.panic("glfw: could not be initialized")}
	defer glfw.Terminate()

	glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	glfw.WindowHint(glfw.RESIZABLE, glfw.TRUE)

	ctx.w = 800
	ctx.h = 600

	ctx.window = glfw.CreateWindow(ctx.w, ctx.h, "Daxa", nil, nil)
	defer glfw.DestroyWindow(ctx.window)

	glfw.SetFramebufferSizeCallback(ctx.window, proc "c" (_: glfw.WindowHandle, _, _: i32) {
		ctx.framebuffer_resized = true
	})

	to_smallstring :: proc(s: string) -> daxa.SmallString
	{
		ss: daxa.SmallString
		copy(ss.data[:], s)
		ss.size = u8(len(s))
		return ss
	}

	instance: daxa.Instance
	instance_info := daxa.DEFAULT_INSTANCE_INFO
	instance_info.engine_name = to_smallstring("daxa")
	instance_info.app_name    = to_smallstring("daxa app")

	result(daxa.create_instance(&instance_info, &instance))

	
	device:      daxa.Device
	device_info: daxa.DeviceInfo2
	
	device_info = daxa.DEFAULT_DEVICE_INFO_2
	daxa.instance_choose_device(instance, .SWAPCHAIN, &device_info)
	
	fmt.println(device_info)

	result(daxa.instance_create_device_2(instance, &device_info, &device))

	daxa.dvc_dec_refcnt(device)
	daxa.instance_dec_refcnt(instance)
	
	//swapchain:     daxa.Swapchain
	//swapchaininfo := daxa.SwapchainInfo{
	//	native_window           = get_native_handle(),
	//	native_window_platform  = get_native_platform(),
	//	surface_format_selector = proc(format: vk.Format) -> i32
	//	{
	//		#partial switch format {
	//		case .R8G8B8A8_UINT: return 100
	//		case: return daxa.default_format_selector(format)
	//		}
	//	},
	//	present_mode            = .FIFO,
	//	image_usage             = {.TRANSFER_DST},
	//	name                    = to_smallstring("test swapchain"),

	//}
	//daxa.dvc_create_swapchain(device, &swapchaininfo, &swapchain)

	MyVertex :: struct{
		position: [3]f32,
		color: [3]f32,
	};

	//DAXA_DECL_BUFFER_PTR(MyVertex)

	//struct MyPushConstant
	//{
	//daxa_BufferPtr(MyVertex) my_vertex_ptr;
	//};

	//fmt.println(device_info)

	//pipeline_manager = daxa.Pipeline

	i: int
	//for !should_close() {
	for i < 1000 {
		i += 1
		update()
	}

	fmt.println("finished running")
}