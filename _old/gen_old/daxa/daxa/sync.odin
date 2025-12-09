package daxa

import "core:c"

_ :: c

foreign import lib "daxa.lib"

EventWaitInfo :: EventSignalInfo

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	binary_semaphore_info               :: proc(binary_semaphore: BinarySemaphore) -> ^BinarySemaphoreInfo ---
	binary_semaphore_get_vk_semaphore   :: proc(binary_semaphore: BinarySemaphore) -> VkSemaphore ---
	binary_semaphore_inc_refcnt         :: proc(binary_semaphore: BinarySemaphore) -> u64 ---
	binary_semaphore_dec_refcnt         :: proc(binary_semaphore: BinarySemaphore) -> u64 ---
	timeline_semaphore_info             :: proc(timeline_semaphore: TimelineSemaphore) -> ^TimelineSemaphoreInfo ---
	timeline_semaphore_get_value        :: proc(timeline_semaphore: TimelineSemaphore, out_value: ^u64) -> Result ---
	timeline_semaphore_set_value        :: proc(timeline_semaphore: TimelineSemaphore, value: u64) -> Result ---
	timeline_semaphore_wait_for_value   :: proc(timeline_semaphore: TimelineSemaphore, value: u64, timeout: u64) -> Result ---
	timeline_semaphore_get_vk_semaphore :: proc(timeline_semaphore: TimelineSemaphore) -> VkSemaphore ---
	timeline_semaphore_inc_refcnt       :: proc(timeline_semaphore: TimelineSemaphore) -> u64 ---
	timeline_semaphore_dec_refcnt       :: proc(timeline_semaphore: TimelineSemaphore) -> u64 ---
	event_info                          :: proc(event: Event) -> ^EventInfo ---
	event_inc_refcnt                    :: proc(event: Event) -> u64 ---
	event_dec_refcnt                    :: proc(event: Event) -> u64 ---
}
