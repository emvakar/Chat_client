//
//  ChatPresenter.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 28/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import MessageKit
import NotificationBannerSwift

class ChatPresenter: BasePresenter {

    weak var view: ChatViewProtocol?
    private var wireFrame: ChatWireFrameProtocol
    private var interactor: ChatInteractorProtocol
    private var accountManager: AccountManager
    private var wsManager: WebSocketManager
    private let room: CHATModelRoom
    private var offset: Int = 0
    private var limit: Int = 20
    private var typingBuffer: TypingBuffer = TypingBuffer.init(queue: DispatchQueue.main, delay: 2)
    private var isTyping: Bool = false

    init(view: ChatViewProtocol, wireFrame: ChatWireFrameProtocol, interactor: ChatInteractorProtocol, accountManager: AccountManager, wsManager: WebSocketManager, room: CHATModelRoom) {
        self.view = view
        self.interactor = interactor
        self.wireFrame = wireFrame
        self.accountManager = accountManager
        self.wsManager = wsManager
        self.room = room
    }
}

extension ChatPresenter: WebSocketEventsDelegate {
    func newMessage(payload: MessagePayload) {
        switch payload.type {
        case .group:
            if payload.room.id == self.room.id {
                self.interactor.fetchMessages(roomId: payload.room.id, offset: 0, limit: 1) { (apiModels, error) in

                    if let error = error {
                        print(error) // FIXME: - обработать ошибку
                    }

                    if let apiModels = apiModels?.sorted(by: { $0.createdAt < $1.createdAt }) {
                        apiModels.forEach {
                            let model = CHATModelMessage(from: $0).convert()
                            self.view?.insertMessage(model)
                        }
                    }
                }
            } else {
                // TODO: - Do anything with another group payload
            }
        case .direct:
            let label = UILabel.makeLabel(size: 13, weight: UIFont.Weight.regular, color: .white)
            label.text = Date().formatHHMM()
            label.textAlignment = .left
            let banner = NotificationBanner(title: payload.fromUser.nickname, subtitle: payload.text, leftView: label, style: BannerStyle.info)
            banner.show()
        }
    }
}

extension ChatPresenter: ChatPresenterProtocol {

    func viewDidLoad() {
        self.wsManager.connect()
        self.wsManager.eventDelegate = self
    }

    func getSender() -> Sender {
        return Sender(id: self.accountManager.getUserId(), displayName: self.accountManager.getUsername())
    }

    func fetchMessages() {
        self.interactor.fetchMessages(roomId: self.room.id, offset: self.offset, limit: self.limit) { (apiModels, error) in

            var messages = [MessageModel]()
            if let error = error {
                print(error) // FIXME: - обработать ошибку
            }

            if let apiModels = apiModels?.sorted(by: { $0.createdAt < $1.createdAt }) {
                apiModels.forEach {
                    let model = CHATModelMessage(from: $0).convert()
                    messages.append(model)
                }
            }
            if self.offset > 0 {
                self.view?.insertMore(messages)
            } else {
                self.view?.initWith(messages)
            }
            if !(messages.count < self.limit) {
                self.offset += self.limit
            }
        }
    }
    func sendMessage(_ messageText: String) {
        self.interactor.sendMessage(roomId: self.room.id, text: messageText) { (error) in
            if error != nil {
                print("handle Error")
            }
        }
    }

    func sendTyping(_ start: Bool) {
        if start {
            if !isTyping {
                self.isTyping = true
                self.interactor.startTyping(roomId: self.room.id)
            }
            typingBuffer.typing(typing: start) { (_) in
                self.interactor.stopTyping(roomId: self.room.id)
                self.isTyping = false
            }
        } else {
            self.interactor.stopTyping(roomId: self.room.id)
        }
    }
}
