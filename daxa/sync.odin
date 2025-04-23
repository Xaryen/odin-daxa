package daxa

import "core:c"
import vk "vendor:vulkan"

_ :: c

EventWaitInfo :: EventSignalInfo

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	binary_semaphore_info               :: proc(binary_semaphore: BinarySemaphore) -> ^BinarySemaphoreInfo ---
	binary_semaphore_get_vk_semaphore   :: proc(binary_semaphore: BinarySemaphore) -> vk.Semaphore ---
	binary_semaphore_inc_refcnt         :: proc(binary_semaphore: BinarySemaphore) -> u64 ---
	binary_semaphore_dec_refcnt         :: proc(binary_semaphore: BinarySemaphore) -> u64 ---
	timeline_semaphore_info             :: proc(timeline_semaphore: TimelineSemaphore) -> ^TimelineSemaphoreInfo ---
	timeline_semaphore_get_value        :: proc(timeline_semaphore: TimelineSemaphore, out_value: ^u64) -> Result ---
	timeline_semaphore_set_value        :: proc(timeline_semaphore: TimelineSemaphore, value: u64) -> Result ---
	timeline_semaphore_wait_for_value   :: proc(timeline_semaphore: TimelineSemaphore, value: u64, timeout: u64) -> Result ---
	timeline_semaphore_get_vk_semaphore :: proc(timeline_semaphore: TimelineSemaphore) -> vk.Semaphore ---
	timeline_semaphore_inc_refcnt       :: proc(timeline_semaphore: TimelineSemaphore) -> u64 ---
	timeline_semaphore_dec_refcnt       :: proc(timeline_semaphore: TimelineSemaphore) -> u64 ---
	event_info                          :: proc(event: Event) -> ^EventInfo ---
	event_inc_refcnt                    :: proc(event: Event) -> u64 ---
	event_dec_refcnt                    :: proc(event: Event) -> u64 ---
}

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
	memory_barrier_count: u64,
	image_memory_barriers: ^ImageMemoryBarrierInfo, //const * 
	image_memory_barrier_count: u64,
	event: ^Event,
}

BinarySemaphoreInfo :: struct
{
	name: SmallString,
}

TimelineSemaphoreInfo :: struct
{
	initial_value: u64,
	name: SmallString,
}

EventInfo :: struct
{
	name: SmallString,
}

TimelinePair :: struct
{
	semaphore: TimelineSemaphore,
	value: u64,
}
