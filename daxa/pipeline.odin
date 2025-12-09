package daxa

import "core:c"

foreign import lib "daxa.lib"
_ :: lib

ShaderInfo :: struct {
	byte_code:      ^u32,
	byte_code_size: u32,
	create_flags:   VkPipelineShaderStageCreateFlags,

	required_subgroup_size: struct {
		value:     u32,
		has_value: Bool8,
	},

	entry_point: SmallString,
}

// RAY TRACING PIPELINE
RayTracingShaderInfo :: struct {
	info: ShaderInfo,
}

RayTracingShaderGroupInfo :: struct {
	// TODO: daxa types?
	type:                      VkRayTracingShaderGroupTypeKHR,
	general_shader_index:      u32,
	closest_hit_shader_index:  u32,
	any_hit_shader_index:      u32,
	intersection_shader_index: u32,
}

RayTracingPipelineInfo :: struct {
	ray_gen_stages: struct {
		data: ^RayTracingShaderInfo,
		size: c.size_t,
	},

	miss_stages: struct {
		data: ^RayTracingShaderInfo,
		size: c.size_t,
	},

	callable_stages: struct {
		data: ^RayTracingShaderInfo,
		size: c.size_t,
	},

	intersection_stages: struct {
		data: ^RayTracingShaderInfo,
		size: c.size_t,
	},

	closest_hit_stages: struct {
		data: ^RayTracingShaderInfo,
		size: c.size_t,
	},

	any_hit_stages: struct {
		data: ^RayTracingShaderInfo,
		size: c.size_t,
	},

	shader_groups: struct {
		data: ^RayTracingShaderGroupInfo,
		size: c.size_t,
	},

	pipeline_libraries: struct {
		data: ^RayTracingPipelineLibrary,
		size: c.size_t,
	},

	max_ray_recursion_depth: u32,
	push_constant_size:      u32,
	name:                    SmallString,
}

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	ray_tracing_pipeline_info               :: proc(ray_tracing_pipeline: RayTracingPipeline) -> ^RayTracingPipelineInfo ---
	ray_tracing_pipeline_create_default_sbt :: proc(pipeline: RayTracingPipeline, out_sbt: ^RayTracingShaderBindingTable, out_buffer: ^BufferId) -> Result ---

	// out_blob must be the size of the group_count * raytracing_properties.shaderGroupHandleSize
	// if group_count is -1, this function will infer it from the groups specified in pipeline creation
	ray_tracing_pipeline_get_shader_group_handles :: proc(pipeline: RayTracingPipeline, out_blob: rawptr, first_group: u32, group_count: i32) -> Result ---
	ray_tracing_pipeline_inc_refcnt               :: proc(pipeline: RayTracingPipeline) -> u64 ---
	ray_tracing_pipeline_dec_refcnt               :: proc(pipeline: RayTracingPipeline) -> u64 ---
	ray_tracing_pipeline_library_info             :: proc(pipeline_library: RayTracingPipelineLibrary) -> ^RayTracingPipelineInfo ---

	// out_blob must be the size of the group_count * raytracing_properties.shaderGroupHandleSize
	// if group_count is -1, this function will infer it from the groups specified in pipeline creation
	ray_tracing_pipeline_library_get_shader_group_handles :: proc(pipeline_library: RayTracingPipelineLibrary, out_blob: rawptr, first_group: u32, group_count: i32) -> Result ---
	ray_tracing_pipeline_library_inc_refcnt               :: proc(pipeline_library: RayTracingPipelineLibrary) -> u64 ---
	ray_tracing_pipeline_library_dec_refcnt               :: proc(pipeline_library: RayTracingPipelineLibrary) -> u64 ---
}

// COMPUTE PIPELINE
ComputePipelineInfo :: struct {
	shader_info:        ShaderInfo,
	push_constant_size: u32,
	name:               SmallString,
}

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	compute_pipeline_info       :: proc(compute_pipeline: ComputePipeline) -> ^ComputePipelineInfo ---
	compute_pipeline_inc_refcnt :: proc(pipeline: ComputePipeline) -> u64 ---
	compute_pipeline_dec_refcnt :: proc(pipeline: ComputePipeline) -> u64 ---
}

// RASTER PIPELINE
DepthTestInfo :: struct {
	depth_attachment_format: VkFormat,
	enable_depth_write:      Bool8,
	depth_test_compare_op:   VkCompareOp,
	min_depth_bounds:        f32,
	max_depth_bounds:        f32,
}

ConservativeRasterInfo :: struct {
	mode: VkConservativeRasterizationModeEXT,
	size: f32,
}

LineRasterInfo :: struct {
	mode:            VkLineRasterizationModeKHR,
	stippled:        Bool8,
	stipple_factor:  u32,
	stipple_pattern: u16,
}

RasterizerInfo :: struct {
	primitive_topology:         VkPrimitiveTopology,
	primitive_restart_enable:   Bool8,
	polygon_mode:               VkPolygonMode,
	face_culling:               VkCullModeFlags,
	front_face_winding:         VkFrontFace,
	depth_clamp_enable:         Bool8,
	rasterizer_discard_enable:  Bool8,
	depth_bias_enable:          Bool8,
	depth_bias_constant_factor: f32,
	depth_bias_clamp:           f32,
	depth_bias_slope_factor:    f32,
	line_width:                 f32,

	conservative_raster_info: struct {
		value:     ConservativeRasterInfo,
		has_value: Bool8,
	},

	line_raster_info: struct {
		value:     LineRasterInfo,
		has_value: Bool8,
	},

	static_state_sample_count: struct {
		value:     VkSampleCountFlagBits,
		has_value: Bool8,
	},
}

// should be moved in c++ from types to pipeline.hpp.
BlendInfo :: struct {
	src_color_blend_factor: VkBlendFactor,
	dst_color_blend_factor: VkBlendFactor,
	color_blend_op:         VkBlendOp,
	src_alpha_blend_factor: VkBlendFactor,
	dst_alpha_blend_factor: VkBlendFactor,
	alpha_blend_op:         VkBlendOp,
	color_write_mask:       VkColorComponentFlags,
}

RenderAttachment :: struct {
	format: VkFormat,

	blend: struct {
		value:     BlendInfo,
		has_value: Bool8,
	},
}

TesselationInfo :: struct {
	control_points: u32,
	origin:         VkTessellationDomainOrigin,
}

RasterPipelineInfo :: struct {
	mesh_shader_info: struct {
		value:     ShaderInfo,
		has_value: Bool8,
	},

	vertex_shader_info: struct {
		value:     ShaderInfo,
		has_value: Bool8,
	},

	tesselation_control_shader_info: struct {
		value:     ShaderInfo,
		has_value: Bool8,
	},

	tesselation_evaluation_shader_info: struct {
		value:     ShaderInfo,
		has_value: Bool8,
	},

	fragment_shader_info: struct {
		value:     ShaderInfo,
		has_value: Bool8,
	},

	task_shader_info: struct {
		value:     ShaderInfo,
		has_value: Bool8,
	},

	color_attachments: struct {
		data: [8]RenderAttachment,
		size: u8,
	},

	depth_test: struct {
		value:     DepthTestInfo,
		has_value: Bool8,
	},

	tesselation: struct {
		value:     TesselationInfo,
		has_value: Bool8,
	},

	raster:             RasterizerInfo,
	push_constant_size: u32,
	name:               SmallString,
}

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	raster_pipeline_info       :: proc(raster_pipeline: RasterPipeline) -> ^RasterPipelineInfo ---
	raster_pipeline_inc_refcnt :: proc(pipeline: RasterPipeline) -> u64 ---
	raster_pipeline_dec_refcnt :: proc(pipeline: RasterPipeline) -> u64 ---
}

