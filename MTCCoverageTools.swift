//
//  CoverageTools.swift
//  MTCCodeCov
//
//  Created by joe.xu on 2023/6/13.
//

import Foundation



@objc public class MTCCoverageTools: NSObject {
    @objc public static var shared = MTCCoverageTools()
    private final var MTC_HOST = "https://mtc-pre.huolala.work"
    
    @objc public static var mdapBuildID:String!
    private static var profRawFilePath:String!
    
    
    @objc public func registerCoverage(mdapBuildID: String) {
        
        if(MTCCoverageTools.profRawFilePath != nil){
            return
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackgroudNotification),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        do {
            let name = "\(mdapBuildID)_\(UUID().uuidString).profraw"
            print("MTCCoverageTools fileName: \(name)")
            let fileManager = FileManager.default
            
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            MTCCoverageTools.profRawFilePath = documentDirectory.appendingPathComponent(name).path
            MTCCoverageTools.mdapBuildID = mdapBuildID
            __llvm_profile_set_filename(MTCCoverageTools.profRawFilePath)
            print("MTCCoverageTools filePath: \(MTCCoverageTools.profRawFilePath!)")
        } catch {
            print("MTCCoverageTools: \(error)")
        }
    }
    
    
    @objc public func saveAndUpload(uploadBy:String? = nil, taskId: String? = nil, uploadHost: String? = nil) {
//        let fileManager = FileManager.default
//        do{
//            //NOTE 每次重置文件，否则文件会膨胀
//            if fileManager.fileExists(atPath: MTCCoverageTools.profRawFilePath!){
//                try fileManager.removeItem(atPath: MTCCoverageTools.profRawFilePath!)
//            }
//        }catch{
//            print("MTCCoverageTools: \(error)")
//        }
//
        __llvm_profile_write_file()
        
//        self.startUpload(uploadBy: uploadBy, taskId: taskId, uploadHost: uploadHost)
    }
    
    @objc func didEnterBackgroudNotification(){
//        do{
//            // 从 mtc.env 读取自动化配置
//            let fileManager = FileManager.default
//            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
//            let mtcEnvFile = documentDirectory.appendingPathComponent("mtc.env")
//
//            if !fileManager.fileExists(atPath: mtcEnvFile.path){
//                return
//            }
//            var envDict = [String:String]()
//
//            let envContent = try String(contentsOf: mtcEnvFile, encoding: .utf8)
//            let lines = envContent.components(separatedBy: .newlines)
//
//            for line in lines{
//                let s = line.split(separator: ":", maxSplits: 1)
//                let k = String(s[0])
//                let v = String(s[1])
//                envDict[k] = v
//                print("\(k):\(v)")
//            }
//
//            let taskId = envDict["taskId"]
//            let uploadHost = envDict["uploadHost"]
            self.saveAndUpload(uploadBy: nil, taskId: "", uploadHost: "")
            
//        }catch{
//            print("MTCCoverageTools: \(error)")
//        }
    }
    
    
    func startUpload(uploadBy:String? = nil, taskId: String? = nil, uploadHost: String? = nil) {
        
        //分隔线
        let boundary = "Boundary-\(UUID().uuidString)"
        
        //传递的参数
        var parameters = [
            "buildId": MTCCoverageTools.mdapBuildID!,
            "packageName": Bundle.main.bundleIdentifier!,
        ]
        
        if uploadBy != nil {
            parameters["createBy"] = uploadBy
        }
        
        if taskId != nil {
            parameters["taskId"] = taskId
        }
        
        //传递的文件
        let files = [
            (
                name: "profRaw",
                path: MTCCoverageTools.profRawFilePath!
            )
        ]
        
        //上传地址
        var url = URL(string: "\(MTC_HOST)/mtc/coverage/upload-prof-raw")!
        if uploadHost != nil{
            url = URL(string: "\(uploadHost!)/mtc/coverage/upload-prof-raw")!
        }
        var request = URLRequest(url: url)
        //请求类型为POST
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        //创建表单body
        do{
            request.httpBody = try createBody(with: parameters, files: files, boundary: boundary)
        }catch{
            print("MTCCoverageTools: \(error)")
        }
        
        let configuration:URLSessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: configuration,delegate: self, delegateQueue: nil)
//        let session = URLSession.shared
        let uploadTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            //上传完毕后
            if error != nil{
                print("MTCCoverageTools: \(error!)")
            }else{
                let str = String(data: data!, encoding: String.Encoding.utf8)
                print("MTCCoverageTools --- 上传完毕 ---\(str!)")
            }
        })
        
        //使用resume方法启动任务
        uploadTask.resume()
    }
    
    //创建表单body
    private func createBody(with parameters: [String: String]?,
                            files: [(name:String, path:String)],
                            boundary: String) throws -> Data {
        var body = Data()
        
        //添加普通参数数据
        if parameters != nil {
            for (key, value) in parameters! {
                
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        //添加文件数据
        for file in files {
            let url = URL(fileURLWithPath: file.path)
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = "application/octet-stream"
            
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; "
                        + "name=\"\(file.name)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n") //文件类型
            body.append(data) //文件主体
            body.append("\r\n")
        }
        
        // --分隔线-- 为整个表单的结束符
        body.append("--\(boundary)--\r\n")
        return body
    }

}


//扩展Data
extension Data {
    //增加直接添加String数据的方法
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}


// disable https cert
extension MTCCoverageTools:URLSessionDelegate{
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential.init(trust: challenge.protectionSpace.serverTrust!))
    }
}
