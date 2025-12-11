package daxa

DEFAULT_RASTERIZATION_INFO :: RasterizerInfo{
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

DEFAULT_BLEND_INFO :: BlendInfo{
	src_color_blend_factor = .ONE,
	dst_color_blend_factor = .ZERO,
	color_blend_op = .ADD,
	src_alpha_blend_factor = .ONE,
	dst_alpha_blend_factor = .ZERO,
	alpha_blend_op = .ADD,
	color_write_mask = {.R, .G, .B, .A}
}

DEFAULT_IMAGE_INFO :: ImageInfo{
	flags             = IMAGE_FLAG_NONE,
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

DEFAULT_IMAGE_ARRAY_SLICE :: ImageArraySlice{
	mip_level        = 0,
	base_array_layer = 0,
	layer_count      = 1,
}

DEFAULT_IMAGE_VIEW_INFO :: ImageViewInfo{
    type   = .D2,
    format = .R8G8B8A8_SRGB,
    image  = {},
    slice  = {},
    name   = {},
}

DEFAULT_INSTANCE_INFO :: InstanceInfo{
	flags = INSTANCE_FLAG_DEBUG_UTIL,
	engine_name = {},
	app_name = {},
}

DEFAULT_DEVICE_INFO_2 :: DeviceInfo2{
	physical_device_index = max(u32),
	explicit_features = {.BUFFER_DEVICE_ADDRESS_CAPTURE_REPLAY},
	max_allowed_images = 10000,
	max_allowed_buffers = 10000,
	max_allowed_samplers = 400,
	max_allowed_acceleration_structures = 10000,
	name = {},
}

small_string :: proc(s: string) -> SmallString {
	ss: SmallString
	copy(ss.data[:], s)
	ss.size = u8(len(s))
	return ss
}

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