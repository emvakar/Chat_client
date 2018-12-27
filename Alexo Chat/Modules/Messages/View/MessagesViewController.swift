//
//  MessagesViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit
import MessengerKit

class MessagesViewController: MSGMessengerViewController {

    var presenter: MessagesPresenterProtocol!

    lazy var messages: [[MSGMessage]] = []

    override var style: MSGMessengerStyle {
        var style = MessengerKit.Styles.iMessage
        style.inputPlaceholder = "Сообщение"
        return style
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.presenter.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    }

    private func createUI() {

    }
}

// MARK: - Privates
extension MessagesViewController {
    @objc private func inviteButtonAction(_ sender: UIBarButtonItem) {
        // TODO: - сделать проброс пользователя которого мы инвайтим
//        self.presenter.inviteTapped(userId: <#T##String#>)
    }
}

// MARK: - MessagesViewProtocol
extension MessagesViewController: MessagesViewProtocol {

    func setInviteButton() {
        let button = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(inviteButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = button
    }

    func startTyping(users: [MSGUser]) {

        self.setUsersTyping(users)
    }

    func stopTyping() {

        self.setUsersTyping([])
    }

    // MARK: - User is typing
    override func inputViewDidChange(inputView: MSGInputView) {
        if inputView.message.count < 1 {
            self.presenter.typingStart()
        }
    }

    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {

        let credentials = self.presenter.getUserNackname()
        let user = User(id: UUID().uuidString, displayName: credentials)
        let messageBody: MSGMessageBody = .text(inputView.message)
        let message = MSGMessage(id: UUID().uuidString, body: messageBody, user: user, sentAt: Date())

        self.insert(message)
        inputView.resignFirstResponder()
        self.presenter.sendMessage(message)
    }

    override func insert(_ message: MSGMessage) {

        collectionView.performBatchUpdates({
            if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                self.messages[self.messages.count - 1].append(message)

                let sectionIndex = self.messages.count - 1
                let itemIndex = self.messages[sectionIndex].count - 1
                self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])

            } else {
                self.messages.append([message])
                let sectionIndex = self.messages.count - 1
                self.collectionView.insertSections([sectionIndex])
            }
        }, completion: { (_) in
                self.collectionView.scrollToBottom(animated: true)
                self.collectionView.layoutTypingLabelIfNeeded()
            })

    }

    override func insert(_ messages: [MSGMessage], callback: (() -> Void)? = nil) {

        collectionView.performBatchUpdates({
            for message in messages {
                if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                    self.messages[self.messages.count - 1].append(message)

                    let sectionIndex = self.messages.count - 1
                    let itemIndex = self.messages[sectionIndex].count - 1
                    self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])

                } else {
                    self.messages.append([message])
                    let sectionIndex = self.messages.count - 1
                    self.collectionView.insertSections([sectionIndex])
                }
            }
        }, completion: { (_) in
                self.collectionView.scrollToBottom(animated: true)
                self.collectionView.layoutTypingLabelIfNeeded()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    callback?()
                }
            })

    }

    func insertItems(_ models: [MSGMessage]) {
        self.insert(models)
    }
}

// MARK: - MSGDataSource
extension MessagesViewController: MSGDataSource {

    func numberOfSections() -> Int {
        return messages.count
    }

    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }

    func message(for indexPath: IndexPath) -> MSGMessage {
        let message = self.messages[indexPath.section][indexPath.item]
        return message
    }

    func footerTitle(for section: Int) -> String? {
        if self.messages.count > section {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let date = self.messages[section].last?.sentAt {
                let dateString = dateFormatter.string(from: date)
                return dateString
            }
        }
        return nil
    }

    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }
}

// MARK: - MSGDelegate
extension MessagesViewController: MSGDelegate {

    func linkTapped(url: URL) {
        print("Link tapped:", url)
    }

    func avatarTapped(for user: MSGUser) {
        print("Avatar tapped:", user)
    }

    func tapReceived(for message: MSGMessage) {
        print("Tapped: ", message)
    }

    func longPressReceieved(for message: MSGMessage) {
        print("Long press:", message)
    }

    func shouldDisplaySafari(for url: URL) -> Bool {
        return true
    }

    func shouldOpen(url: URL) -> Bool {
        return true
    }

}
