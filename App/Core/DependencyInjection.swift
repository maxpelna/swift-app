//
//  DependencyInjection.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

// MARK: - Protocols

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

// MARK: - DIContainer

private final class DIContainer {
    static let shared = DIContainer()

    lazy var apiClient: APIClient = {
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
}
