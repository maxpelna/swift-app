//
//  PConnectivityService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine

protocol PConnectivityService {
    var connectivityStatus: CurrentValueSubject<Bool, Never> { get }
}
