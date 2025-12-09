package daxa

import "core:c"
import vk "vendor:vulkan"

_ :: c

VmaAllocation_T :: struct {}

VmaAllocation :: struct {}

ImageFlags :: u32

ImageUsageFlags :: bit_set[ImageUsageFlag; u32]
ImageUsageFlag :: enum u32 {
	NONE,
	TRANSFER_SRC,
	TRANSFER_DST,
	SHADER_SAMPLED,
	SHADER_STORAGE,
	COLOR_ATTACHMENT,
	DEPTH_STENCIL_ATTACHMENT,
	TRANSIENT_ATTACHMENT,
	FRAGMENT_SHADING_RATE_ATTACHMENT = 8,
	FRAGMENT_DENSITY_MAP             = 9,
}

SharingMode :: enum c.int {
	EXCLUSIVE,
	CONCURRENT,
}

GeometryFlagBits :: enum c.int {
	OPAQUE                          = 1,
	NO_DUPLICATE_ANY_HIT_INVOCATION = 2,
}

GeometryFlags :: i32

BuildAccelerationStructureFlagBits :: enum c.int {
	ALLOW_UPDATE      = 1,
	ALLOW_COMPACTION  = 2,
	PREFER_FAST_TRACE = 4,
	PREFER_FAST_BUILD = 8,
	LOW_MEMORY        = 16,
}

BuildAcclelerationStructureFlags :: u32

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	default_view                    :: proc(image: ImageId) -> ImageViewId ---
	index_of_buffer                 :: proc(id: BufferId) -> u32 ---
	index_of_image                  :: proc(id: ImageId) -> u32 ---
	index_of_image_view             :: proc(id: ImageViewId) -> u32 ---
	index_of_sampler                :: proc(id: SamplerId) -> u32 ---
	version_of_buffer               :: proc(id: BufferId) -> u64 ---
	version_of_image                :: proc(id: ImageId) -> u64 ---
	version_of_image_view           :: proc(id: ImageViewId) -> u64 ---
	version_of_sampler              :: proc(id: SamplerId) -> u64 ---
	memory_block_get_vma_allocation :: proc(memory_block: MemoryBlock) -> VmaAllocation ---
}

DeviceAddress :: struct { value: u64 }

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
	size: uint,
	allocate_info: MemoryFlags,     // Ignored when allocating with a memory block.
	name: SmallString,
}

ImageInfo :: struct
{
	flags: ImageFlags,
	dimensions: u32,
    	format: vk.Format,
    	size: vk.Extent3D,
	mip_level_count: u32,
	array_layer_count: u32,
	sample_count: u32,
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
	instance_count: u32,
	scratch_data: DeviceAddress,
}
//DAXA_DEFAULT_TLAS_BUILD_INFO

/// Instances are defines as VkAccelerationStructureInstanceKHR;
TlasInstanceInfo :: struct {
	data: DeviceAddress,
	count: u32,
	is_data_array_of_pointers: Bool8,
	flags: GeometryFlags,
}
//DAXA_DEFAULT_TLAS_INSTANCE_INFO

TlasInfo :: struct
{
	size: u64,
	name: SmallString,
}
//DAXA_DEFAULT_TLAS_INFO
BlasInfo :: struct
{
	size: u64,
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
	count: uint,
}

BlasTriangleGeometryInfo :: struct {
	vertex_format: vk.Format,
	vertex_data: DeviceAddress,
	vertex_stride: u64,
	max_vertex: u32,
	index_type: vk.IndexType,
	index_data: DeviceAddress,
	transform_data: DeviceAddress,
	count: u32,
	flags: GeometryFlags,
}

BlasAabbsGeometryInfoSpan :: struct {
	aabbs: ^BlasAabbGeometryInfo, //const * 
	count: uint,
}

BlasAabbGeometryInfo :: struct {
	data: DeviceAddress,
	stride: u64,
	count: u32,
	flags: GeometryFlags,
}
