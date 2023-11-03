//
//  CodeCoverageTool.swift
//  CodeCoverageRate01
//
//  Created by 葛高召 on 2023/11/1.
//

import Foundation
import UIKit

private let instance:GZCodeCoverageTool = GZCodeCoverageTool()

@objc public class GZCodeCoverageTool:NSObject {
    
    var isRegister:Bool = false
    
    public static func shared() -> GZCodeCoverageTool {
        return instance
    }
    
    //注册
    public func registerCoverage(moduleName: String) {
        if isRegister {
            return
        }
        isRegister = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackgroudNotification),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        let name = "\(moduleName).profraw"
        print("registerCoverage, moduleName: \(moduleName)")
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let filePath: NSString = documentDirectory.appendingPathComponent(name).path as NSString
            print("registerCoverage filePath: \(filePath)")
            __llvm_profile_set_filename(filePath.utf8String)
        } catch {
            print(error)
        }
    }
    
    //合适的时机代码覆盖率上报
    func saveAndUpload() {
        __llvm_profile_write_file()
    }
    
    @objc private func didEnterBackgroudNotification() {
        self.saveAndUpload()
    }
    
}
