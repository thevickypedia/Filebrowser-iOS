//
//  MemoryUsage.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 9/27/25.
//


import Foundation
import MachO

struct MemoryUsage {
    let used: UInt64
    let total: UInt64
}

func getMemoryUsage() -> MemoryUsage? {
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
        return MemoryUsage(used: used, total: total)
    } else {
        Log.error("Error with task_info(): " +
                 (String(cString: mach_error_string(kerr), encoding: .ascii) ?? "unknown error"))
        return nil
    }
}
