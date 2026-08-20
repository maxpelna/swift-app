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

protocol KeychainServiceInjectable {
    var keychainService: PKeychainService { get }
}

extension KeychainServiceInjectable {
    var keychainService: PKeychainService {
        DIContainer.shared.keychainService
    }
}

protocol ErrorReportingServiceInjectable {
    var errorReportingService: PErrorReportingService { get }
}

extension ErrorReportingServiceInjectable {
    var errorReportingService: PErrorReportingService {
        DIContainer.shared.errorReportingService
    }
}

// MARK: - DIContainer

final class DIContainer {
    static let shared = DIContainer()

    lazy var charactersService: PCharactersService = {
        let apiClient = APIClient()
        return CharactersService(apiClient: apiClient)
    }()

    lazy var connectivityService: PConnectivityService = {
        ConnectivityService()
    }()

    lazy var userStatsService: PUserStatsService = {
        UserStatsService(defaults: UserDefaults.standard)
    }()

    lazy var analyticsService: PAnalyticsService = {
        AnalyticsService()
    }()

    lazy var keychainService: PKeychainService = {
        KeychainService()
    }()

    lazy var errorReportingService: PErrorReportingService = {
        ErrorReportingService()
    }()

    private init() {}
}
