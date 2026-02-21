//
//  PErrorReportingService.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Foundation

protocol PErrorReportingService {
    func recordNonFatalError(_ error: Error)
}
