package daxa

import "core:c"
import vk "vendor:vulkan"

_ :: c

DeviceType :: enum c.int {
	OTHER          = 0,
	INTEGRATED_GPU = 1,
	DISCRETE_GPU   = 2,
	VIRTUAL_GPU    = 3,
	CPU            = 4,
	MAX_ENUM       = 2147483647,
}

MissingRequiredVkFeature :: enum c.int {
	NONE,
	IMAGE_CUBE_ARRAY,
	INDEPENDENT_BLEND,
	TESSELLATION_SHADER,
	MULTI_DRAW_INDIRECT,
	DEPTH_CLAMP,
	FILL_MODE_NON_SOLID,
	WIDE_LINES,
	SAMPLER_ANISOTROPY,
	FRAGMENT_STORES_AND_ATOMICS,
	SHADER_STORAGE_IMAGE_MULTISAMPLE,
	SHADER_STORAGE_IMAGE_READ_WITHOUT_FORMAT,
	SHADER_STORAGE_IMAGE_WRITE_WITHOUT_FORMAT,
	SHADER_INT64,
	VARIABLE_POINTERS_STORAGE_BUFFER,
	VARIABLE_POINTERS,
	BUFFER_DEVICE_ADDRESS,
	BUFFER_DEVICE_ADDRESS_CAPTURE_REPLAY,
	BUFFER_DEVICE_ADDRESS_MULTI_DEVICE,
	SHADER_SAMPLED_IMAGE_ARRAY_NON_UNIFORM_INDEXING,
	SHADER_STORAGE_BUFFER_ARRAY_NON_UNIFORM_INDEXING,
	SHADER_STORAGE_IMAGE_ARRAY_NON_UNIFORM_INDEXING,
	DESCRIPTOR_BINDING_SAMPLED_IMAGE_UPDATE_AFTER_BIND,
	DESCRIPTOR_BINDING_STORAGE_IMAGE_UPDATE_AFTER_BIND,
	DESCRIPTOR_BINDING_STORAGE_BUFFER_UPDATE_AFTER_BIND,
	DESCRIPTOR_BINDING_UPDATE_UNUSED_WHILE_PENDING,
	DESCRIPTOR_BINDING_PARTIALLY_BOUND,
	RUNTIME_DESCRIPTOR_ARRAY,
	HOST_QUERY_RESET,
	DYNAMIC_RENDERING,
	SYNCHRONIZATION2,
	TIMELINE_SEMAPHORE,
	SUBGROUP_SIZE_CONTROL,
	COMPUTE_FULL_SUBGROUPS,
	SCALAR_BLOCK_LAYOUT,
	ACCELERATION_STRUCTURE_CAPTURE_REPLAY,
	VULKAN_MEMORY_MODEL,
	ROBUST_BUFFER_ACCESS2,
	ROBUST_IMAGE_ACCESS2,
	MAX_ENUM,
}

DeviceExplicitFeatureFlagBits :: enum c.int {
	NONE                                  = 0,
	BUFFER_DEVICE_ADDRESS_CAPTURE_REPLAY  = 1,
	ACCELERATION_STRUCTURE_CAPTURE_REPLAY = 2,
	VK_MEMORY_MODEL                       = 4,
	ROBUSTNESS_2                          = 8,
}

ExplicitFeatureFlags :: DeviceExplicitFeatureFlagBits

DeviceImplicitFeatureFlagBits :: enum c.int {
	NONE                           = 0,
	MESH_SHADER                    = 1,
	BASIC_RAY_TRACING              = 2,
	RAY_TRACING_PIPELINE           = 4,
	RAY_TRACING_INVOCATION_REORDER = 8,
	RAY_TRACING_POSITION_FETCH     = 16,
	CONSERVATIVE_RASTERIZATION     = 32,
	SHADER_ATOMIC_INT64            = 64,
	IMAGE_ATOMIC64                 = 128,
	SHADER_FLOAT16                 = 256,
	SHADER_INT8                    = 512,
	DYNAMIC_STATE_3                = 1024,
	SHADER_ATOMIC_FLOAT            = 2048,
	SWAPCHAIN                      = 4096,
	SHADER_INT16                   = 8192,
}

ImplicitFeatureFlags :: DeviceImplicitFeatureFlagBits

/// WARNING: DEPRECATED, use daxa_ImplicitFeatureFlags and daxa_ExplicitFeatureFlags instead!
DeviceFlagBits :: enum c.int {
	BUFFER_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT = 1,
	CONSERVATIVE_RASTERIZATION               = 2,
	MESH_SHADER_BIT                          = 4,
	SHADER_ATOMIC64                          = 8,
	IMAGE_ATOMIC64                           = 16,
	VK_MEMORY_MODEL                          = 32,
	RAY_TRACING                              = 64,
	SHADER_FLOAT16                           = 128,
	SHADER_INT8                              = 256,
	ROBUST_BUFFER_ACCESS                     = 512,
	ROBUST_IMAGE_ACCESS                      = 1024,
	DYNAMIC_STATE_3                          = 2048,
	SHADER_ATOMIC_FLOAT                      = 4096,
}

/// WARNING: DEPRECATED, use daxa_ImplicitFeatureFlags and daxa_ExplicitFeatureFlags instead!
DeviceFlags :: u32

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	/// DEPRECATED: use daxa_instance_create_device_2 and daxa_DeviceInfo2 instead!
	default_device_score                :: proc(properties: ^DeviceProperties) -> i32 ---
	dvc_buffer_memory_requirements      :: proc(device: Device, info: ^BufferInfo) -> vk.MemoryRequirements ---
	dvc_image_memory_requirements       :: proc(device: Device, info: ^ImageInfo) -> vk.MemoryRequirements ---
	dvc_create_memory                   :: proc(device: Device, info: ^MemoryBlockInfo, out_memory_block: ^MemoryBlock) -> Result ---
	dvc_get_tlas_build_sizes            :: proc(device: Device, build_info: ^TlasBuildInfo, out: ^AccelerationStructureBuildSizesInfo) -> Result ---
	dvc_get_blas_build_sizes            :: proc(device: Device, build_info: ^BlasBuildInfo, out: ^AccelerationStructureBuildSizesInfo) -> Result ---
	dvc_create_buffer                   :: proc(device: Device, info: ^BufferInfo, out_id: ^BufferId) -> Result ---
	dvc_create_image                    :: proc(device: Device, info: ^ImageInfo, out_id: ^ImageId) -> Result ---
	dvc_create_buffer_from_memory_block :: proc(device: Device, info: ^MemoryBlockBufferInfo, out_id: ^BufferId) -> Result ---
	dvc_create_image_from_block         :: proc(device: Device, info: ^MemoryBlockImageInfo, out_id: ^ImageId) -> Result ---
	dvc_create_image_view               :: proc(device: Device, info: ^ImageViewInfo, out_id: ^ImageViewId) -> Result ---
	dvc_create_sampler                  :: proc(device: Device, info: ^SamplerInfo, out_id: ^SamplerId) -> Result ---
	dvc_create_tlas                     :: proc(device: Device, info: ^TlasInfo, out_id: ^TlasId) -> Result ---
	dvc_create_blas                     :: proc(device: Device, info: ^BlasInfo, out_id: ^BlasId) -> Result ---
	dvc_create_tlas_from_buffer         :: proc(device: Device, info: ^BufferTlasInfo, out_id: ^TlasId) -> Result ---
	dvc_create_blas_from_buffer         :: proc(device: Device, info: ^BufferBlasInfo, out_id: ^BlasId) -> Result ---
	dvc_destroy_buffer                  :: proc(device: Device, buffer: BufferId) -> Result ---
	dvc_destroy_image                   :: proc(device: Device, image: ImageId) -> Result ---
	dvc_destroy_image_view              :: proc(device: Device, id: ImageViewId) -> Result ---
	dvc_destroy_sampler                 :: proc(device: Device, sampler: SamplerId) -> Result ---
	dvc_destroy_tlas                    :: proc(device: Device, tlas: TlasId) -> Result ---
	dvc_destroy_blas                    :: proc(device: Device, blas: BlasId) -> Result ---
	dvc_info_buffer                     :: proc(device: Device, buffer: BufferId, out_info: ^BufferInfo) -> Result ---
	dvc_info_image                      :: proc(device: Device, image: ImageId, out_info: ^ImageInfo) -> Result ---
	dvc_info_image_view                 :: proc(device: Device, id: ImageViewId, out_info: ^ImageViewInfo) -> Result ---
	dvc_info_sampler                    :: proc(device: Device, sampler: SamplerId, out_info: ^SamplerInfo) -> Result ---
	dvc_info_tlas                       :: proc(device: Device, acceleration_structure: TlasId, out_info: ^TlasInfo) -> Result ---
	dvc_info_blas                       :: proc(device: Device, acceleration_structure: BlasId, out_info: ^BlasInfo) -> Result ---
	dvc_is_buffer_valid                 :: proc(device: Device, buffer: BufferId) -> Bool8 ---
	dvc_is_image_valid                  :: proc(device: Device, image: ImageId) -> Bool8 ---
	dvc_is_image_view_valid             :: proc(device: Device, image_view: ImageViewId) -> Bool8 ---
	dvc_is_sampler_valid                :: proc(device: Device, sampler: SamplerId) -> Bool8 ---
	dvc_is_tlas_valid                   :: proc(device: Device, tlas: TlasId) -> Bool8 ---
	dvc_is_blas_valid                   :: proc(device: Device, blas: BlasId) -> Bool8 ---
	dvc_get_vk_buffer                   :: proc(device: Device, buffer: BufferId, out_vk_handle: ^vk.Buffer) -> Result ---
	dvc_get_vk_image                    :: proc(device: Device, image: ImageId, out_vk_handle: ^vk.Image) -> Result ---
	dvc_get_vk_image_view               :: proc(device: Device, id: ImageViewId, out_vk_handle: ^vk.ImageView) -> Result ---
	dvc_get_vk_sampler                  :: proc(device: Device, sampler: SamplerId, out_vk_handle: ^vk.Sampler) -> Result ---
	dvc_get_vk_tlas                     :: proc(device: Device, tlas: TlasId, out_vk_handle: ^vk.AccelerationStructureInstanceKHR) -> Result ---
	dvc_get_vk_blas                     :: proc(device: Device, blas: BlasId, out_vk_handle: ^vk.AccelerationStructureInstanceKHR) -> Result ---
	dvc_buffer_device_address           :: proc(device: Device, buffer: BufferId, out_addr: ^DeviceAddress) -> Result ---
	dvc_buffer_host_address             :: proc(device: Device, buffer: BufferId, out_addr: ^rawptr) -> Result ---
	dvc_tlas_device_address             :: proc(device: Device, tlas: TlasId, out_addr: ^DeviceAddress) -> Result ---
	dvc_blas_device_address             :: proc(device: Device, blas: BlasId, out_addr: ^DeviceAddress) -> Result ---
	dvc_create_raster_pipeline          :: proc(device: Device, info: ^RasterPipelineInfo, out_pipeline: ^RasterPipeline) -> Result ---
	dvc_create_compute_pipeline         :: proc(device: Device, info: ^ComputePipelineInfo, out_pipeline: ^ComputePipeline) -> Result ---
	dvc_create_ray_tracing_pipeline     :: proc(device: Device, info: ^RayTracingPipelineInfo, out_pipeline: ^RayTracingPipeline) -> Result ---
	dvc_create_swapchain                :: proc(device: Device, info: ^SwapchainInfo, out_swapchain: ^Swapchain) -> Result ---
	dvc_create_command_recorder         :: proc(device: Device, info: ^CommandRecorderInfo, out_command_list: ^CommandRecorder) -> Result ---
	dvc_create_binary_semaphore         :: proc(device: Device, info: ^BinarySemaphoreInfo, out_binary_semaphore: ^BinarySemaphore) -> Result ---
	dvc_create_timeline_semaphore       :: proc(device: Device, info: ^TimelineSemaphoreInfo, out_timeline_semaphore: ^TimelineSemaphore) -> Result ---
	dvc_create_event                    :: proc(device: Device, info: ^EventInfo, out_event: ^Event) -> Result ---
	dvc_create_timeline_query_pool      :: proc(device: Device, info: ^TimelineQueryPoolInfo, out_timeline_query_pool: ^TimelineQueryPool) -> Result ---
	dvc_get_vk_device                   :: proc(device: Device) -> vk.Device ---
	dvc_get_vk_physical_device          :: proc(device: Device) -> vk.PhysicalDevice ---
	dvc_queue_wait_idle                 :: proc(device: Device, queue: Queue) -> Result ---
	dvc_queue_count                     :: proc(device: Device, queue_family: QueueFamily, out_value: ^u32) -> Result ---
	dvc_wait_idle                       :: proc(device: Device) -> Result ---
	dvc_submit                          :: proc(device: Device, info: ^CommandSubmitInfo) -> Result ---
	dvc_present                         :: proc(device: Device, info: ^PresentInfo) -> Result ---
	dvc_collect_garbage                 :: proc(device: Device) -> Result ---
	dvc_info                            :: proc(device: Device) -> ^DeviceInfo2 ---
	dvc_properties                      :: proc(device: Device) -> ^DeviceProperties ---

	// Returns previous ref count.
	dvc_inc_refcnt :: proc(device: Device) -> u64 ---

	// Returns previous ref count.
	dvc_dec_refcnt :: proc(device: Device) -> u64 ---
}
