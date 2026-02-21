//
//  ConnectivityService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine
import Network

final class ConnectivityService: PConnectivityService {
    var connectivityStatus: AnyPublisher<Bool, Never> { _connectivityStatus.eraseToAnyPublisher() }

    private let _connectivityStatus = CurrentValueSubject<Bool, Never>(true)
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "ConnectivityChecker")

    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                self?._connectivityStatus.send(path.status == .satisfied)
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
