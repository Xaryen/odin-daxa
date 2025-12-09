package daxa

foreign import lib "daxa.lib"
_ :: lib

Access :: struct {
	stages:      VkPipelineStageFlags2,
	access_type: VkAccessFlags2,
}

BarrierInfo :: struct {
	src_access: Access,
	dst_access: Access,
}

/* deprecated("Use daxa_BarrierInfo instead; API:3.2") */
daxa_MemoryBarrierInfo :: BarrierInfo

/* deprecated("Use ImageBarrierInfo instead; API:3.2") */
ImageMemoryBarrierInfo :: struct {
	src_access:  Access,
	dst_access:  Access,
	src_layout:  ImageLayout,
	dst_layout:  ImageLayout,
	image_slice: ImageMipArraySlice,
	image_id:    ImageId,
}

ImageLayoutOperation :: enum i32 {
	NONE           = 0,
	TO_GENERAL     = 1,
	TO_PRESENT_SRC = 2,
}

ImageBarrierInfo :: struct {
	src_access:       Access,
	dst_access:       Access,
	image_id:         ImageId,
	layout_operation: ImageLayoutOperation,
}

BinarySemaphoreInfo :: struct {
	name: SmallString,
}

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	binary_semaphore_info             :: proc(binary_semaphore: BinarySemaphore) -> ^BinarySemaphoreInfo ---
	binary_semaphore_get_vk_semaphore :: proc(binary_semaphore: BinarySemaphore) -> VkSemaphore ---
	binary_semaphore_inc_refcnt       :: proc(binary_semaphore: BinarySemaphore) -> u64 ---
	binary_semaphore_dec_refcnt       :: proc(binary_semaphore: BinarySemaphore) -> u64 ---
}

TimelineSemaphoreInfo :: struct {
	initial_value: u64,
	name:          SmallString,
}

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	timeline_semaphore_info             :: proc(timeline_semaphore: TimelineSemaphore) -> ^TimelineSemaphoreInfo ---
	timeline_semaphore_get_value        :: proc(timeline_semaphore: TimelineSemaphore, out_value: ^u64) -> Result ---
	timeline_semaphore_set_value        :: proc(timeline_semaphore: TimelineSemaphore, value: u64) -> Result ---
	timeline_semaphore_wait_for_value   :: proc(timeline_semaphore: TimelineSemaphore, value: u64, timeout: u64) -> Result ---
	timeline_semaphore_get_vk_semaphore :: proc(timeline_semaphore: TimelineSemaphore) -> VkSemaphore ---
	timeline_semaphore_inc_refcnt       :: proc(timeline_semaphore: TimelineSemaphore) -> u64 ---
	timeline_semaphore_dec_refcnt       :: proc(timeline_semaphore: TimelineSemaphore) -> u64 ---
}

EventInfo :: struct {
	name: SmallString,
}

EventSignalInfo :: struct {
	barriers:            ^BarrierInfo,
	barrier_count:       u64,
	image_barriers:      ^ImageBarrierInfo,
	image_barrier_count: u64,
	event:               ^Event,
}

EventWaitInfo :: EventSignalInfo

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	event_info       :: proc(event: Event) -> ^EventInfo ---
	event_inc_refcnt :: proc(event: Event) -> u64 ---
	event_dec_refcnt :: proc(event: Event) -> u64 ---
}

TimelinePair :: struct {
	semaphore: TimelineSemaphore,
	value:     u64,
}

