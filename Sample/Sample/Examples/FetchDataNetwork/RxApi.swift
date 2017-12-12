//
//  rxApi.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/13/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias JObject = [String: Any]

final class RxApi {
    class func requestGet(url: URL, headers: [String: String]? = nil) -> Observable<([JObject])> {
        let response = Observable.from([url])
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                if let headers = headers {
                    for (key, value) in headers {
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
                return request
            }
            .flatMap { request -> Observable<(HTTPURLResponse, Data)> in // [1]
                return URLSession.shared.rx.response(request: request)
            }
            .shareReplay(1) // [2]
            .filter { response, _ in
                return 200..<300 ~= response.statusCode // [3]
            }
            .map { _, data -> [JObject] in
                // can save lastModified for next request at this point
                // let lastModified = response.allHeaderFields["Last-Modified"] as? String
                // UserDefaults.standard.set(lastModified, forKey: "Last-Modified")

                // [4]
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let result = jsonObject as? [JObject] else {
                        return []
                }
                return result
            }
        return response

        /*  #### Explain the functions ####
         [1] Using flatMap to Wait for a Web Response
             One of the common applications of flatMap is to add some asynchronicity to a transformation chain
             flatMap allows you to send the web request and receive a response without the need of protocols and delegates
         
         [2] shared sequence, this way you prevent the observable from being re-created
         
         [3] filter will only let through responses having a status code between 200 and 300, which is all the success status codes
         
         [4] transforming the response data to an array of dictionaries
        */
    }
}
