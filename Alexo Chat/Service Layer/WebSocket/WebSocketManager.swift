//
//  WebSocketManager.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import Starscream

protocol WebSocketEventsDelegate: class {
    func newMessage(payload: MessagePayload)
}

class WebSocketManager {

    private var environmet: Environmet
    private var socket: WebSocket?
    weak var eventDelegate: WebSocketEventsDelegate?

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
        case .production: return "ws://127.0.0.1:8080/ws"
        case .local: return "ws://127.0.0.1:8080/ws"
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
        return UserDefaults.standard.string(forKey: DefaultsKeys.bearer_token)
    }
}

extension WebSocketManager {

    func sendTyping(roomId: String, action: OutgoingTypingPayload.Action) {
        guard let socket = self.socket, socket.isConnected else { return }
        let typingEvent = OutgoingTypingPayload(roomId: roomId, action: action)
        let wsEvent = WSEvent(event: WSEventType.typing.rawValue, payload: typingEvent)
        do {
            let jsonData = try JSONEncoder().encode(wsEvent)
            socket.write(data: jsonData)
        } catch {
            print(error.localizedDescription)
        }
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
                print(event)
            case .joinedRoom:
                let event = try decoder.decode(WSEvent<JoinedRoomPayload>.self, from: data)
                print(event)
            case .leftRoom:
                let event = try decoder.decode(WSEvent<LeftRoomPayload>.self, from: data)
                print(event)
            case .roomMemberAdded:
                let event = try decoder.decode(WSEvent<RoomMemberAddedPayload>.self, from: data)
                print(event)
            case .message:
                let event = try decoder.decode(WSEvent<MessagePayload>.self, from: data)
                guard let payload = event.payload else { return }
                self.eventDelegate?.newMessage(payload: payload)
            case .messageDeleted:
                let event = try decoder.decode(WSEvent<MessageDeletedPayload>.self, from: data)
                print(event)
            case .messageEdited:
                let event = try decoder.decode(WSEvent<MessageEditedPayload>.self, from: data)
                print(event)
            case .roomCreated:
                let event = try decoder.decode(WSEvent<RoomCreatedPayload>.self, from: data)
                print(event)
            case .roomDeleted:
                let event = try decoder.decode(WSEvent<RoomDeletedPayload>.self, from: data)
                print(event)
            case .typing:
                let event = try decoder.decode(WSEvent<TypingPayload>.self, from: data)
                print(event)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}
