package daxa

size_t   :: uint
uint64_t :: u64
uint32_t :: u32

_DAXA_FIXED_LIST_SIZE_T  :: u8
_DAXA_VARIANT_INDEX_TYPE :: u8

import vk "vendor:vulkan"

//command_recorder.h
//
VkSampleCountFlagBits :: vk.SampleCountFlags
//typedef enum VkSampleCountFlagBits {
//	VK_SAMPLE_COUNT_1_BIT = 0x00000001,
//	VK_SAMPLE_COUNT_2_BIT = 0x00000002,
//	VK_SAMPLE_COUNT_4_BIT = 0x00000004,
//	VK_SAMPLE_COUNT_8_BIT = 0x00000008,
//	VK_SAMPLE_COUNT_16_BIT = 0x00000010,
//	VK_SAMPLE_COUNT_32_BIT = 0x00000020,
//	VK_SAMPLE_COUNT_64_BIT = 0x00000040,
//	VK_SAMPLE_COUNT_FLAG_BITS_MAX_ENUM = 0x7FFFFFFF
//    } VkSampleCountFlagBits;
//    typedef VkFlags VkSampleCountFlags;

VkResolveModeFlagBits :: vk.ResolveModeFlags
//typedef enum VkResolveModeFlagBits {
//	VK_RESOLVE_MODE_NONE = 0,
//	VK_RESOLVE_MODE_SAMPLE_ZERO_BIT = 0x00000001,
//	VK_RESOLVE_MODE_AVERAGE_BIT = 0x00000002,
//	VK_RESOLVE_MODE_MIN_BIT = 0x00000004,
//	VK_RESOLVE_MODE_MAX_BIT = 0x00000008,
//	VK_RESOLVE_MODE_EXTERNAL_FORMAT_DOWNSAMPLE_ANDROID = 0x00000010,
//	VK_RESOLVE_MODE_NONE_KHR = VK_RESOLVE_MODE_NONE,
//	VK_RESOLVE_MODE_SAMPLE_ZERO_BIT_KHR = VK_RESOLVE_MODE_SAMPLE_ZERO_BIT,
//	VK_RESOLVE_MODE_AVERAGE_BIT_KHR = VK_RESOLVE_MODE_AVERAGE_BIT,
//	VK_RESOLVE_MODE_MIN_BIT_KHR = VK_RESOLVE_MODE_MIN_BIT,
//	VK_RESOLVE_MODE_MAX_BIT_KHR = VK_RESOLVE_MODE_MAX_BIT,
//	VK_RESOLVE_MODE_FLAG_BITS_MAX_ENUM = 0x7FFFFFFF
//    } VkResolveModeFlagBits;
//    typedef VkFlags VkResolveModeFlags;
VkSurfaceTransformFlagBitsKHR :: vk.SurfaceTransformFlagsKHR
//typedef enum VkSurfaceTransformFlagBitsKHR {
//	VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR = 0x00000001,
//	VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR = 0x00000002,
//	VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR = 0x00000004,
//	VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR = 0x00000008,
//	VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_BIT_KHR = 0x00000010,
//	VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90_BIT_KHR = 0x00000020,
//	VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180_BIT_KHR = 0x00000040,
//	VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270_BIT_KHR = 0x00000080,
//	VK_SURFACE_TRANSFORM_INHERIT_BIT_KHR = 0x00000100,
//	VK_SURFACE_TRANSFORM_FLAG_BITS_MAX_ENUM_KHR = 0x7FFFFFFF
//    } VkSurfaceTransformFlagBitsKHR;

BufferCopyInfo :: struct {
	src_buffer: BufferId,
	dst_buffer: BufferId,
	src_offset: size_t,
	dst_offset: size_t,
	size: size_t,
}
//DAXA_DEFAULT_BUFFER_COPY_INFO

BufferImageCopyInfo :: struct
{
	buffer: BufferId,
	buffer_offset: size_t,
	image: ImageId,
	image_layout: ImageLayout,
	image_slice: ImageArraySlice,
	image_offset: vk.Offset3D,
	image_extent: vk.Extent3D,
}
//DAXA_DEFAULT_BUFFER_IMAGE_COPY_INFO

ImageBufferCopyInfo :: struct {
	image: ImageId,
	image_layout: ImageLayout,
	image_slice: ImageArraySlice,
	image_offset: vk.Offset3D,
	image_extent: vk.Extent3D,
	buffer: BufferId,
	buffer_offset: size_t,
}
//DAXA_DEFAULT_IMAGE_BUFFER_COPY_INFO

ImageCopyInfo ::  struct {
	src_image: ImageId,
	src_image_layout: ImageLayout,
	dst_image: ImageId,
	dst_image_layout: ImageLayout,
	src_slice: ImageArraySlice,
	src_offset: vk.Offset3D,
	dst_slice: ImageArraySlice,
	dst_offset: vk.Offset3D,
	extent: vk.Extent3D,
}
//DAXA_DEFAULT_IMAGE_COPY_INFO : ImageCopyInfo : {}

ImageBlitInfo ::  struct
{
	src_image: ImageId,
	src_image_layout: ImageLayout,
	dst_image: ImageId,
	dst_image_layout: ImageLayout,
	src_slice: ImageArraySlice,
	src_offsets: [2]vk.Offset3D,
	dst_slice: ImageArraySlice,
	dst_offsets: [2]vk.Offset3D,
	filter: vk.Filter,
}
//DAXA_DEFAULT_IMAGE_BLIT_INFO

ResetEventInfo :: struct {
	barrier: ^Event,
	stage_masks: vk.PipelineStageFlags,
}

PushConstantInfo :: struct {
	data: rawptr, //const * 
	size: uint64_t,
}

DispatchInfo :: struct {
	x: uint32_t,
	y: uint32_t,
	z: uint32_t,
}
//DAXA_DEFAULT_DISPATCH_INFO

DispatchIndirectInfo :: struct {
	indirect_buffer: BufferId,
	offset: size_t,
}
//DAXA_DEFAULT_DISPATCH_INDIRECT_INFO

BuildAccelerationStucturesInfo :: struct {
	tlas_build_infos: ^TlasBuildInfo, //const * 
	tlas_build_info_count: size_t,
	blas_build_infos: ^BlasBuildInfo, //const * 
	blas_build_info_count: size_t,
}

BufferClearInfo :: struct {
	buffer: BufferId,
	offset: size_t,
	size: size_t,
	clear_value: uint32_t,
}

ImageClearInfo ::  struct {
	image_layout: ImageLayout,
	clear_value: Variant(vk.ClearValue), // Make sure this stays abi compatible with daxa::ClearValue
	image: ImageId,
	dst_slice: ImageMipArraySlice
}
//DAXA_DEFAULT_IMAGE_CLEAR_INFO

ImageMemoryBarrierInfo :: struct {
	src_access: Access,
	dst_access: Access,
	src_layout: ImageLayout,
	dst_layout: ImageLayout,
	image_slice: ImageMipArraySlice,
	image_id: ImageId,
}

TraceRaysInfo :: struct {
	width: uint32_t,
	height: uint32_t,
	depth: uint32_t,
	raygen_handle_offset: uint32_t,
	miss_handle_offset: uint32_t,
	hit_handle_offset: uint32_t,
	callable_handle_offset: uint32_t,
	shader_binding_table: RayTracingShaderBindingTable,
}

TraceRaysIndirectInfo :: struct
{
	indirect_device_address: uint64_t,
	raygen_handle_offset: uint32_t,
	miss_handle_offset: uint32_t,
	hit_handle_offset: uint32_t,
	callable_handle_offset: uint32_t,
	shader_binding_table: RayTracingShaderBindingTable,
}
//DAXA_DEFAULT_TRACE_RAYS_INDIRECT_INFO

RenderPassBeginInfo :: struct {
	color_attachments: FixedList(RenderAttachmentInfo, 8),
	depth_attachment: Optional(RenderAttachmentInfo),
	stencil_attachment: Optional(RenderAttachmentInfo),
	render_area: vk.Rect2D,
}
//DAXA_DEFAULT_RENDERPASS_BEGIN_INFO

RenderAttachmentInfo :: struct {
	image_view: ImageViewId,
	layout: ImageLayout,
	load_op: vk.AttachmentLoadOp,
	store_op: vk.AttachmentStoreOp,
	clear_value: Variant(vk.ClearValue),
	resolve: Optional(AttachmentResolveInfo),
}

AttachmentResolveInfo :: struct {
	mode: VkResolveModeFlagBits,
	image: ImageViewId,
	layout: ImageLayout,
}

DepthBiasInfo :: struct {
	constant_factor: f32,
	clamp: f32,
	slope_factor: f32,
}

SetIndexBufferInfo :: struct {
	buffer: BufferId,
	offset: size_t,
	index_type: vk.IndexType,
}

DrawInfo :: struct {
	vertex_count: uint32_t,
	instance_count: uint32_t,
	first_vertex: uint32_t,
	first_instance: uint32_t,
}
//DAXA_DEFAULT_DRAW_INFO

DrawIndexedInfo :: struct
{
	index_count: uint32_t,
	instance_count: uint32_t,
	first_index: uint32_t,
	vertex_offset: i32,
	first_instance: uint32_t,
}
//DAXA_DEFAULT_DRAW_INDEXED_INFO

DrawIndirectInfo :: struct
{
	indirect_buffer: BufferId,
	indirect_buffer_offset: size_t,
	draw_count: uint32_t,
	draw_command_stride: uint32_t,
	is_indexed: Bool8,
}
//DAXA_DEFAULT_DRAW_INDIRECT_INFO

DrawMeshTasksIndirectInfo :: struct
{
	indirect_buffer: BufferId,
	offset: size_t,
	draw_count: uint32_t,
	stride: uint32_t,
}
//DAXA_DEFAULT_DRAW_MESH_TASKS_INDIRECT_INFO

DrawIndirectCountInfo :: struct
{
	indirect_buffer: BufferId,
	indirect_buffer_offset: size_t,
	count_buffer: BufferId,
	count_buffer_offset: size_t,
	max_draw_count: uint32_t,
	draw_command_stride: uint32_t,
	is_indexed: Bool8,
}
//DAXA_DEFAULT_DRAW_INDIRECT_COUNT_INFO

DrawMeshTasksIndirectCountInfo :: struct {
	indirect_buffer: BufferId,
	offset: size_t,
	count_buffer: BufferId,
	count_offset: size_t,
	max_count: uint32_t,
	stride: uint32_t,
}
//DAXA_DRAW_MESH_TASKS_INDIRECT_COUNT_INFO

WriteTimestampInfo :: struct
{
	query_pool: ^TimelineQueryPool,
	pipeline_stage: vk.PipelineStageFlags2,
	query_index: uint32_t,
}

ResetTimestampsInfo :: struct
{
	query_pool: ^TimelineQueryPool,
	start_index: uint32_t,
	count: uint32_t,
}

CommandLabelInfo :: struct
{
	label_color: [4]f32,
	name: SmallString,
}

CommandRecorderInfo :: struct
{
	queue_family: QueueFamily,
	name: SmallString,
}
//DAXA_DEFAULT_COMMAND_RECORDER_INFO

//core.h////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
BufferId :: struct { value: uint64_t }
ImageId  :: struct { value: uint64_t }
TlasId   :: struct { value: uint64_t }
BlasId   :: struct { value: uint64_t }

ImageViewId  :: struct { value: uint64_t }
SamplerId    :: struct { value: uint64_t }

//device.h/////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
Queue :: struct
{
	family: QueueFamily,
	index: u32,
}

CommandSubmitInfo :: struct
{
	queue: Queue,
	wait_stages: vk.PipelineStageFlags,
	command_lists: ^ExecutableCommandList, //const *
	command_list_count: uint64_t,
	wait_binary_semaphores: ^BinarySemaphore, //const *
	wait_binary_semaphore_count: uint64_t,
	signal_binary_semaphores: ^BinarySemaphore, //const *
	signal_binary_semaphore_count: uint64_t,
	wait_timeline_semaphores: ^TimelinePair, //const *
	wait_timeline_semaphore_count: uint64_t,
	signal_timeline_semaphores: ^TimelinePair, //const *
	signal_timeline_semaphore_count: uint64_t,
}

PresentInfo :: struct
{
	wait_binary_semaphores: ^BinarySemaphore, //const * 
	wait_binary_semaphore_count: uint64_t,
	swapchain: Swapchain,
	queue: Queue,
}

DeviceInfo2 :: struct
{
	physical_device_index: u32,              // Index into list of devices returned from instance_list_devices_properties.
	explicit_features: ExplicitFeatureFlags, // Explicit features must be manually enabled.
	max_allowed_images: uint32_t,
	max_allowed_buffers: uint32_t,
	max_allowed_samplers: uint32_t,
	max_allowed_acceleration_structures: uint32_t,
	name: SmallString,
}
//DAXA_DEFAULT_DEVICE_INFO_2

// WARNING: DEPRECATED, use daxa_DeviceInfo2 instead!
DeviceInfo :: struct
{
	selector: proc(properties: DeviceProperties) -> i32, //const *
	flags: DeviceFlags,
	max_allowed_images: uint32_t,
	max_allowed_buffers: uint32_t,
	max_allowed_samplers: uint32_t,
	max_allowed_acceleration_structures: uint32_t,
	name: SmallString,
}

DeviceProperties :: struct
{
	vulkan_api_version: uint32_t,
	driver_version: uint32_t,
	vendor_id: uint32_t,
	device_id: uint32_t,
	device_type: DeviceType,
	device_name: [256]byte,
	pipeline_cache_uuid: [16]byte,
	limits: DeviceLimits,
	mesh_shader_properties: Optional(MeshShaderProperties),
	ray_tracing_pipeline_properties: Optional(RayTracingPipelineProperties),
	acceleration_structure_properties: Optional(AccelerationStructureProperties),
	ray_tracing_invocation_reorder_properties: Optional(RayTracingInvocationReorderProperties),
	compute_queue_count: u32,
	transfer_queue_count: u32,
	implicit_features: ImplicitFeatureFlags,
	explicit_features: ExplicitFeatureFlags,
	missing_required_feature: MissingRequiredVkFeature,
}

DeviceLimits :: struct {
	max_image_dimension1d: uint32_t,
	max_image_dimension2d: uint32_t,
	max_image_dimension3d: uint32_t,
	max_image_dimension_cube: uint32_t,
	max_image_array_layers: uint32_t,
	max_texel_buffer_elements: uint32_t,
	max_uniform_buffer_range: uint32_t,
	max_storage_buffer_range: uint32_t,
	max_push_constants_size: uint32_t,
	max_memory_allocation_count: uint32_t,
	max_sampler_allocation_count: uint32_t,
	buffer_image_granularity: uint64_t,
	sparse_address_space_size: uint64_t,
	max_bound_descriptor_sets: uint32_t,
	max_per_stage_descriptor_samplers: uint32_t,
	max_per_stage_descriptor_uniform_buffers: uint32_t,
	max_per_stage_descriptor_storage_buffers: uint32_t,
	max_per_stage_descriptor_sampled_images: uint32_t,
	max_per_stage_descriptor_storage_images: uint32_t,
	max_per_stage_descriptor_input_attachments: uint32_t,
	max_per_stage_resources: uint32_t,
	max_descriptor_set_samplers: uint32_t,
	max_descriptor_set_uniform_buffers: uint32_t,
	max_descriptor_set_uniform_buffers_dynamic: uint32_t,
	max_descriptor_set_storage_buffers: uint32_t,
	max_descriptor_set_storage_buffers_dynamic: uint32_t,
	max_descriptor_set_sampled_images: uint32_t,
	max_descriptor_set_storage_images: uint32_t,
	max_descriptor_set_input_attachments: uint32_t,
	max_vertex_input_attributes: uint32_t,
	max_vertex_input_bindings: uint32_t,
	max_vertex_input_attribute_offset: uint32_t,
	max_vertex_input_binding_stride: uint32_t,
	max_vertex_output_components: uint32_t,
	max_tessellation_generation_level: uint32_t,
	max_tessellation_patch_size: uint32_t,
	max_tessellation_control_per_vertex_input_components: uint32_t,
	max_tessellation_control_per_vertex_output_components: uint32_t,
	max_tessellation_control_per_patch_output_components: uint32_t,
	max_tessellation_control_total_output_components: uint32_t,
	max_tessellation_evaluation_input_components: uint32_t,
	max_tessellation_evaluation_output_components: uint32_t,
	max_geometry_shader_invocations: uint32_t,
	max_geometry_input_components: uint32_t,
	max_geometry_output_components: uint32_t,
	max_geometry_output_vertices: uint32_t,
	max_geometry_total_output_components: uint32_t,
	max_fragment_input_components: uint32_t,
	max_fragment_output_attachments: uint32_t,
	max_fragment_dual_src_attachments: uint32_t,
	max_fragment_combined_output_resources: uint32_t,
	max_compute_shared_memory_size: uint32_t,
	max_compute_work_group_count: [3]uint32_t,
	max_compute_work_group_invocations: uint32_t,
	max_compute_work_group_size: [3]uint32_t,
	sub_pixel_precision_bits: uint32_t,
	sub_texel_precision_bits: uint32_t,
	mipmap_precision_bits: uint32_t,
	max_draw_indexed_index_value: uint32_t,
	max_draw_indirect_count: uint32_t,
	max_sampler_lod_bias: f32,
	max_sampler_anisotropy: f32,
	max_viewports: uint32_t,
	max_viewport_dimensions: [2]uint32_t,
	viewport_bounds_range: [2]f32,
	viewport_sub_pixel_bits: uint32_t,
	min_memory_map_alignment: size_t,
	min_texel_buffer_offset_alignment: uint64_t,
	min_uniform_buffer_offset_alignment: uint64_t,
	min_storage_buffer_offset_alignment: uint64_t,
	min_texel_offset: i32,
	max_texel_offset: uint32_t,
	min_texel_gather_offset: i32,
	max_texel_gather_offset: uint32_t,
	min_interpolation_offset: f32,
	max_interpolation_offset: f32,
	sub_pixel_interpolation_offset_bits: uint32_t,
	max_framebuffer_width: uint32_t,
	max_framebuffer_height: uint32_t,
	max_framebuffer_layers: uint32_t,
	framebuffer_color_sample_counts: uint32_t,
	framebuffer_depth_sample_counts: uint32_t,
	framebuffer_stencil_sample_counts: uint32_t,
	framebuffer_no_attachments_sample_counts: uint32_t,
	max_color_attachments: uint32_t,
	sampled_image_color_sample_counts: uint32_t,
	sampled_image_integer_sample_counts: uint32_t,
	sampled_image_depth_sample_counts: uint32_t,
	sampled_image_stencil_sample_counts: uint32_t,
	storage_image_sample_counts: uint32_t,
	max_sample_mask_words: uint32_t,
	timestamp_compute_and_graphics: uint32_t,
	timestamp_period: f32,
	max_clip_distances: uint32_t,
	max_cull_distances: uint32_t,
	max_combined_clip_and_cull_distances: uint32_t,
	discrete_queue_priorities: uint32_t,
	point_size_range: [2]f32,
	line_width_range: [2]f32,
	point_size_granularity: f32,
	line_width_granularity: f32,
	strict_lines: uint32_t,
	standard_sample_locations: uint32_t,
	optimal_buffer_copy_offset_alignment: uint64_t,
	optimal_buffer_copy_row_pitch_alignment: uint64_t,
	non_coherent_atom_size: uint64_t,
}

// Is NOT ABI Compatible with VkPhysicalDeviceMeshShaderPropertiesEXT!
MeshShaderProperties :: struct {
	max_task_work_group_total_count: uint32_t,
	max_task_work_group_count: [3]uint32_t,
	max_task_work_group_invocations: uint32_t,
	max_task_work_group_size: [3]uint32_t,
	max_task_payload_size: uint32_t,
	max_task_shared_memory_size: uint32_t,
	max_task_payload_and_shared_memory_size: uint32_t,
	max_mesh_work_group_total_count: uint32_t,
	max_mesh_work_group_count: [3]uint32_t,
	max_mesh_work_group_invocations: uint32_t,
	max_mesh_work_group_size: [3]uint32_t,
	max_mesh_shared_memory_size: uint32_t,
	max_mesh_payload_and_shared_memory_size: uint32_t,
	max_mesh_output_memory_size: uint32_t,
	max_mesh_payload_and_output_memory_size: uint32_t,
	max_mesh_output_components: uint32_t,
	max_mesh_output_vertices: uint32_t,
	max_mesh_output_primitives: uint32_t,
	max_mesh_output_layers: uint32_t,
	max_mesh_multiview_view_count: uint32_t,
	mesh_output_per_vertex_granularity: uint32_t,
	mesh_output_per_primitive_granularity: uint32_t,
	max_preferred_task_work_group_invocations: uint32_t,
	max_preferred_mesh_work_group_invocations: uint32_t,
	prefers_local_invocation_vertex_output: Bool8,
	prefers_local_invocation_primitive_output: Bool8,
	prefers_compact_vertex_output: Bool8,
	prefers_compact_primitive_output: Bool8,
}

RayTracingPipelineProperties :: struct {
	shader_group_handle_size: uint32_t,
	max_ray_recursion_depth: uint32_t,
	max_shader_group_stride: uint32_t,
	shader_group_base_alignment: uint32_t,
	shader_group_handle_capture_replay_size: uint32_t,
	max_ray_dispatch_invocation_count: uint32_t,
	shader_group_handle_alignment: uint32_t,
	max_ray_hit_attribute_size: uint32_t,
}

AccelerationStructureProperties :: struct
{
	max_geometry_count: uint64_t,
	max_instance_count: uint64_t,
	max_primitive_count: uint64_t,
	max_per_stage_descriptor_acceleration_structures: uint32_t,
	max_per_stage_descriptor_update_after_bind_acceleration_structures: uint32_t,
	max_descriptor_set_acceleration_structures: uint32_t,
	max_descriptor_set_update_after_bind_acceleration_structures: uint32_t,
	min_acceleration_structure_scratch_offset_alignment: uint32_t,
}

RayTracingInvocationReorderProperties :: struct
{
	invocation_reorder_mode: uint32_t,
}

AccelerationStructureBuildSizesInfo :: struct
{
	acceleration_structure_size: uint64_t,
	update_scratch_size: uint64_t,
	build_scratch_size: uint64_t,
}

MemoryBlockBufferInfo :: struct
{
	buffer_info: BufferInfo,
	memory_block: ^MemoryBlock,
	offset: size_t,
}

MemoryBlockImageInfo :: struct
{
	image_info: ImageInfo,
	memory_block: ^MemoryBlock,
	offset: size_t,
}

BufferTlasInfo :: struct
{
	tlas_info: TlasInfo,
	buffer_id: BufferId,
	offset: uint64_t,
}

BufferBlasInfo :: struct
{
	blas_info: BlasInfo,
	buffer_id: BufferId,
	offset: uint64_t,
}

//gpu_resources.h////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
DeviceAddress :: struct { value: uint64_t }

ImageViewInfo :: struct
{
	type: vk.ImageViewType,
	format: vk.Format,
	image: ImageId,
	slice: ImageMipArraySlice,
	name: SmallString,
}

SamplerInfo :: struct
{
	magnification_filter: vk.Filter,
	minification_filter: vk.Filter,
	mipmap_filter: vk.Filter,
	reduction_mode: vk.SamplerReductionMode,
	address_mode_u: vk.SamplerAddressMode,
	address_mode_v: vk.SamplerAddressMode,
	address_mode_w: vk.SamplerAddressMode,
	mip_lod_bias: f32,
	enable_anisotropy: Bool8,
	max_anisotropy: f32,
	enable_compare: Bool8,
	compare_op: vk.CompareOp,
	min_lod: f32,
	max_lod: f32,
	border_color: vk.BorderColor,
	enable_unnormalized_coordinates: Bool8,
	name: SmallString,
}

BufferInfo :: struct
{
	size: size_t,
	allocate_info: MemoryFlags,     // Ignored when allocating with a memory block.
	name: SmallString,
}

ImageInfo :: struct
{
	flags: ImageFlags,
	dimensions: uint32_t,
    	format: vk.Format,
    	size: vk.Extent3D,
	mip_level_count: uint32_t,
	array_layer_count: uint32_t,
	sample_count: uint32_t,
	usage: ImageUsageFlags,
	sharing_mode: SharingMode,
	// Ignored when allocating with a memory block.
	allocate_info: MemoryFlags,
	name: SmallString,
}

TlasBuildInfo :: struct {
	flags: BuildAcclelerationStructureFlags,
	update: Bool8,
	src_tlas: TlasId,
	dst_tlas: TlasId,
	instances: ^TlasInstanceInfo, //const * 
	instance_count: uint32_t,
	scratch_data: DeviceAddress,
}
//DAXA_DEFAULT_TLAS_BUILD_INFO

/// Instances are defines as VkAccelerationStructureInstanceKHR;
TlasInstanceInfo :: struct {
	data: DeviceAddress,
	count: uint32_t,
	is_data_array_of_pointers: Bool8,
	flags: GeometryFlags,
}
//DAXA_DEFAULT_TLAS_INSTANCE_INFO

TlasInfo :: struct
{
	size: uint64_t,
	name: SmallString,
}
//DAXA_DEFAULT_TLAS_INFO
BlasInfo :: struct
{
	size: uint64_t,
	name: SmallString,
}

BlasBuildInfo :: struct {
	flags: BuildAcclelerationStructureFlags,
	update: Bool8,
	src_blas: BlasId,
	dst_blas: BlasId,
	geometries: Variant(BlasGeometryInfoSpansUnion),
	scratch_data: DeviceAddress,
}
//DAXA_DEFAULT_BLAS_BUILD_INFO

BlasGeometryInfoSpansUnion :: struct #raw_union {
	triangles: BlasTriangleGeometryInfoSpan,
	aabbs:     BlasAabbsGeometryInfoSpan,
}

BlasTriangleGeometryInfoSpan :: struct {
	triangles: ^BlasTriangleGeometryInfo, //const * 
	count: size_t,
}

BlasTriangleGeometryInfo :: struct {
	vertex_format: vk.Format,
	vertex_data: DeviceAddress,
	vertex_stride: uint64_t,
	max_vertex: uint32_t,
	index_type: vk.IndexType,
	index_data: DeviceAddress,
	transform_data: DeviceAddress,
	count: uint32_t,
	flags: GeometryFlags,
}

BlasAabbsGeometryInfoSpan :: struct {
	aabbs: ^BlasAabbGeometryInfo, //const * 
	count: size_t,
}

BlasAabbGeometryInfo :: struct {
	data: DeviceAddress,
	stride: uint64_t,
	count: uint32_t,
	flags: GeometryFlags,
}

//instance.h/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

InstanceInfo :: struct
{
	flags: InstanceFlags,
	engine_name: SmallString,
	app_name: SmallString,
}

// pipeline.h////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

BlendInfo :: struct
{
	src_color_blend_factor: vk.BlendFactor,
	dst_color_blend_factor: vk.BlendFactor,
	color_blend_op: vk.BlendOp,
	src_alpha_blend_factor: vk.BlendFactor,
	dst_alpha_blend_factor: vk.BlendFactor,
	alpha_blend_op: vk.BlendOp,
	color_write_mask: vk.ColorComponentFlags,
}

ShaderInfo :: struct
{
	byte_code: ^uint32_t, //const * 
	byte_code_size: uint32_t,
	create_flags: vk.PipelineShaderStageCreateFlags,
	required_subgroup_size: Optional(uint32_t),
	entry_point: SmallString,
}

RenderAttachment :: struct
{
    format: vk.Format,
    blend: Optional(BlendInfo),
}

DepthTestInfo :: struct
{
	depth_attachment_format: vk.Format,
	enable_depth_write: Bool8,
	depth_test_compare_op: vk.CompareOp,
	min_depth_bounds: f32,
	max_depth_bounds: f32,
}

TesselationInfo :: struct
{
	control_points: uint32_t,
	origin: vk.TessellationDomainOrigin,
}

ConservativeRasterInfo :: struct
{
	mode: vk.ConservativeRasterizationModeEXT,
	size: f32,
}

RasterizerInfo :: struct
{
    primitive_topology: vk.PrimitiveTopology,
    primitive_restart_enable: Bool8,
    polygon_mode: vk.PolygonMode,
    face_culling: vk.CullModeFlags,
    front_face_winding: vk.FrontFace,
    depth_clamp_enable: Bool8,
    rasterizer_discard_enable: Bool8,
    depth_bias_enable: Bool8,
    depth_bias_constant_factor: f32,
    depth_bias_clamp: f32,
    depth_bias_slope_factor: f32,
    line_width: f32,
    conservative_raster_info: Optional(ConservativeRasterInfo),
    static_state_sample_count: Optional(VkSampleCountFlagBits),
}

RasterPipelineInfo :: struct
{
	mesh_shader_info: Optional(ShaderInfo),
	vertex_shader_info: Optional(ShaderInfo),
	tesselation_control_shader_info: Optional(ShaderInfo),
	tesselation_evaluation_shader_info: Optional(ShaderInfo),
	fragment_shader_info: Optional(ShaderInfo),
	task_shader_info: Optional(ShaderInfo),
	color_attachments: FixedList(RenderAttachment, 8),
	depth_test: Optional(DepthTestInfo),
	tesselation: Optional(TesselationInfo),
	raster: RasterizerInfo,
	push_constant_size: uint32_t,
	name: SmallString,
}
//DAXA_DEFAULT_RASTERIZER_PIPELINE_INFO

ComputePipelineInfo :: struct
{
	shader_info: ShaderInfo,
	push_constant_size: uint32_t,
	name: SmallString,
}
//DAXA_DEFAULT_COMPUTE_PIPELINE_INFO

// RAY TRACING PIPELINE
RayTracingShaderInfo :: struct
{
	info: ShaderInfo,
}

RayTracingShaderGroupInfo :: struct
{
	type: vk.RayTracingShaderGroupTypeKHR,
	general_shader_index: uint32_t,
	closest_hit_shader_index: uint32_t,
	any_hit_shader_index: uint32_t,
	intersection_shader_index: uint32_t,
}

RayTracingPipelineInfo :: struct
{
	ray_gen_stages: SpanToConst(RayTracingShaderInfo),
	miss_stages: SpanToConst(RayTracingShaderInfo),
	callable_stages: SpanToConst(RayTracingShaderInfo),
	intersection_stages: SpanToConst(RayTracingShaderInfo),
	closest_hit_stages: SpanToConst(RayTracingShaderInfo),
	any_hit_stages: SpanToConst(RayTracingShaderInfo),
	shader_groups: SpanToConst(RayTracingShaderGroupInfo),
	max_ray_recursion_depth: uint32_t,
	push_constant_size: uint32_t,
	name: SmallString,
}
//DAXA_DEFAULT_RAY_TRACING_PIPELINE_INFO

//swapchain.h////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

SwapchainInfo :: struct
{
	native_window: NativeWindowHandle,
	native_window_platform: NativeWindowPlatform,
	surface_format_selector: proc(format: vk.Format) -> i32,
	present_mode: vk.PresentModeKHR,
	present_operation: VkSurfaceTransformFlagBitsKHR,
	image_usage: ImageUsageFlags,
	max_allowed_frames_in_flight: size_t,
	queue_family: QueueFamily,
	name: SmallString,
}

// sync.h

MemoryBarrierInfo :: struct {
	src_access: Access,
	dst_access: Access,
}

Access :: struct {
	stages: vk.PipelineStageFlags2,
	access_type: vk.AccessFlags2,
}

EventSignalInfo :: struct {
	memory_barriers: ^MemoryBarrierInfo, //const * 
	memory_barrier_count: uint64_t,
	image_memory_barriers: ^ImageMemoryBarrierInfo, //const * 
	image_memory_barrier_count: uint64_t,
	event: ^Event,
}

BinarySemaphoreInfo :: struct
{
	name: SmallString,
}

TimelineSemaphoreInfo :: struct
{
	initial_value: uint64_t,
	name: SmallString,
}

EventInfo :: struct
{
	name: SmallString,
}

TimelinePair :: struct
{
	semaphore: TimelineSemaphore,
	value: uint64_t,
}

// types.h
Variant :: struct($UNION: typeid) {
	values: UNION, //raw union
	index: _DAXA_VARIANT_INDEX_TYPE,
}

Optional :: struct($T: typeid) {
	value: T,
	has_value: Bool8,
}

SpanToConst :: struct($T: typeid) {
	data: ^T, //const *
	size: size_t,
}

FixedList :: struct($T: typeid, $N: uint) {
	data: [N]T,
	size: _DAXA_FIXED_LIST_SIZE_T,
}

DAXA_SMALL_STRING_CAPACITY :: 63
SmallString :: FixedList(byte, DAXA_SMALL_STRING_CAPACITY)

ImageArraySlice :: struct
{
	mip_level: uint32_t,
	base_array_layer: uint32_t,
	layer_count: uint32_t,
}

ImageMipArraySlice :: struct
{
	base_mip_level: uint32_t,
	level_count: uint32_t,
	base_array_layer: uint32_t,
	layer_count: uint32_t,
}

RayTracingShaderBindingTable :: struct {
	raygen_region: vk.StridedDeviceAddressRegionKHR,
	miss_region: vk.StridedDeviceAddressRegionKHR,
	hit_region: vk.StridedDeviceAddressRegionKHR,
	callable_region: vk.StridedDeviceAddressRegionKHR,
}

MemoryBlockInfo :: struct
{
	requirements: vk.MemoryRequirements,
	flags: MemoryFlags,
}

TimelineQueryPoolInfo :: struct
{
	query_count: uint32_t,
	name: SmallString,
}
