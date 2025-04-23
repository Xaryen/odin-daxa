package daxa

import "core:c"

_ :: c

BufferId :: struct { value: u64 }
ImageId  :: struct { value: u64 }
TlasId   :: struct { value: u64 }
BlasId   :: struct { value: u64 }

ImageViewId  :: struct { value: u64 }
SamplerId    :: struct { value: u64 }


ImplCommandRecorder :: struct {}
CommandRecorder :: ^ImplCommandRecorder

ImplExecutableCommandList :: struct {}
ExecutableCommandList :: ^ImplExecutableCommandList

ImplInstance :: struct {}
Instance     :: ^ImplInstance

ImplDevice :: struct {}
Device     :: ^ImplDevice


ImplRayTracingPipeline :: struct {}
RayTracingPipeline :: ^ImplRayTracingPipeline


ImplComputePipeline :: struct {}
ComputePipeline :: ^ImplComputePipeline


ImplRasterPipeline :: struct {}
RasterPipeline :: ^ImplRasterPipeline

ImplSwapchain :: struct {}
Swapchain     :: ^ImplSwapchain


ImplBinarySemaphore :: struct {}
BinarySemaphore :: ^ImplBinarySemaphore

ImplTimelineSemaphore :: struct {}
TimelineSemaphore :: ^ImplTimelineSemaphore


ImplEvent :: struct {}
Event :: ^ImplEvent


ImplTimelineQueryPool :: struct {}
TimelineQueryPool :: ^ImplTimelineQueryPool


ImplMemoryBlock :: struct {}
MemoryBlock :: ^ImplMemoryBlock

Flags :: u64
Bool8 :: u8
b32 :: u32

