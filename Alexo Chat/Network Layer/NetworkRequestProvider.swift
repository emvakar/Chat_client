//
//  NetworkRequestProvider.swift
//  Parlist
//
//  Created by Emil Karimov on 31.08.2018.
//  Copyright © 2018 ESKARIA Corporation. All rights reserved.
//

import Foundation

protocol NetworkWebSocketRequestProtocol {
    func connect()
    func disconnect()
}

protocol NetworkRequestProviderProtocol: NetworkWebSocketRequestProtocol { }

class NetworkRequestProvider: NetworkRequestProviderProtocol, NetworkMessangerRequestProtocol {

    let networkWrapper: NetworkRequestWrapperProtocol
    let tokenRefresher: AuthTokenRefresherProtocol?
    let accountManager: AccountManager
    let websocketManager: WebSocketManager

    init(networkWrapper: NetworkRequestWrapperProtocol, tokenRefresher: AuthTokenRefresherProtocol?, accountManager: AccountManager, websocketManager: WebSocketManager) {
        self.networkWrapper = networkWrapper
        self.tokenRefresher = tokenRefresher
        self.accountManager = accountManager
        self.websocketManager = websocketManager
    }

    internal func runRequest(_ request: NetworkRequest, progressResult: ((Double) -> Void)?, completion: @escaping(_ statusCode: Int, _ requestData: Data?, _ error: NetworkError?) -> Void) {

        let baseUrl = self.accountManager.getBaseUrl()
        let tokenString = "Basic " + accountManager.getUserToken()
        let bearerToken: String? = accountManager.getBearerToken().isEmpty ? nil : "Bearer " + accountManager.getBearerToken()

        self.networkWrapper.runRequest(request, baseURL: baseUrl, authToken: tokenString, bearerToken: bearerToken, progressResult: progressResult) { [weak self] (statusCode, data, error) in
            guard let s = self else { return }

            guard let error = error else {
                completion(statusCode, data, nil)
                return
            }

            switch error.type {
            case .unauthorized:
                ///----------------TO-DO: нужен ли нам в реквесте параметр authorized???
                if let tokenRefresher = s.tokenRefresher {
                    tokenRefresher.refreshAuthToken(completion: { (error) in
                        if let error = error {
                            completion(statusCode, data, error)
                            return
                        }

                        s.networkWrapper.runRequest(request, baseURL: baseUrl, authToken: tokenString, bearerToken: bearerToken, progressResult: progressResult, completion: completion)
                    })
                    return
                }
            default:
                completion(statusCode, data, error)
            }
        }
    }
}

extension NetworkRequestProvider {

    func connect() {
        self.websocketManager.connect()
    }

    func disconnect() {
        self.websocketManager.disconnect()
    }
}
