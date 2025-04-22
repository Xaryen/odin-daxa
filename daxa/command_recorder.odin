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
