//
//  MockPConnectivityService.swift
//  swift-appTests
//

import Combine
@testable import swift_app

final class MockPConnectivityService: PConnectivityService {
    private let subject: CurrentValueSubject<Bool, Never>

    var connectivityStatus: AnyPublisher<Bool, Never> { subject.eraseToAnyPublisher() }

    init(initialValue: Bool = true) {
        subject = CurrentValueSubject(initialValue)
    }

    func send(_ isConnected: Bool) {
        subject.send(isConnected)
    }
}
