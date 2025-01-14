//
//  PhoneInfoService.swift
//  Cleaner
//
//  Created by Максим Лебедев on 09.10.2023.
//

import UIKit
import NetworkFlows

final class PhoneInfoService: TrafficMonitorDelegate {
    
    static let shared = PhoneInfoService()
    
    lazy var downloadSpeed: String = ""
    lazy var freeRAM: String = ""
    lazy var totalRAM: String = ""
    lazy var busyCPU: String = ""
    
    init() {
        TrafficMonitor.shared.delegate = self
    }
    
    func getFreeRAM() {
        freeRAM = "\(((ProcessInfo.processInfo.physicalMemory / 1024) - memoryUsage()) / (1024 * 1024)) GB"
    }
    
    
    func getTotalRam() {
        let ram = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)
        totalRAM = "of \((ram + 500) / 1000) GB"
    }
    
    func getBusyCPU() {
        busyCPU = "\(([8,9,10,10,10,10,11,12,13].randomElement() ?? 10) + Int(cpuUsage())) %"
    }
    
    func trafficMonitor(updatedInfo: TrafficInfo) {
        let number = updatedInfo.trafficPerSecond.downTotal.humanReadableNumber
        let unit = updatedInfo.trafficPerSecond.downTotal.humanReadableNumberUnit
        downloadSpeed = number + " " + unit
    }
    
    private func memoryUsage() -> UInt64 {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }
        
        return used / 1024 / 1024
    }
    
    private func cpuUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        
        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                guard infoResult == KERN_SUCCESS else {
                    break
                }
                
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return totalUsageOfCPU
    }
}
