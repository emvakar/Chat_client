//
//  WebSocketManager.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import Starscream

class WebSocketManager {

    private var environmet: Environmet
    private var socket: WebSocket?
    private var isConnected: Bool = false {
        didSet {
            if !self.isConnected {
                self.socket = nil
            }
        }
    }

    init(environmet: Environmet) {
        self.environmet = environmet
    }
}

extension WebSocketManager {

    /// Websocket url
    func getBaseUrl() -> String {
        switch environmet {
        case .develop: return "ws://192.168.100.2:8080/ws"
        case .production: return "ws://192.168.100.2:8080/ws"
        case .local: return "ws://localhost:8080/ws"
        }
    }

    func connect() {

        guard
            let url = URL(string: self.getBaseUrl()),
            let token = self.getBearerToken(),
            !token.isEmpty,
            !isConnected,
            self.socket == nil
            else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        self.socket = WebSocket(request: request)
        self.socket?.delegate = self
        self.socket?.connect()

    }

    func disconnect() {
        guard let socket = socket else { return }
        socket.disconnect()
    }
}

// MARK: - Private
extension WebSocketManager {
    private func getBearerToken() -> String? {
        return UserDefaults.standard.string(forKey: DefaultsKeys.user_token)
    }
}

extension WebSocketManager: WebSocketDelegate {

    func websocketDidConnect(socket: WebSocketClient) {
        print("WS - websocket is connected")
        self.isConnected = true
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("WS - websocket is disconnected")
        self.isConnected = false
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("WS - got some text: \(text)")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        do {
            let decoder = JSONDecoder()
            let prototype = try decoder.decode(WSEventPrototype.self, from: data)
            guard let eventType = WSEventType(rawValue: prototype.event) else { return }

            switch eventType {
            case .addedToRoom:
                let event = try decoder.decode(WSEvent<AddedToRoomPayload>.self, from: data)

            case .joinedRoom:
                let event = try decoder.decode(WSEvent<JoinedRoomPayload>.self, from: data)

            case .leftRoom:
                let event = try decoder.decode(WSEvent<LeftRoomPayload>.self, from: data)

            case .roomMemberAdded:
                let event = try decoder.decode(WSEvent<RoomMemberAddedPayload>.self, from: data)

            case .message:
                let event = try decoder.decode(WSEvent<MessagePayload>.self, from: data)

            case .messageDeleted:
                let event = try decoder.decode(WSEvent<MessageDeletedPayload>.self, from: data)

            case .messageEdited:
                let event = try decoder.decode(WSEvent<MessageEditedPayload>.self, from: data)

            case .roomCreated:
                let event = try decoder.decode(WSEvent<RoomCreatedPayload>.self, from: data)

            case .roomDeleted:
                let event = try decoder.decode(WSEvent<RoomDeletedPayload>.self, from: data)

            case .typing:
                let event = try decoder.decode(WSEvent<TypingPayload>.self, from: data)

            }
        } catch {
            print(error.localizedDescription)
        }
    }

}