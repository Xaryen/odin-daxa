package daxa

import vk "vendor:vulkan"

foreign import lib "daxa.lib"

InstanceFlags :: Flags

@(default_calling_convention="c", link_prefix="daxa_")
foreign lib {
	create_instance :: proc(info: ^InstanceInfo, out_instance: ^Instance) -> Result ---

	/// WARNING: DEPRECATED, use daxa_instance_create_device_2 instead!
	instance_create_device   :: proc(instance: Instance, info: ^DeviceInfo, out_device: ^Device) -> Result ---
	instance_create_device_2 :: proc(instance: Instance, info: ^DeviceInfo2, out_device: ^Device) -> Result ---

	// Can be used to autofill the physical_device_index in a partially filled daxa_DeviceInfo2.
	instance_choose_device :: proc(instance: Instance, desired_implicit_features: ImplicitFeatureFlags, info: ^DeviceInfo2) -> Result ---

	// Returns previous ref count.
	instance_inc_refcnt :: proc(instance: Instance) -> u64 ---

	// Returns previous ref count.
	instance_dec_refcnt              :: proc(instance: Instance) -> u64 ---
	instance_info                    :: proc(instance: Instance) -> ^InstanceInfo ---
	instance_get_vk_instance         :: proc(instance: Instance) -> vk.Instance ---
	instance_list_devices_properties :: proc(instance: Instance, properties: ^^DeviceProperties, property_count: ^u32) ---
}
