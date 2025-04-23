package daxa

import vk "vendor:vulkan"

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
	byte_code: ^u32, //const * 
	byte_code_size: u32,
	create_flags: vk.PipelineShaderStageCreateFlags,
	required_subgroup_size: Optional(u32),
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
	control_points: u32,
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
	push_constant_size: u32,
	name: SmallString,
}
//DAXA_DEFAULT_RASTERIZER_PIPELINE_INFO

ComputePipelineInfo :: struct
{
	shader_info: ShaderInfo,
	push_constant_size: u32,
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
	general_shader_index: u32,
	closest_hit_shader_index: u32,
	any_hit_shader_index: u32,
	intersection_shader_index: u32,
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
	max_ray_recursion_depth: u32,
	push_constant_size: u32,
	name: SmallString,
}
//DAXA_DEFAULT_RAY_TRACING_PIPELINE_INFO
