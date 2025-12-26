//
//  APILogger.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

extension APIClient {
    func log(_ data: Data?, _ response: URLResponse?) {
        #if DEBUG
            guard let data = data, let jsonAsString = String(data: data, encoding: .utf8) else { return }
            let url = response?.url?.absoluteString ?? ""
            print("⬇️ ⬇️ ⬇️ Request:  -> \(url) \nResponse: -> \(jsonAsString)\n⬆️ ⬆️ ⬆️")
        #endif
    }
}
