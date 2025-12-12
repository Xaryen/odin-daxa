package daxa

// TODO: decide on handling DAXA_RESULT
// could be returned as multiple values to the api user or handled internally?
// C++ api seems to be handling it on it's own?
// nvm it seems to be using exceptions for that

// static daxa_ImageBlitInfo const DAXA_DEFAULT_IMAGE_BLIT_INFO = {
//     .src_image = DAXA_ZERO_INIT,
//     .src_image_layout = DAXA_IMAGE_LAYOUT_GENERAL,
//     .dst_image = DAXA_ZERO_INIT,
//     .dst_image_layout = DAXA_IMAGE_LAYOUT_GENERAL,
//     .src_slice = DAXA_ZERO_INIT,
//     .src_offsets = DAXA_ZERO_INIT,
//     .dst_slice = DAXA_ZERO_INIT,
//     .dst_offsets = DAXA_ZERO_INIT,
//     .filter = VK_FILTER_NEAREST,
// };

// static daxa_BufferImageCopyInfo const DAXA_DEFAULT_BUFFER_IMAGE_COPY_INFO = {
//     .buffer = DAXA_ZERO_INIT,
//     .buffer_offset = 0,
//     .image = DAXA_ZERO_INIT,
//     .image_layout = DAXA_IMAGE_LAYOUT_GENERAL,
//     .image_slice = DAXA_ZERO_INIT,
//     .image_offset = DAXA_ZERO_INIT,
//     .image_extent = DAXA_ZERO_INIT,
// };

// static daxa_ImageBufferCopyInfo const DAXA_DEFAULT_IMAGE_BUFFER_COPY_INFO = {
//     .image = DAXA_ZERO_INIT,
//     .image_layout = DAXA_IMAGE_LAYOUT_GENERAL,
//     .image_slice = DAXA_ZERO_INIT,
//     .image_offset = DAXA_ZERO_INIT,
//     .image_extent = DAXA_ZERO_INIT,
//     .buffer = DAXA_ZERO_INIT,
//     .buffer_offset = 0,
// };

// static daxa_ImageCopyInfo const DAXA_DEFAULT_IMAGE_COPY_INFO = {
//     .src_image = DAXA_ZERO_INIT,
//     .src_image_layout = DAXA_IMAGE_LAYOUT_GENERAL,
//     .dst_image = DAXA_ZERO_INIT,
//     .dst_image_layout = DAXA_IMAGE_LAYOUT_GENERAL,
//     .src_slice = DAXA_ZERO_INIT,
//     .src_offset = DAXA_ZERO_INIT,
//     .dst_slice = DAXA_ZERO_INIT,
//     .dst_offset = DAXA_ZERO_INIT,
//     .extent = DAXA_ZERO_INIT,
// };

// static daxa_ImageClearInfo const DAXA_DEFAULT_IMAGE_CLEAR_INFO = {
//     .image_layout = DAXA_IMAGE_LAYOUT_GENERAL,
//     .clear_value = DAXA_ZERO_INIT,
//     .image = DAXA_ZERO_INIT,
//     .dst_slice = DAXA_ZERO_INIT,
// };

// static daxa_AttachmentResolveInfo const DAXA_DEFAULT_RENDER_ATTACHMENT_RESOLVE_INFO = {
//     .mode = VK_RESOLVE_MODE_AVERAGE_BIT,
//     .image = {},
//     .layout = DAXA_IMAGE_LAYOUT_GENERAL,
// };

// static daxa_RenderAttachmentInfo const DAXA_DEFAULT_RENDER_ATTACHMENT_INFO = {
//     .image_view = DAXA_ZERO_INIT,
//     .layout = DAXA_IMAGE_LAYOUT_GENERAL,
//     .load_op = VK_ATTACHMENT_LOAD_OP_DONT_CARE,
//     .store_op = VK_ATTACHMENT_STORE_OP_STORE,
//     .clear_value = DAXA_ZERO_INIT,
//     .resolve = {.value = DAXA_ZERO_INIT, .has_value = 0},
// };

// static daxa_DrawMeshTasksIndirectInfo const DAXA_DEFAULT_DRAW_MESH_TASKS_INDIRECT_INFO = {
//     .indirect_buffer = DAXA_ZERO_INIT,
//     .offset = 0,
//     .draw_count = 1,
//     .stride = 12,
// };

// static daxa_DrawInfo const DAXA_DEFAULT_DRAW_INFO = {
//     .vertex_count = 0,
//     .instance_count = 1,
//     .first_vertex = 0,
//     .first_instance = 0,
// };
// static daxa_DrawIndexedInfo const DAXA_DEFAULT_DRAW_INDEXED_INFO = {
//     .index_count = 0,
//     .instance_count = 1,
//     .first_index = 0,
//     .vertex_offset = 0,
//     .first_instance = 0,
// };
// static daxa_DrawIndirectCountInfo const DAXA_DEFAULT_DRAW_INDIRECT_COUNT_INFO = {
//     .indirect_buffer = DAXA_ZERO_INIT,
//     .indirect_buffer_offset = 0,
//     .count_buffer = DAXA_ZERO_INIT,
//     .count_buffer_offset = 0,
//     .max_draw_count = ((1 << 16) - 1),
//     .draw_command_stride = 0,
//     .is_indexed = 0,
// };
// static daxa_SetIndexBufferInfo const DAXA_DEFAULT_SET_INDEX_BUFFER_INFO = {
//     .buffer = DAXA_ZERO_INIT,
//     .offset = 0,
//     .index_type = VK_INDEX_TYPE_UINT32,
// };


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

DEFAULT_BUFFER_INFO :: BufferInfo{
	size = 0,
	allocate_info = MEMORY_FLAG_NONE,
	name = {},
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

DEFAULT_SAMPLER_INFO :: SamplerInfo{
	magnification_filter =            .LINEAR,
	minification_filter =             .LINEAR,
	mipmap_filter =                   .LINEAR,
	reduction_mode =                  .WEIGHTED_AVERAGE,
	address_mode_u =                  .CLAMP_TO_EDGE,
	address_mode_v =                  .CLAMP_TO_EDGE,
	address_mode_w =                  .CLAMP_TO_EDGE,
	mip_lod_bias =                    0.5,
	enable_anisotropy =               false,
	max_anisotropy =                  0,
	enable_compare =                  false,
	compare_op =                      .ALWAYS,
	min_lod =                         0,
	max_lod =                         1000,
	border_color =                    .INT_TRANSPARENT_BLACK,
	enable_unnormalized_coordinates = false,
	name =                            {},
}

DEFAULT_BLAS_TRIANGLE_GEOMETRY_INFO :: BlasTriangleGeometryInfo{
	vertex_format = .R32G32B32_SFLOAT,
	vertex_data = {},
	vertex_stride = 24,
	max_vertex = 0,
	index_type = .UINT32,
	index_data = {},
	transform_data = {},
	count = 0,
	flags = {.OPAQUE},
}

DEFAULT_BLAS_AABB_GEOMETRY_INFO :: BlasAabbGeometryInfo{
	data = {},
	stride = 24,
	count = 0,
	flags = {.OPAQUE},
}

DEFAULT_TLAS_INSTANCE_INFO :: TlasInstanceInfo{
	data = {},
	count = 0,
	is_data_array_of_pointers = 0,
	flags = {.OPAQUE},
}

DEFAULT_TLAS_BUILD_INFO :: TlasBuildInfo{
	flags = {.PREFER_FAST_TRACE},
	update = 0,
	src_tlas = {},
	dst_tlas = {},
	instances = {},
	instance_count = {},
	scratch_data = {},
}

DEFAULT_BLAS_BUILD_INFO :: BlasBuildInfo{
	flags = {.PREFER_FAST_TRACE},
	update = 0,
	src_blas = {},
	dst_blas = {},
	geometries = {},
	scratch_data = {},
}

DEFAULT_TLAS_INFO :: TlasInfo{
	size = {},
	name = {},
}

DEFAULT_BLAS_INFO :: BlasInfo{
	size = {},
	name = {},
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