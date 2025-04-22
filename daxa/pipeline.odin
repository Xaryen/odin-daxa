package daxa

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	ray_tracing_pipeline_info               :: proc(ray_tracing_pipeline: RayTracingPipeline) -> ^RayTracingPipelineInfo ---
	ray_tracing_pipeline_create_default_sbt :: proc(pipeline: RayTracingPipeline, out_sbt: ^RayTracingShaderBindingTable, out_buffer: ^BufferId) -> Result ---

	// out_blob must be the size of the group_count * raytracing_properties.shaderGroupHandleSize
	ray_tracing_pipeline_get_shader_group_handles :: proc(pipeline: RayTracingPipeline, out_blob: rawptr) -> Result ---
	ray_tracing_pipeline_inc_refcnt               :: proc(pipeline: RayTracingPipeline) -> u64 ---
	ray_tracing_pipeline_dec_refcnt               :: proc(pipeline: RayTracingPipeline) -> u64 ---
	compute_pipeline_info                         :: proc(compute_pipeline: ComputePipeline) -> ^ComputePipelineInfo ---
	compute_pipeline_inc_refcnt                   :: proc(pipeline: ComputePipeline) -> u64 ---
	compute_pipeline_dec_refcnt                   :: proc(pipeline: ComputePipeline) -> u64 ---
	raster_pipeline_info                          :: proc(raster_pipeline: RasterPipeline) -> ^RasterPipelineInfo ---
	raster_pipeline_inc_refcnt                    :: proc(pipeline: RasterPipeline) -> u64 ---
	raster_pipeline_dec_refcnt                    :: proc(pipeline: RasterPipeline) -> u64 ---
}
