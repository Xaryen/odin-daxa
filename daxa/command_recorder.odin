package daxa

import "core:c"

import vk "vendor:vulkan"

_ :: c

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	cmd_set_rasterization_samples     :: proc(cmd_enc: CommandRecorder, samples: VkSampleCountFlagBits) -> Result ---
	cmd_copy_buffer_to_buffer         :: proc(cmd_enc: CommandRecorder, info: ^BufferCopyInfo) -> Result ---
	cmd_copy_buffer_to_image          :: proc(cmd_enc: CommandRecorder, info: ^BufferImageCopyInfo) -> Result ---
	cmd_copy_image_to_buffer          :: proc(cmd_enc: CommandRecorder, info: ^ImageBufferCopyInfo) -> Result ---
	cmd_copy_image_to_image           :: proc(cmd_enc: CommandRecorder, info: ^ImageCopyInfo) -> Result ---
	cmd_blit_image_to_image           :: proc(cmd_enc: CommandRecorder, info: ^ImageBlitInfo) -> Result ---
	cmd_build_acceleration_structures :: proc(cmd_rec: CommandRecorder, info: ^BuildAccelerationStucturesInfo) -> Result ---
	cmd_clear_buffer                  :: proc(cmd_enc: CommandRecorder, info: ^BufferClearInfo) -> Result ---
	cmd_clear_image                   :: proc(cmd_enc: CommandRecorder, info: ^ImageClearInfo) -> Result ---

	/// @brief  Successive pipeline barrier calls are combined.
	///         As soon as a non-pipeline barrier command is recorded, the currently recorded barriers are flushed with a vkCmdPipelineBarrier2 call.
	/// @param info parameters.
	cmd_pipeline_barrier :: proc(cmd_enc: CommandRecorder, info: ^MemoryBarrierInfo) ---

	/// @brief  Successive pipeline barrier calls are combined.
	///         As soon as a non-pipeline barrier command is recorded, the currently recorded barriers are flushed with a vkCmdPipelineBarrier2 call.
	/// @param info parameters.
	cmd_pipeline_barrier_image_transition :: proc(cmd_enc: CommandRecorder, info: ^ImageMemoryBarrierInfo) -> Result ---
	cmd_signal_event                      :: proc(cmd_enc: CommandRecorder, info: ^EventSignalInfo) ---
	cmd_wait_events                       :: proc(cmd_enc: CommandRecorder, infos: ^EventWaitInfo, info_count: uint) ---
	cmd_wait_event                        :: proc(cmd_enc: CommandRecorder, info: ^EventWaitInfo) ---
	cmd_reset_event                       :: proc(cmd_enc: CommandRecorder, info: ^ResetEventInfo) ---
	cmd_push_constant                     :: proc(cmd_enc: CommandRecorder, info: ^PushConstantInfo) -> Result ---
	cmd_set_ray_tracing_pipeline          :: proc(cmd_enc: CommandRecorder, pipeline: RayTracingPipeline) -> Result ---
	cmd_set_compute_pipeline              :: proc(cmd_enc: CommandRecorder, pipeline: ComputePipeline) -> Result ---
	cmd_set_raster_pipeline               :: proc(cmd_enc: CommandRecorder, pipeline: RasterPipeline) -> Result ---
	cmd_dispatch                          :: proc(cmd_enc: CommandRecorder, info: ^DispatchInfo) -> Result ---
	cmd_dispatch_indirect                 :: proc(cmd_enc: CommandRecorder, info: ^DispatchIndirectInfo) -> Result ---

	/// @brief  Destroys the buffer AFTER the gpu is finished executing the command list.
	///         Useful for large uploads exceeding staging memory pools.
	/// @param id buffer to be destroyed after command list finishes.
	cmd_destroy_buffer_deferred :: proc(cmd_enc: CommandRecorder, id: BufferId) -> Result ---

	/// @brief  Destroys the image AFTER the gpu is finished executing the command list.
	///         Useful for large uploads exceeding staging memory pools.
	/// @param id image to be destroyed after command list finishes.
	cmd_destroy_image_deferred :: proc(cmd_enc: CommandRecorder, id: ImageId) -> Result ---

	/// @brief  Destroys the image view AFTER the gpu is finished executing the command list.
	///         Useful for large uploads exceeding staging memory pools.
	/// @param id image view to be destroyed after command list finishes.
	cmd_destroy_image_view_deferred :: proc(cmd_enc: CommandRecorder, id: ImageViewId) -> Result ---

	/// @brief  Destroys the sampler AFTER the gpu is finished executing the command list.
	///         Useful for large uploads exceeding staging memory pools.
	/// @param id image sampler be destroyed after command list finishes.
	cmd_destroy_sampler_deferred :: proc(cmd_enc: CommandRecorder, id: SamplerId) -> Result ---
	cmd_trace_rays               :: proc(cmd_enc: CommandRecorder, info: ^TraceRaysInfo) -> Result ---
	cmd_trace_rays_indirect      :: proc(cmd_enc: CommandRecorder, info: ^TraceRaysIndirectInfo) -> Result ---

	/// @brief  Starts a renderpass scope akin to the dynamic rendering feature in vulkan.
	///         Between the begin and end renderpass commands, the renderpass persists and draw-calls can be recorded.
	/// @param info parameters.
	cmd_begin_renderpass :: proc(cmd_enc: CommandRecorder, info: ^RenderPassBeginInfo) -> Result ---

	/// @brief  Ends a renderpass scope akin to the dynamic rendering feature in vulkan.
	///         Between the begin and end renderpass commands, the renderpass persists and draw-calls can be recorded.
	cmd_end_renderpass                 :: proc(cmd_enc: CommandRecorder) ---
	cmd_set_viewport                   :: proc(cmd_enc: CommandRecorder, info: ^vk.Viewport) ---
	cmd_set_scissor                    :: proc(cmd_enc: CommandRecorder, info: ^vk.Rect2D) ---
	cmd_set_depth_bias                 :: proc(cmd_enc: CommandRecorder, info: ^DepthBiasInfo) ---
	cmd_set_index_buffer               :: proc(cmd_enc: CommandRecorder, info: ^SetIndexBufferInfo) -> Result ---
	cmd_draw                           :: proc(cmd_enc: CommandRecorder, info: ^DrawInfo) ---
	cmd_draw_indexed                   :: proc(cmd_enc: CommandRecorder, info: ^DrawIndexedInfo) ---
	cmd_draw_indirect                  :: proc(cmd_enc: CommandRecorder, info: ^DrawIndirectInfo) -> Result ---
	cmd_draw_indirect_count            :: proc(cmd_enc: CommandRecorder, info: ^DrawIndirectCountInfo) -> Result ---
	cmd_draw_mesh_tasks                :: proc(cmd_enc: CommandRecorder, x: u32, y: u32, z: u32) ---
	cmd_draw_mesh_tasks_indirect       :: proc(cmd_enc: CommandRecorder, info: ^DrawMeshTasksIndirectInfo) -> Result ---
	cmd_draw_mesh_tasks_indirect_count :: proc(cmd_enc: CommandRecorder, info: ^DrawMeshTasksIndirectCountInfo) -> Result ---
	cmd_write_timestamp                :: proc(cmd_enc: CommandRecorder, info: ^WriteTimestampInfo) ---
	cmd_reset_timestamps               :: proc(cmd_enc: CommandRecorder, info: ^ResetTimestampsInfo) ---
	cmd_begin_label                    :: proc(cmd_enc: CommandRecorder, info: ^CommandLabelInfo) ---
	cmd_end_label                      :: proc(cmd_enc: CommandRecorder) ---

	// Is called by all other commands. Flushes internal pipeline barrier list to actual vulkan call.
	cmd_flush_barriers             :: proc(cmd_enc: CommandRecorder) ---
	cmd_complete_current_commands  :: proc(cmd_enc: CommandRecorder, out_executable_cmds: ^ExecutableCommandList) -> Result ---
	cmd_info                       :: proc(cmd_enc: CommandRecorder) -> ^CommandRecorderInfo ---
	cmd_get_vk_command_buffer      :: proc(cmd_enc: CommandRecorder) -> vk.CommandBuffer ---
	cmd_get_vk_command_pool        :: proc(cmd_enc: CommandRecorder) -> vk.CommandPool ---
	destroy_command_recorder       :: proc(cmd_enc: CommandRecorder) ---
	executable_commands_inc_refcnt :: proc(executable_commands: ExecutableCommandList) -> u64 ---
	executable_commands_dec_refcnt :: proc(executable_commands: ExecutableCommandList) -> u64 ---
}

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
	src_offset: uint,
	dst_offset: uint,
	size: uint,
}
//DAXA_DEFAULT_BUFFER_COPY_INFO

BufferImageCopyInfo :: struct
{
	buffer: BufferId,
	buffer_offset: uint,
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
	buffer_offset: uint,
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
	size: u64,
}

DispatchInfo :: struct {
	x: u32,
	y: u32,
	z: u32,
}
//DAXA_DEFAULT_DISPATCH_INFO

DispatchIndirectInfo :: struct {
	indirect_buffer: BufferId,
	offset: uint,
}
//DAXA_DEFAULT_DISPATCH_INDIRECT_INFO

BuildAccelerationStucturesInfo :: struct {
	tlas_build_infos: ^TlasBuildInfo, //const * 
	tlas_build_info_count: uint,
	blas_build_infos: ^BlasBuildInfo, //const * 
	blas_build_info_count: uint,
}

BufferClearInfo :: struct {
	buffer: BufferId,
	offset: uint,
	size: uint,
	clear_value: u32,
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
	width: u32,
	height: u32,
	depth: u32,
	raygen_handle_offset: u32,
	miss_handle_offset: u32,
	hit_handle_offset: u32,
	callable_handle_offset: u32,
	shader_binding_table: RayTracingShaderBindingTable,
}

TraceRaysIndirectInfo :: struct
{
	indirect_device_address: u64,
	raygen_handle_offset: u32,
	miss_handle_offset: u32,
	hit_handle_offset: u32,
	callable_handle_offset: u32,
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
	offset: uint,
	index_type: vk.IndexType,
}

DrawInfo :: struct {
	vertex_count: u32,
	instance_count: u32,
	first_vertex: u32,
	first_instance: u32,
}
//DAXA_DEFAULT_DRAW_INFO

DrawIndexedInfo :: struct
{
	index_count: u32,
	instance_count: u32,
	first_index: u32,
	vertex_offset: i32,
	first_instance: u32,
}
//DAXA_DEFAULT_DRAW_INDEXED_INFO

DrawIndirectInfo :: struct
{
	indirect_buffer: BufferId,
	indirect_buffer_offset: uint,
	draw_count: u32,
	draw_command_stride: u32,
	is_indexed: Bool8,
}
//DAXA_DEFAULT_DRAW_INDIRECT_INFO

DrawMeshTasksIndirectInfo :: struct
{
	indirect_buffer: BufferId,
	offset: uint,
	draw_count: u32,
	stride: u32,
}
//DAXA_DEFAULT_DRAW_MESH_TASKS_INDIRECT_INFO

DrawIndirectCountInfo :: struct
{
	indirect_buffer: BufferId,
	indirect_buffer_offset: uint,
	count_buffer: BufferId,
	count_buffer_offset: uint,
	max_draw_count: u32,
	draw_command_stride: u32,
	is_indexed: Bool8,
}
//DAXA_DEFAULT_DRAW_INDIRECT_COUNT_INFO

DrawMeshTasksIndirectCountInfo :: struct {
	indirect_buffer: BufferId,
	offset: uint,
	count_buffer: BufferId,
	count_offset: uint,
	max_count: u32,
	stride: u32,
}
//DAXA_DRAW_MESH_TASKS_INDIRECT_COUNT_INFO

WriteTimestampInfo :: struct
{
	query_pool: ^TimelineQueryPool,
	pipeline_stage: vk.PipelineStageFlags2,
	query_index: u32,
}

ResetTimestampsInfo :: struct
{
	query_pool: ^TimelineQueryPool,
	start_index: u32,
	count: u32,
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
