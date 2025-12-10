package daxa

import sa "core:container/small_array"

INSTANCE_FLAG_DEBUG_UTIL:                InstanceFlags : 0x1
INSTANCE_FLAG_PARENT_MUST_OUTLIVE_CHILD: InstanceFlags : 0x2

@rodata
DEFAULT_RASTERIZATION_INFO := RasterizerInfo{
	primitive_topology = .TRIANGLE_LIST,
	primitive_restart_enable = false,
	polygon_mode = .FILL,
	face_culling = {},
	front_face_winding = .CLOCKWISE,
	depth_clamp_enable = 0,
	rasterizer_discard_enable = 0,
	depth_bias_enable = 0,
	depth_bias_constant_factor = 0,
	depth_bias_clamp = 0,
	depth_bias_slope_factor = 0,
	line_width = 1,
	conservative_raster_info = {},
	line_raster_info = {},
	static_state_sample_count = {value = {._1}, has_value = 1},
}

@rodata
DEFAULT_BLEND_INFO := BlendInfo{
	src_color_blend_factor = .ONE,
	dst_color_blend_factor = .ZERO,
	color_blend_op = .ADD,
	src_alpha_blend_factor = .ONE,
	dst_alpha_blend_factor = .ZERO,
	alpha_blend_op = .ADD,
	color_write_mask = {.R, .G, .B, .A}
}

@rodata
DEFAULT_IMAGE_INFO := ImageInfo{
	flags             = 0,
	dimensions        = 2,
	format            = .R8G8B8A8_SRGB,
	size              = {0, 0, 0},
	mip_level_count   = 1,
	array_layer_count = 1,
	sample_count      = 1,
	usage             = {},
	sharing_mode      = .EXCLUSIVE,
	allocate_info     = {},
	name              = {},
}

@rodata
DEFAULT_IMAGE_ARRAY_SLICE := ImageArraySlice{
	mip_level        = 0,
	base_array_layer = 0,
	layer_count      = 1,
}


@rodata
DEFAULT_IMAGE_VIEW_INFO := ImageViewInfo{
    type   = .D2,
    format = .R8G8B8A8_SRGB,
    image  = {},
    slice  = {},
    name   = {},
}

@rodata
DEFAULT_INSTANCE_INFO := InstanceInfo{
	flags = INSTANCE_FLAG_DEBUG_UTIL,
	engine_name = {},
	app_name = {},
}

@rodata
DEFAULT_DEVICE_INFO_2 := DeviceInfo2{
	physical_device_index = max(u32),
	explicit_features = .BUFFER_DEVICE_ADDRESS_CAPTURE_REPLAY,
	max_allowed_images = 10000,
	max_allowed_buffers = 10000,
	max_allowed_samplers = 400,
	max_allowed_acceleration_structures = 10000,
	name = {},
}

to_smallstring :: proc(s: string) -> SmallString
{
	ss: u_small_string
	copy(ss.data[:], s)
	ss.size = u8(len(s))
	return transmute(SmallString)ss
}

u_small_string :: struct {
	data: [63]u8,
	size: u8,
}

VmaAllocation_T :: struct{}

QUEUE_MAIN       :: Queue{.MAIN, 0}
QUEUE_COMPUTE_0  :: Queue{.COMPUTE, 0}
QUEUE_COMPUTE_1  :: Queue{.COMPUTE, 1}
QUEUE_COMPUTE_2  :: Queue{.COMPUTE, 2}
QUEUE_COMPUTE_3  :: Queue{.COMPUTE, 3}
QUEUE_TRANSFER_0 :: Queue{.TRANSFER, 0}
QUEUE_TRANSFER_1 :: Queue{.TRANSFER, 1}

MAX_PUSH_CONSTANT_WORD_SIZE :: (32)
MAX_PUSH_CONSTANT_BYTE_SIZE :: (MAX_PUSH_CONSTANT_WORD_SIZE * 4)
PIPELINE_LAYOUT_COUNT       :: (MAX_PUSH_CONSTANT_WORD_SIZE + 1)


ImageUsageFlags :: bit_set[ImageUsageFlag; u32]
ImageUsageFlag :: enum u32 {
	TRANSFER_SRC = 0,
	TRANSFER_DST,
	SHADER_SAMPLED,
	SHADER_STORAGE,
	COLOR_ATTACHMENT,
	DEPTH_STENCIL_ATTACHMENT,
	TRANSIENT_ATTACHMENT,
	FRAGMENT_SHADING_RATE_ATTACHMENT = 8,
	FRAGMENT_DENSITY_MAP             = 9,
	HOST_TRANSFER                    = 22,
}


// MemoryFlags :: u32
MemoryFlags :: bit_set[MemoryFlag; u32]
MemoryFlag :: enum u32 {
	// DEDICATED_MEMORY = 0x00000001, //deprecated
	// CAN_ALIAS = 0x00000200,
	HOST_ACCESS_SEQUENTIAL_WRITE = 10,
	HOST_ACCESS_RANDOM = 11,
	// STRATEGY_MIN_MEMORY = 0x00010000,
	// STRATEGY_MIN_TIME = 0x00020000,
}

// _DAXA_FIXED_LIST_SIZE_T  :: u8
// _DAXA_VARIANT_INDEX_TYPE :: u8

// Variant :: struct($UNION: typeid) {
// 	values: UNION, //raw union
// 	index: _DAXA_VARIANT_INDEX_TYPE,
// }

// Optional :: struct($T: typeid) {
// 	value: T,
// 	has_value: Bool8,
// }

// SpanToConst :: struct($T: typeid) {
// 	data: ^T, //const *
// 	size: uint,
// }

// FixedList :: struct($T: typeid, $N: uint) {
// 	data: [N]T,
// 	size: _DAXA_FIXED_LIST_SIZE_T,
// }

// DAXA_SMALL_STRING_CAPACITY :: 63
// SmallString :: FixedList(byte, DAXA_SMALL_STRING_CAPACITY)