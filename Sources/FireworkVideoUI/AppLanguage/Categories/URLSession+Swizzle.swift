//
//  URLSession+Swizzle.swift
//  
//  Created by linjie jiang on 2023/2/20.
//

import Foundation

private var FWHostList: [String] = [
    "api.firework.tv",
    "p2.fwpixel.com"
]

extension URLSession {
    static func swizzleURLSessionMethodsForAppLanguage() {
        // swiftlint:disable:next line_length
        let orginalSelector1 = #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask)
        let customSelector1 = #selector(URLSession.fw_dataTask(with:completionHandler:))
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: orginalSelector1,
            customSelector: customSelector1)
        // swiftlint:disable:next line_length
        let orginalSelector2 = #selector(URLSession.dataTask(with:) as (URLSession) -> (URLRequest) -> URLSessionDataTask)
        let customSelector2 = #selector(URLSession.fw_dataTask(with:))
        SwizzleUtil.swizzleSelector(
            cls: self,
            originalSelector: orginalSelector2,
            customSelector: customSelector2)
    }

    @objc func fw_dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return fw_dataTask(with: swizzleRequest(request), completionHandler: completionHandler)
    }

    @objc func fw_dataTask(with request: URLRequest) -> URLSessionDataTask {
        return fw_dataTask(with: swizzleRequest(request))
    }

    private func swizzleRequest(_ request: URLRequest) -> URLRequest {
        var host = ""
        #if compiler(>=5.7)
        if #available(iOS 16, *) {
            host = request.url?.host() ?? ""
        } else {
            host = request.url?.host ?? ""
        }
        #else
        host = request.url?.host ?? ""
        #endif

        if let language = AppLanguageManager.shared.appLanguage,
           let languageCode = AppLanguageManager.shared.appLanguageCode,
           FWHostList.contains(host) {
            var mutableRequest = request
            if language != languageCode {
                mutableRequest.setValue("\(language),\(languageCode);q=0.9", forHTTPHeaderField: "Accept-Language")
            } else {
                mutableRequest.setValue("\(language);q=0.9", forHTTPHeaderField: "Accept-Language")
            }
            return mutableRequest
        }

        return request
    }
}
