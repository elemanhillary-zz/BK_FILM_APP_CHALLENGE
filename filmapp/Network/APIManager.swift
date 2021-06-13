//
//  APIManager.swift
//  filmapp
//
//  Created by MacBook Pro on 11/8/20.
//

import Foundation
import Alamofire


typealias UploadProgress = (_ percent:CGFloat) -> Void
typealias HttpSuccess = (_ data:Any) -> Void
typealias HttpFailure = (_ error:Error) -> Void

class APIManager {

    static let shared = APIManager()
    let baseURL = "https://api.themoviedb.org/3/"
    
    let NetWorkDomain: String = "bk.filmapp"

    static let reachabilityManager = { () -> NetworkReachabilityManager in
        let manager = NetworkReachabilityManager.init()
        return manager!
    }()
    
    static let sessionManager = { () -> Session in
        var manager = Session.default
        return manager
    }()
    
    func processData(data: Any, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        if ((data as AnyObject).count > 0) {
            success(data)
        } else {
            let message: String = Messages.anErrorOccured
            let error = NSError.init(domain: NetWorkDomain, code: NetworkError.HttpRequestFailed.rawValue, userInfo: [NSLocalizedDescriptionKey: message])
            failure(error)
        }
    }
    
    func getRequest(urlPath: String, headers: HTTPHeaders?, request: BaseRequest, encoding: ParameterEncoding, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let baseUrl = baseURL + urlPath
        let parameters = request.toJSON()
        APIManager.sessionManager.request(baseUrl, method: HTTPMethod.get, parameters: parameters ?? nil, encoding: encoding)
            .validate(statusCode: 200..<500)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    if let data:[String:Any] = response.value as? [String:Any] {
                        self.processData(data: data, success: success, failure: failure)
                    } else {
                        let data:[Any] = response.value as! [Any]
                        self.processData(data: data, success: success, failure: failure)
                    }
                    break
                case .failure(let error):
                    let err:NSError = error as NSError
                    if(NetworkReachabilityManager.init()?.status == .notReachable) {
                        failure(err)
                        return;
                    } else {
                        failure(err)
                    }
                    break
                }
            }
            )
    }
    
    func postRequest(urlPath:String, headers: HTTPHeaders?, request:BaseRequest, encoding: ParameterEncoding ,success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let baseUrl = baseURL + urlPath
        let parameters = request.toJSON()
        APIManager.sessionManager.request(baseUrl, method: HTTPMethod.post, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<500)
            .validate(contentType: ["application/json"])
            .validate()
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    if let data:[String:Any] = response.value as? [String:Any] {
                        self.processData(data: data, success: success, failure: failure)
                    } else {
                        let data:[Any] = response.value as! [Any]
                        self.processData(data: data, success: success, failure: failure)
                    }
                    break
                case .failure(let error):
                    let err:NSError = error as NSError
                    failure(err)
                    break
                }
            }
            )
    }

    func patchRequest(urlPath:String, headers: HTTPHeaders?, request:BaseRequest, encoding: ParameterEncoding, success:@escaping HttpSuccess, failure:@escaping HttpFailure) {
        let baseUrl = baseURL + urlPath
        let parameters = request.toJSON()
        APIManager.sessionManager.request(baseUrl, method: HTTPMethod.patch, parameters: parameters ?? nil, encoding: encoding)
            .validate(statusCode: 200..<500)
            .validate(contentType: ["application/json"])
            .validate()
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    let data:[String:Any] = response.value as! [String:Any]
                    self.processData(data: data, success: success, failure: failure)
                    break
                case .failure(let error):
                    let err:NSError = error as NSError
                    if(NetworkReachabilityManager.init()?.status == .notReachable) {
                        failure(err)
                        return;
                    } else {
                        failure(err)
                    }
                    break
                }
            }
        )
    }
}

enum NetworkError: Int {
    case HttpRequestFailed = -1000, UrlResourceFailed = -2000
}

struct Messages {
    static let anErrorOccured = "An error occured"
    static let somethingWentWrong = "Something went wrong, try again later."
    static let networkOfflineError = "The Internet connection appears to be offline"
}
