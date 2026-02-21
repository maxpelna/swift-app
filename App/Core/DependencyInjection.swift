//
//  DependencyInjection.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

// MARK: - Protocols

protocol APIClientInjectable {
    var apiClient: PAPIClient { get }
}

extension APIClientInjectable {
    var apiClient: PAPIClient {
        DIContainer.shared.apiClient
    }
}

protocol CharactersServiceInjectable {
    var charactersService: PCharactersService { get }
}

extension CharactersServiceInjectable {
    var charactersService: PCharactersService {
        DIContainer.shared.charactersService
    }
}

protocol ConnectivityServiceInjectable {
    var connectivityService: PConnectivityService { get }
}

extension ConnectivityServiceInjectable {
    var connectivityService: PConnectivityService {
        DIContainer.shared.connectivityService
    }
}

protocol UserStatsServiceInjectable {
    var userStatsService: PUserStatsService { get }
}

extension UserStatsServiceInjectable {
    var userStatsService: PUserStatsService {
        DIContainer.shared.userStatsService
    }
}

protocol AnalyticsServiceInjectable {
    var analyticsService: PAnalyticsService { get }
}

extension AnalyticsServiceInjectable {
    var analyticsService: PAnalyticsService {
        DIContainer.shared.analyticsService
    }
}

protocol KeychainServiceInjectable {
    var keychainService: PKeychainService { get }
}

extension KeychainServiceInjectable {
    var keychainService: PKeychainService {
        DIContainer.shared.keychainService
    }
}

// MARK: - DIContainer

@MainActor
final class DIContainer {
    static let shared = DIContainer()

    lazy var apiClient: PAPIClient = {
        APIClient()
    }()

    lazy var charactersService: PCharactersService = {
        CharactersService(apiClient: apiClient)
    }()

    lazy var connectivityService: PConnectivityService = {
        ConnectivityService()
    }()

    lazy var userStatsService: PUserStatsService = {
        UserStatsService()
    }()

    lazy var analyticsService: PAnalyticsService = {
        AnalyticsService()
    }()

    lazy var keychainService: PKeychainService = {
        KeychainService()
    }()

    private init() {}

    init(
        apiClient: PAPIClient,
        charactersService: PCharactersService,
        connectivityService: PConnectivityService,
        userStatsService: PUserStatsService,
        analyticsService: PAnalyticsService,
        keychainService: PKeychainService
    ) {
        self.apiClient = apiClient
        self.charactersService = charactersService
        self.connectivityService = connectivityService
        self.userStatsService = userStatsService
        self.analyticsService = analyticsService
        self.keychainService = keychainService
    }
}
