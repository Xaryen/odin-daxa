package daxa

import "core:c"

_ :: c

foreign import lib "daxa.lib"

ImplDevice :: struct {
}

Device :: struct {}

ImplCommandRecorder :: struct {
}

CommandRecorder :: struct {}

ImplExecutableCommandList :: struct {
}

ExecutableCommandList :: struct {}

ImplInstance :: struct {
}

Instance :: struct {}

ImplRayTracingPipeline :: struct {
}

RayTracingPipeline :: struct {}

ImplComputePipeline :: struct {
}

ComputePipeline :: struct {}

ImplRasterPipeline :: struct {
}

RasterPipeline :: struct {}

ImplSwapchain :: struct {
}

Swapchain :: struct {}

ImplBinarySemaphore :: struct {
}

BinarySemaphore :: struct {}

ImplTimelineSemaphore :: struct {
}

TimelineSemaphore :: struct {}

ImplEvent :: struct {
}

Event :: struct {}

ImplTimelineQueryPool :: struct {
}

TimelineQueryPool :: struct {}

ImplMemoryBlock :: struct {
}

MemoryBlock :: struct {}

Flags :: u64

Bool8 :: u8

b32 :: u32

i32 :: i32

u32 :: u32

i64 :: i64

u64 :: u64

f32 :: f32

f64 :: f64

