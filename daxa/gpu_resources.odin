package daxa

import "core:c"

_ :: c

VmaAllocation_T :: struct {
}

VmaAllocation :: struct {}

ImageFlags :: u32

ImageUsageFlags :: bit_set[ImageUsageFlag; u32]
ImageUsageFlag :: enum {
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
