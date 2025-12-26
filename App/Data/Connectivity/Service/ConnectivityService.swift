//
//  ConnectivityService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine
import Network

final class ConnectivityService: PConnectivityService {

    let connectivityStatus = CurrentValueSubject<Bool, Never>(true)

    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "ConnectivityChecker")

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.connectivityStatus.send(path.status == .satisfied)
        }
        networkMonitor.start(queue: workerQueue)
    }
}
