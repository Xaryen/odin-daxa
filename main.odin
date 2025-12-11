package main

import "base:runtime"
import "core:strings"
import "core:fmt"
import "core:log"
import "vendor:glfw"

import vk "vendor:vulkan"

import "daxa"

Program :: struct {
	ctx:                 runtime.Context,
	window:              glfw.WindowHandle,
	w, h:                i32,
	framebuffer_resized: bool,
	device:              daxa.Device,
	instance:            daxa.Instance,
	swapchain:           daxa.Swapchain,
}
ctx := Program{}


result :: proc(res: daxa.Result, loc := #caller_location, exp := #caller_expression) {
	if res > .NOT_READY {
	fmt.eprintfln("DAXA ERROR: %v %v %v", res, loc, exp)
	assert(false, "result failed")
	}
	log.info(res, loc, exp)
}

get_native_handle :: proc() -> daxa.NativeWindowHandle {
	return glfw.GetWin32Window(ctx.window)
}

get_native_platform :: proc() -> daxa.NativeWindowPlatform {
	switch glfw.GetPlatform() {
	case glfw.PLATFORM_WIN32: return daxa.NativeWindowPlatform.WIN32_API
	case: panic("Unsupported Platform.")
	}
}

set_mouse_capture :: #force_inline proc(should_capture: bool) {
	glfw.SetCursorPos(ctx.window, cast(f64)(ctx.w / 2.), cast(f64)(ctx.h / 2.))
	glfw.SetInputMode(ctx.window, glfw.CURSOR, should_capture ? glfw.CURSOR_DISABLED : glfw.CURSOR_NORMAL)
	glfw.SetInputMode(ctx.window, glfw.RAW_MOUSE_MOTION, i32(should_capture))
}

should_close :: #force_inline proc() -> bool {
	return bool(glfw.WindowShouldClose(ctx.window))
}
	
poll_events :: #force_inline proc() {
	glfw.PollEvents()
}
	
glfw_error_callback :: proc "c" (code: i32, description: cstring) {
	context = ctx.ctx
	log.errorf("glfw: %i: %s", code, description)
}

MyVertex :: struct {
	position: [3]f32,
	color:    [3]f32,
}

MyPushConstant :: struct {
	vertices: daxa.DeviceAddress,
}

main :: proc() {
	// context.logger = log.create_console_logger()
	ctx.ctx = context

	glfw.SetErrorCallback(glfw_error_callback)

	if !glfw.Init() {log.panic("glfw: could not be initialized")}
	defer glfw.Terminate()

	glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	glfw.WindowHint(glfw.RESIZABLE, glfw.TRUE)

	ctx.w = 800
	ctx.h = 600

	ctx.window = glfw.CreateWindow(ctx.w, ctx.h, "Daxa - Odin", nil, nil)
	defer glfw.DestroyWindow(ctx.window)

	glfw.SetFramebufferSizeCallback(ctx.window, proc "c" (_: glfw.WindowHandle, _, _: i32) {
		ctx.framebuffer_resized = true
	})

	instance_info := daxa.DEFAULT_INSTANCE_INFO
	instance_info.engine_name = daxa.small_string("daxa")
	instance_info.app_name    = daxa.small_string("daxa app")

	result(daxa.create_instance(&instance_info, &ctx.instance))

	device_info := daxa.DEFAULT_DEVICE_INFO_2
	result(daxa.instance_choose_device(ctx.instance, {.SWAPCHAIN}, &device_info))

	
	result(daxa.instance_create_device_2(ctx.instance, &device_info, &ctx.device))

	test_props := daxa.dvc_properties(ctx.device)
	fmt.println(test_props^)
	fmt.printfln("%s", test_props.device_name[:])
	swapchaininfo := daxa.SwapchainInfo{
		native_window           = get_native_handle(),
		native_window_platform  = get_native_platform(),
		// surface_format_selector = daxa.default_format_selector,
		surface_format_selector = proc "c" (format: vk.Format) -> i32 {
			#partial switch format {
			case .R8G8B8A8_UNORM: return 100
			case: return daxa.default_format_selector(format)
			}
		},
		present_mode                 = .MAILBOX,
		present_operation            = {.IDENTITY},
		image_usage                  = {.TRANSFER_DST},
		max_allowed_frames_in_flight = 2,
		name                         = daxa.small_string("test swapchain"),
	}

	result(daxa.dvc_create_swapchain(ctx.device, &swapchaininfo, &ctx.swapchain))

	

	// simplest_test()
	// copy_test()

	// pink_screen()

	// triangle()

	compute_triangle()

	result(daxa.dvc_wait_idle(ctx.device))
	result(daxa.dvc_collect_garbage(ctx.device))
	daxa.dvc_dec_refcnt(ctx.device)
	daxa.instance_dec_refcnt(ctx.instance)

	log.info("finished running")
}

compute_triangle :: proc() {
	
	size_x := daxa.swp_get_surface_extent(ctx.swapchain).width
	size_y := daxa.swp_get_surface_extent(ctx.swapchain).height

	render_image: daxa.ImageId
	render_image_info := daxa.DEFAULT_IMAGE_INFO
	render_image_info.dimensions = 2
	render_image_info.format = .R8G8B8A8_UNORM
	render_image_info.size = {size_x, size_y, 1}
	render_image_info.usage = {.SHADER_STORAGE, .TRANSFER_SRC}
	render_image_info.name = daxa.small_string("render_image")
	result(daxa.dvc_create_image(
		device = ctx.device,
		info = &render_image_info,
		out_id = &render_image,
	))

	comp_shader := #load("test_shaders/compute_triangle/comp.spv", []u32)

	compute_pipeline: daxa.ComputePipeline 
	result(daxa.dvc_create_compute_pipeline(
		device = ctx.device,
		info = &{
			shader_info = {
				 byte_code = &comp_shader[0],
			        byte_code_size = u32(len(comp_shader)),
			        create_flags = {},
			        entry_point = daxa.small_string("main"),
			},
			push_constant_size = size_of(ComputePush),
			name = daxa.small_string("my compute shader"),
		},
		out_pipeline = &compute_pipeline
	))

	ComputePush :: struct {
		image:     daxa.ImageViewId,
		frame_dim: [2]u32,
	}

	push_constant: ComputePush

	i: int = -1 
	for !should_close() {
		i += 1
		log.info("begin frame:", i)
		poll_events()

		if ctx.framebuffer_resized {
			result(daxa.swp_resize(ctx.swapchain))
			daxa.dvc_destroy_image(ctx.device, render_image)
			size_x = daxa.swp_get_surface_extent(ctx.swapchain).width
			size_y = daxa.swp_get_surface_extent(ctx.swapchain).height
			render_image_info.size = {size_x, size_y, 1}
			result(daxa.dvc_create_image(
				device = ctx.device,
				info = &render_image_info,
				out_id = &render_image,
			))
			ctx.framebuffer_resized = false
		}

		swapchain_image: daxa.ImageId
		acq_result := daxa.swp_acquire_next_image(ctx.swapchain, &swapchain_image)
		assert(daxa.version_of_image(swapchain_image) != 0)

		recorder: daxa.CommandRecorder
		result(daxa.dvc_create_command_recorder(
			ctx.device,
			&{ name = daxa.small_string("my command recorder") },
			&recorder,
		))


		swapchain_image_info: daxa.ImageInfo
		result(daxa.dvc_info_image(
			ctx.device,
			swapchain_image,
			&swapchain_image_info
		))

		result(daxa.cmd_pipeline_image_barrier(
			cmd_enc = recorder,
			info = &{
				dst_access = daxa.ACCESS_COMPUTE_SHADER_READ_WRITE,
				image_id   = render_image,
				layout_operation = .TO_GENERAL,
			},
		))

		result(daxa.cmd_set_compute_pipeline(
			cmd_enc = recorder,
			pipeline = compute_pipeline,
		))

		push_constant = {
			image = daxa.default_view(render_image),
			frame_dim = { size_x, size_y },
		}

		result(daxa.cmd_push_constant(
			cmd_enc = recorder,
			info = &{
				data = &push_constant,
				size = size_of(push_constant),
			},
		))

		result(daxa.cmd_dispatch(
			cmd_enc = recorder,
			info = &{
				x = (size_x + 7) / 8,
				y = (size_y + 7) / 8,
				z = 1,
			}
		))

		result(daxa.cmd_pipeline_image_barrier(
			cmd_enc = recorder,
			info = &{
				dst_access = daxa.ACCESS_BLIT_READ,
				image_id   = render_image,
				layout_operation = .TO_GENERAL,
			},
		))

		result(daxa.cmd_pipeline_image_barrier(
			cmd_enc = recorder,
			info = &{
				dst_access = daxa.ACCESS_BLIT_WRITE,
				image_id   = swapchain_image,
				layout_operation = .TO_GENERAL,
			},
		))

		result(daxa.cmd_blit_image_to_image(
			cmd_enc = recorder,
			info = &{
				src_image        = render_image,
				src_image_layout = .GENERAL,
				dst_image        = swapchain_image,
				dst_image_layout = .GENERAL,
				src_slice        = daxa.DEFAULT_IMAGE_ARRAY_SLICE,
				dst_slice        = daxa.DEFAULT_IMAGE_ARRAY_SLICE,
				src_offsets      = {{0, 0, 0}, { i32(size_x), i32(size_y), 1 } },
				dst_offsets      = {{0, 0, 0}, { i32(size_x), i32(size_y), 1 } },
				filter           = .NEAREST,
			}
		))

		result(daxa.cmd_pipeline_image_barrier(
			cmd_enc = recorder,
			info = &{
				src_access = daxa.ACCESS_BLIT_WRITE,
				image_id   = swapchain_image,
				layout_operation = .TO_PRESENT_SRC,
			}
		))

		executable_commands: daxa.ExecutableCommandList
		result(daxa.cmd_complete_current_commands(recorder, &executable_commands))

		daxa.destroy_command_recorder(recorder)

		acquire_semaphore := daxa.swp_current_acquire_semaphore(ctx.swapchain)
		present_semaphore := daxa.swp_current_present_semaphore(ctx.swapchain)

		current_timeline_pair :: proc() -> daxa.TimelinePair {
			gpu_value := daxa.swp_gpu_timeline_semaphore(ctx.swapchain)^
			cpu_value := daxa.swp_current_cpu_timeline_value(ctx.swapchain)
			return {gpu_value, cpu_value}
		}

		timeline_pair := current_timeline_pair()
		result(daxa.dvc_submit(
			device = ctx.device,
			info = &{
				command_lists = &executable_commands,
				command_list_count = 1,
				wait_binary_semaphores = acquire_semaphore,
				wait_binary_semaphore_count = 1,
				signal_binary_semaphores = present_semaphore,
				signal_binary_semaphore_count = 1,
				signal_timeline_semaphores = &timeline_pair,
				signal_timeline_semaphore_count = 1,
				// wait_stages: vk.PipelineStageFlags,
				// wait_timeline_semaphores: ^TimelinePair, //const *
				// wait_timeline_semaphore_count: u64,
			},
		))

		daxa.executable_commands_dec_refcnt(executable_commands)

		result(daxa.dvc_present(
			device = ctx.device,
			info = &{
				wait_binary_semaphores      = present_semaphore,
				wait_binary_semaphore_count = 1,
				swapchain                   = ctx.swapchain,
				queue                       = {},
			}
		))

		result(daxa.dvc_collect_garbage(ctx.device))

		log.info("end frame:", i)
		// if i > 1000 do break
	}

}

triangle :: proc() {
	
	vert_shader := #load("test_shaders/triangle/vert.spv", []u32)
	frag_shader := #load("test_shaders/triangle/frag.spv", []u32)

	raster_pipeline: daxa.RasterPipeline 
	result(daxa.dvc_create_raster_pipeline(
		device       = ctx.device,
		info         = &{
			vertex_shader_info = {
				value = { byte_code = &vert_shader[0],
				        byte_code_size = u32(len(vert_shader)),
				        create_flags = {},
				        entry_point = daxa.small_string("main") },
				has_value = true
			},
			fragment_shader_info = {
				value = { byte_code = &frag_shader[0],
				        byte_code_size = u32(len(frag_shader)),
				        create_flags = {},
				        entry_point = daxa.small_string("main") },
				has_value = true
			},

			color_attachments = {
				data = { 0 = { format = daxa.swp_get_format(ctx.swapchain) }, 1..<7 = {} }, size = 1 },

			depth_test         = { value = {}, has_value = 0, },
			raster             = daxa.DEFAULT_RASTERIZATION_INFO,
			push_constant_size = daxa.MAX_PUSH_CONSTANT_BYTE_SIZE,
			name = daxa.small_string("my raster pipeline"),
		},
		out_pipeline = &raster_pipeline
	))

	vertex_buffer: daxa.BufferId
	result(daxa.dvc_create_buffer(
		device = ctx.device,
		info = &{
			size = size_of(MyVertex) * 3,
			allocate_info = {.HOST_ACCESS_SEQUENTIAL_WRITE},
			name = daxa.small_string("vertex buffer",)
		},
		out_id = &vertex_buffer,
	))

	vert_buf_ptr: [^]MyVertex
	result(daxa.dvc_buffer_host_address(
		device   = ctx.device,
		buffer   = vertex_buffer,
		out_addr = (^rawptr)(&vert_buf_ptr),
	))

	vert_buf_ptr[0] = { position = {-0.5, +0.5, 0.0}, color = {1.0, 0.0, 0.0}}
	vert_buf_ptr[1] = { position = {+0.5, +0.5, 0.0}, color = {0.0, 1.0, 0.0}}
	vert_buf_ptr[2] = { position = {+0.0, -0.5, 0.0}, color = {0.0, 0.0, 1.0}}

	push_constant: MyPushConstant
	result(daxa.dvc_buffer_device_address(
		device   = ctx.device,
		buffer   = vertex_buffer,
		out_addr = &push_constant.vertices,
	))


	i: int = -1
	for !should_close() {
		i += 1
		log.info("begin frame:", i)
		poll_events()

		if ctx.framebuffer_resized {
			result(daxa.swp_resize(ctx.swapchain))
			ctx.framebuffer_resized = false
		}

		swapchain_image: daxa.ImageId
		acq_result := daxa.swp_acquire_next_image(ctx.swapchain, &swapchain_image)
		// log.info(acq_result) // needs the "is_empty" check?
		assert(acq_result == .SUCCESS)
		assert(daxa.version_of_image(swapchain_image) != 0) //this is an empty check?


		recorder: daxa.CommandRecorder
		result(daxa.dvc_create_command_recorder(
			ctx.device,
			&{ name = daxa.small_string("my command recorder") },
			&recorder,
		))


		swapchain_image_info: daxa.ImageInfo
		result(daxa.dvc_info_image(
			ctx.device,
			swapchain_image,
			&swapchain_image_info
		))


		daxa.cmd_pipeline_image_barrier(
			cmd_enc = recorder,
			info = &{
				dst_access = daxa.ACCESS_COLOR_ATTACHMENT_OUTPUT_READ_WRITE,
				image_id   = swapchain_image,
				layout_operation = .TO_GENERAL,
			},
		)

		result(daxa.cmd_begin_renderpass(
			cmd_enc = recorder,
			info = &{
				color_attachments = {
					{ 0 = {
						image_view = daxa.default_view(swapchain_image),
						load_op    = .CLEAR,
						clear_value = {
							values = { color = { float32 = [4]f32{0.1, 0, 0.5, 1} } },
							index  = 0,
						},
					}, 1..<7 = {} },
					1,
				},
				render_area = { extent = {
					width  = swapchain_image_info.size.width,
					height = swapchain_image_info.size.height,
				}},
			},
		))

		result(daxa.cmd_set_raster_pipeline(
			cmd_enc = recorder,
			pipeline = raster_pipeline,
		))


		result(daxa.cmd_push_constant(
			cmd_enc = recorder,
			info = &{
				data = &push_constant,
				size = size_of(push_constant),
			},
		))

		daxa.cmd_draw(
			cmd_enc = recorder,
			info = &{
				vertex_count   = 3,
				instance_count = 1,
			},
		)

		daxa.cmd_end_renderpass(recorder)


		daxa.cmd_pipeline_image_barrier(
			cmd_enc = recorder,
			info = &{
				src_access = daxa.ACCESS_COLOR_ATTACHMENT_OUTPUT_READ_WRITE,
				image_id   = swapchain_image,
				layout_operation = .TO_PRESENT_SRC,
			}
		)


		executable_commands: daxa.ExecutableCommandList
		result(daxa.cmd_complete_current_commands(recorder, &executable_commands))

		daxa.destroy_command_recorder(recorder)

		acquire_semaphore := daxa.swp_current_acquire_semaphore(ctx.swapchain)
		present_semaphore := daxa.swp_current_present_semaphore(ctx.swapchain)

		current_timeline_pair :: proc() -> daxa.TimelinePair {
			gpu_value := daxa.swp_gpu_timeline_semaphore(ctx.swapchain)^
			cpu_value := daxa.swp_current_cpu_timeline_value(ctx.swapchain)
			return {gpu_value, cpu_value}
		}

		timeline_pair := current_timeline_pair()
		result(daxa.dvc_submit(
			device = ctx.device,
			info = &{
				command_lists = &executable_commands,
				command_list_count = 1,
				wait_binary_semaphores = acquire_semaphore,
				wait_binary_semaphore_count = 1,
				signal_binary_semaphores = present_semaphore,
				signal_binary_semaphore_count = 1,
				signal_timeline_semaphores = &timeline_pair,
				signal_timeline_semaphore_count = 1,
				// wait_stages: vk.PipelineStageFlags,
				// wait_timeline_semaphores: ^TimelinePair, //const *
				// wait_timeline_semaphore_count: u64,
			},
		))

		daxa.executable_commands_dec_refcnt(executable_commands)

		result(daxa.dvc_present(
			device = ctx.device,
			info = &{
				wait_binary_semaphores      = present_semaphore,
				wait_binary_semaphore_count = 1,
				swapchain                   = ctx.swapchain,
				queue                       = {},
			}
		))

		result(daxa.dvc_collect_garbage(ctx.device))

		log.info("end frame:", i)
		// break
	}
}

pink_screen :: proc() {
	i: int = -1
	for !should_close() {
		i += 1
		log.info("begin frame:", i)
		poll_events()


		if ctx.framebuffer_resized {
			result(daxa.swp_resize(ctx.swapchain))
			ctx.framebuffer_resized = false
		}

		swapchain_image: daxa.ImageId
		acq_result := daxa.swp_acquire_next_image(ctx.swapchain, &swapchain_image)
		// log.info(acq_result) // needs the "is_empty" check?
		assert(acq_result == .SUCCESS)
		assert(daxa.version_of_image(swapchain_image) != 0) //this is an empty check?


		swapchain_image_view := daxa.default_view(swapchain_image)
		swapchain_image_info: daxa.ImageViewInfo
		result(daxa.dvc_info_image_view(
			ctx.device,
			swapchain_image_view,
			&swapchain_image_info,
		))



		recorder: daxa.CommandRecorder
		result(daxa.dvc_create_command_recorder(
			ctx.device,
			&{ name = daxa.small_string("my command recorder") },
			&recorder,
		))

		result(daxa.cmd_pipeline_image_barrier(
			cmd_enc = recorder,
			info    = &{
				dst_access       = daxa.ACCESS_TRANSFER_WRITE,
				image_id         = swapchain_image,
				layout_operation = .TO_GENERAL,
			}
		))

		result(daxa.cmd_clear_image(
			cmd_enc = recorder,
			info    = &{
				image_layout = .GENERAL,
				clear_value  = {
					values = { color = { float32 = [4]f32{1.0, 0.0, 1.0, 1.0} }},
					index  = 0,
				},
				image     = swapchain_image,
				dst_slice = swapchain_image_info.slice,
			}
		))

		result(daxa.cmd_pipeline_image_barrier(
			cmd_enc = recorder,
			info = &{
				src_access       = daxa.ACCESS_TRANSFER_WRITE,
				image_id         = swapchain_image,
				layout_operation = .TO_GENERAL,
			}
		))

		executable_commands: daxa.ExecutableCommandList
		result(daxa.cmd_complete_current_commands(recorder, &executable_commands))

		daxa.destroy_command_recorder(recorder)

		acquire_semaphore := daxa.swp_current_acquire_semaphore(ctx.swapchain)
		present_semaphore := daxa.swp_current_present_semaphore(ctx.swapchain)

		current_timeline_pair :: proc() -> daxa.TimelinePair {
			gpu_value := daxa.swp_gpu_timeline_semaphore(ctx.swapchain)^
			cpu_value := daxa.swp_current_cpu_timeline_value(ctx.swapchain)
			return {gpu_value, cpu_value}
		}

		timeline_pair := current_timeline_pair()
		result(daxa.dvc_submit(
			device = ctx.device,
			info = &{
				command_lists = &executable_commands,
				command_list_count = 1,
				wait_binary_semaphores = acquire_semaphore,
				wait_binary_semaphore_count = 1,
				signal_binary_semaphores = present_semaphore,
				signal_binary_semaphore_count = 1,
				signal_timeline_semaphores = &timeline_pair,
				signal_timeline_semaphore_count = 1,
				// wait_stages: vk.PipelineStageFlags,
				// wait_timeline_semaphores: ^TimelinePair, //const *
				// wait_timeline_semaphore_count: u64,
			},
		))

		daxa.executable_commands_dec_refcnt(executable_commands)

		result(daxa.dvc_present(
			device = ctx.device,
			info = &{
				wait_binary_semaphores      = present_semaphore,
				wait_binary_semaphore_count = 1,
				swapchain                   = ctx.swapchain,
				queue                       = {},
			}
		))
		// daxa.binary_semaphore_dec_refcnt(acquire_semaphore^)
		// daxa.binary_semaphore_dec_refcnt(present_semaphore^)

		result(daxa.dvc_collect_garbage(ctx.device))

		log.info("end frame:", i)
	}
}

simplest_test :: proc() {

	recorder: daxa.CommandRecorder
	result(daxa.dvc_create_command_recorder(
		ctx.device,
		&{},
		&recorder,
	))

	// CommandRecorder can create ExecutableCommandList from the currently recorded commands.
	// After calling complete_current_commands, the current commands are cleared.
	// After calling complete_current_commands, you may record more commands and make new ExecutableCommandList with the recorder.
	executable_commands: daxa.ExecutableCommandList
	daxa.cmd_complete_current_commands(recorder, &executable_commands)

	daxa.dvc_submit(
		ctx.device,
		info = &{ command_lists = &executable_commands, },
	)

	/// WARNING:    ALL CommandRecorders from a device MUST be destroyed prior to calling collect_garbage or destroying the device!
	///             This is because The device can only do the internal cleanup when no commands get recorded in parallel!
}

copy_test :: proc() {

	recorder: daxa.CommandRecorder
	result(daxa.dvc_create_command_recorder(
		ctx.device,
		&{name = daxa.small_string("copy command list")},
		&recorder,
	))

	SIZE_X :: 3
	SIZE_Y :: 3
	SIZE_Z :: 3

	get_printable_char_buffer :: proc(in_data: $T/[$SZ][$SY][$SX][4]f32) -> [dynamic]byte {
		data: [dynamic]byte

		pixel_lit          := `\033[48;2;000;000;000m  `
		pixel := transmute([]u8)strings.clone(pixel_lit)
		defer delete(pixel)
		line_terminator    := `\033[0m `
		newline_terminator := `\033[0m\n`

		resize(&data,
			SX * SY * SZ * len(pixel) + 
			SY * SZ * len(line_terminator) + 
			SZ * len(newline_terminator) + 1
		)
		output_index := uint(0)

		for zi in 0..< SZ {
			for yi in 0..< SY {
				for xi in 0..< SX {
					r := cast(u8)(in_data[zi][yi][xi][0] * 255.0)
					g := cast(u8)(in_data[zi][yi][xi][1] * 255.0)
					b := cast(u8)(in_data[zi][yi][xi][2] * 255.0)
					next_pixel := pixel
					next_pixel[7 + 0 * 4 + 0] = (u8('0') + (r / 100))
					next_pixel[7 + 0 * 4 + 1] = (u8('0') + (r % 100) / 10)
					next_pixel[7 + 0 * 4 + 2] = (u8('0') + (r % 10))
					next_pixel[7 + 1 * 4 + 0] = (u8('0') + (g / 100))
					next_pixel[7 + 1 * 4 + 1] = (u8('0') + (g % 100) / 10)
					next_pixel[7 + 1 * 4 + 2] = (u8('0') + (g % 10))
					next_pixel[7 + 2 * 4 + 0] = (u8('0') + (b / 100))
					next_pixel[7 + 2 * 4 + 1] = (u8('0') + (b % 100) / 10)
					next_pixel[7 + 2 * 4 + 2] = (u8('0') + (b % 10))
					copy(data[output_index:], next_pixel)
					output_index += len(pixel)
				}
				copy(data[output_index:], line_terminator)
				output_index += len(line_terminator)
			}
			copy(data[output_index:], newline_terminator)
			output_index += len(newline_terminator)
		}
		data[len(data)-1] = 0 //null terminator
		return data
	}

	ImageArray :: [SIZE_X][SIZE_Y][SIZE_Z][4]f32
	data: ImageArray

	for zi in 0..< SIZE_Z {
		for yi in 0..< SIZE_Y {
			for xi in 0..< SIZE_X {
				data[zi][yi][xi][0] = (f32)(xi) / (f32)(SIZE_X - 1)
				data[zi][yi][xi][1] = (f32)(yi) / (f32)(SIZE_Y - 1)
				data[zi][yi][xi][2] = (f32)(zi) / (f32)(SIZE_Z - 1)
				data[zi][yi][xi][3] = 1.0
			}
		}
	}

	staging_upload_buffer: daxa.BufferId
	result(daxa.dvc_create_buffer(
		ctx.device,
		&{size = size_of(data),
			allocate_info = {.HOST_ACCESS_SEQUENTIAL_WRITE},
			name = daxa.small_string("staging_upload_buffer"),
		},
		&staging_upload_buffer,
	))

	device_local_buffer: daxa.BufferId
	result(daxa.dvc_create_buffer(
		ctx.device,
		&{size = size_of(data),
			name = daxa.small_string("device_local_buffer"),
		},
		&device_local_buffer,
	))

	staging_readback_buffer: daxa.BufferId
	result(daxa.dvc_create_buffer(
		ctx.device,
		&{size = size_of(data),
			allocate_info = {.HOST_ACCESS_RANDOM},
			name = daxa.small_string("staging_readback_buffer"),
		},
		&staging_readback_buffer,
	))

	size_z := SIZE_Z

	image_1: daxa.ImageId
	image_1_info := daxa.DEFAULT_IMAGE_INFO
	image_1_info.dimensions = 2 + (u32)(size_z > 1)
	image_1_info.format = .R32G32B32A32_SFLOAT
	image_1_info.size = {SIZE_X, SIZE_Y, SIZE_Z}
	image_1_info.usage = {.SHADER_STORAGE, .TRANSFER_DST, .TRANSFER_SRC}
	image_1_info.name = daxa.small_string("image_1")

	result(daxa.dvc_create_image(
		ctx.device,
		&image_1_info,
		&image_1,
	))

	image_2: daxa.ImageId
	image_2_info := daxa.DEFAULT_IMAGE_INFO
	image_2_info.dimensions = 2 + (u32)(size_z > 1)
	image_2_info.format = .R32G32B32A32_SFLOAT
	image_2_info.size = {SIZE_X, SIZE_Y, SIZE_Z}
	image_2_info.usage = {.SHADER_STORAGE, .TRANSFER_DST, .TRANSFER_SRC}
	image_2_info.name = daxa.small_string("image_2")

	result(daxa.dvc_create_image(
		ctx.device,
		&image_2_info,
		&image_2,
	))


	timeline_query_pool: daxa.TimelineQueryPool
	result(daxa.dvc_create_timeline_query_pool(
		device = ctx.device,
		info   = &{
			query_count = 2,
			name        = daxa.small_string("timeline_query",)
		},
		out_timeline_query_pool = &timeline_query_pool
	))

	raw_buffer_ptr: rawptr
	result(daxa.dvc_buffer_host_address(
		device   = ctx.device,
		buffer   = staging_upload_buffer,
		out_addr = &raw_buffer_ptr,
	))

	buffer_ptr := (^ImageArray)(raw_buffer_ptr)

	buffer_ptr^ = data

	daxa.cmd_reset_timestamps(
		cmd_enc = recorder,
		info = &{
			query_pool = &timeline_query_pool,
			start_index = 0,
			count = daxa.timeline_query_pool_info(timeline_query_pool).query_count,
		}
	)

	daxa.cmd_write_timestamp(
		cmd_enc = recorder,
		info = &{
			query_pool = &timeline_query_pool,
			pipeline_stage = {.BOTTOM_OF_PIPE},
			query_index = 0,
		}
	)

	daxa.cmd_pipeline_barrier(
		cmd_enc = recorder,
		info = &{
			src_access = daxa.ACCESS_HOST_WRITE,
			dst_access = daxa.ACCESS_TRANSFER_READ,
		},
	)

	daxa.cmd_copy_buffer_to_buffer(
		cmd_enc = recorder,
		info = &{
			src_buffer = staging_upload_buffer,
			dst_buffer = device_local_buffer,
			size = size_of(data),
		}
	)

	// Barrier to make sure device_local_buffer is has no read after write hazard.
	daxa.cmd_pipeline_barrier(
		cmd_enc = recorder,
		info = &{
			src_access = daxa.ACCESS_TRANSFER_WRITE,
			dst_access = daxa.ACCESS_TRANSFER_READ,
		},
	)

	daxa.cmd_pipeline_image_barrier(
		cmd_enc = recorder,
		info = &{
		src_access = daxa.ACCESS_TRANSFER_WRITE,
		dst_access = daxa.ACCESS_TRANSFER_WRITE,
		image_id = image_1,
		layout_operation = .TO_GENERAL,
	})

	// TODO: double check all the infos aren't missing stuff
	daxa.cmd_copy_buffer_to_image(
		cmd_enc = recorder,
		info = &{
			buffer = device_local_buffer,
			image = image_1,
			image_slice = daxa.DEFAULT_IMAGE_ARRAY_SLICE,
			image_layout = .GENERAL,
			image_extent = {SIZE_X, SIZE_Y, SIZE_Z},
		}
	)

	daxa.cmd_pipeline_image_barrier(
		cmd_enc = recorder,
		info = &{
		src_access = daxa.ACCESS_TRANSFER_WRITE,
		dst_access = daxa.ACCESS_TRANSFER_READ,
		image_id = image_1,
		layout_operation = .TO_GENERAL,
	})

	daxa.cmd_pipeline_image_barrier(
		cmd_enc = recorder,
		info = &{
		dst_access = daxa.ACCESS_TRANSFER_WRITE,
		image_id = image_2,
		layout_operation = .TO_GENERAL,
	})

	daxa.cmd_copy_image_to_image(
		cmd_enc = recorder,
		info = &{
			src_image = image_1,
			src_image_layout = .GENERAL,
			src_slice = daxa.DEFAULT_IMAGE_ARRAY_SLICE,
			dst_image = image_2,
			dst_image_layout = .GENERAL,
			dst_slice = daxa.DEFAULT_IMAGE_ARRAY_SLICE,
			extent = {SIZE_X, SIZE_Y, SIZE_Z},
		}
	)

	daxa.cmd_pipeline_image_barrier(
		cmd_enc = recorder,
		info = &{
		src_access = daxa.ACCESS_TRANSFER_WRITE,
		dst_access = daxa.ACCESS_TRANSFER_READ,
		image_id = image_2,
		layout_operation = .TO_GENERAL,
	})

	// Barrier to make sure device_local_buffer is has no write after read hazard.
	daxa.cmd_pipeline_barrier(
		cmd_enc = recorder,
		info = &{
		src_access = daxa.ACCESS_TRANSFER_READ,
		dst_access = daxa.ACCESS_TRANSFER_WRITE,
	})

	daxa.cmd_copy_image_to_buffer(
		cmd_enc = recorder,
		info = &{
		image = image_2,
		image_layout = .GENERAL,
		image_slice = daxa.DEFAULT_IMAGE_ARRAY_SLICE,
		image_extent = {SIZE_X, SIZE_Y, SIZE_Z},
		buffer = device_local_buffer,
	})

	// Barrier to make sure device_local_buffer is has no read after write hazard.
	daxa.cmd_pipeline_barrier(
		cmd_enc = recorder,
		info = &{
		src_access = daxa.ACCESS_TRANSFER_WRITE,
		dst_access = daxa.ACCESS_TRANSFER_READ,
	})

	daxa.cmd_copy_buffer_to_buffer(
		cmd_enc = recorder,
		info = &{
		src_buffer = device_local_buffer,
		dst_buffer = staging_readback_buffer,
		size = size_of(data),
	})

	// Barrier to make sure staging_readback_buffer is has no read after write hazard.
	daxa.cmd_pipeline_barrier(
		cmd_enc = recorder,
		info = &{
		src_access = daxa.ACCESS_TRANSFER_WRITE,
		dst_access = daxa.ACCESS_HOST_READ,
	})

	daxa.cmd_write_timestamp(
		cmd_enc = recorder,
		info = &{
			query_pool = &timeline_query_pool,
			pipeline_stage = {.BOTTOM_OF_PIPE},
			query_index = 1,
		}
	)

	executable_commands: daxa.ExecutableCommandList
	result(daxa.cmd_complete_current_commands(recorder, &executable_commands))

	
	result(daxa.dvc_submit(
		ctx.device,
		&{
			command_lists = &executable_commands,
			command_list_count = 1,
		},
	))

	result(daxa.dvc_wait_idle(ctx.device))


	query_results: [4]u64
	result(daxa.timeline_query_pool_query_results(timeline_query_pool, 0, 2, &query_results[0]))
	
	log.info(query_results)

	if ((query_results[1] != 0) && (query_results[3] != 0)) {
		fmt.printfln("gpu execution took %v ms", f64(query_results[2] - query_results[0]) / 1_000_000)
	}

	readback_data_ptr: rawptr
	result(daxa.dvc_buffer_host_address(
		device   = ctx.device,
		buffer   = staging_upload_buffer,
		out_addr = &readback_data_ptr,
	))

	readback_data := (^ImageArray)(readback_data_ptr)^

	log.info("Original data: ")
	{
		buf := get_printable_char_buffer(data)
		log.info(buf)
	}

	log.info("Readback data: ")
	{
		buf := get_printable_char_buffer(readback_data)
		log.info(buf)
	}

	assert(data == readback_data)

}