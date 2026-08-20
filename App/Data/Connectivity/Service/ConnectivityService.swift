//
//  ConnectivityService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Network
import Observation

@Observable
final class ConnectivityService: PConnectivityService {
    private(set) var isConnected = true

    @ObservationIgnored private var monitorTask: Task<Void, Never>?

    init() {
        monitorTask = Task { [weak self] in
            for await path in NWPathMonitor() {
                self?.isConnected = path.status == .satisfied
            }
        }
    }

    deinit {
        monitorTask?.cancel()
    }
}
