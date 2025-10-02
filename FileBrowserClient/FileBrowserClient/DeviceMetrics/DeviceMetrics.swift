//
//  DeviceMetrics.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/27/25.
//

import Foundation
import MachO

import CoreMotion

let motionManager = CMMotionManager()

struct GenericUsage {
    let used: UInt64
    let total: UInt64
}

func getMemoryUsage() -> GenericUsage? {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info)) / 4

    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
        }
    }

    if kerr == KERN_SUCCESS {
        let used = info.resident_size
        let total = ProcessInfo.processInfo.physicalMemory
        return GenericUsage(used: used, total: total)
    } else {
        Log.error("Error with task_info(): " +
                 (String(cString: mach_error_string(kerr), encoding: .ascii) ?? "unknown error"))
        return nil
    }
}

func getSystemUptime() -> TimeInterval? {
    var uptime = timeval()
    var size = MemoryLayout<timeval>.size

    let result = sysctlbyname("kern.boottime", &uptime, &size, nil, 0)

    if result == 0 {
        return TimeInterval(uptime.tv_sec)
    } else {
        return nil
    }
}

func getDeviceOrientation() -> CMAttitude? {
    if motionManager.isDeviceMotionAvailable {
        motionManager.startDeviceMotionUpdates()
        return motionManager.deviceMotion?.attitude
    }
    return nil
}

func getCPUUsage() -> Double? {
    var threadList: thread_act_array_t?
    var threadCount = mach_msg_type_number_t()

    let taskThreads = task_threads(mach_task_self_, &threadList, &threadCount)
    if taskThreads != KERN_SUCCESS {
        return nil
    }

    guard let threads = threadList else { return nil }

    var totalUsageOfCPU = 0.0

    for index in 0..<Int(threadCount) {
        var threadInfo = thread_basic_info()
        var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)

        let result = withUnsafeMutablePointer(to: &threadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(threadInfoCount)) {
                thread_info(threads[index], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
            }
        }

        if result == KERN_SUCCESS {
            if (threadInfo.flags & TH_FLAGS_IDLE) == 0 {
                totalUsageOfCPU += Double(threadInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0
            }
        }
    }

    // Deallocate threadList
    let size = MemoryLayout<thread_t>.stride * Int(threadCount)
    vm_deallocate(mach_task_self_, vm_address_t(bitPattern: threads), vm_size_t(size))

    return totalUsageOfCPU
}

func getDiskUsage() -> GenericUsage? {
    do {
        let attrs = try FileManager.default.attributesOfFileSystem(forPath: "/")
        if let freeSpace = attrs[.systemFreeSize] as? UInt64,
           let totalSpace = attrs[.systemSize] as? UInt64 {
            let usedSpace = totalSpace - freeSpace
            return GenericUsage(used: usedSpace, total: totalSpace)
        }
    } catch {
        Log.error("Error getting disk usage: \(error)")
    }
    return nil
}
