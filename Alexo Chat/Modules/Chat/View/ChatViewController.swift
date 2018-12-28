//
//  ChatViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 28/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit
import MessageKit
import MessageInputBar

class ChatViewController: MessagesViewController {

    var presenter: ChatPresenterProtocol!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var messageList: [MessageModel] = []

    let refreshControl = UIRefreshControl()

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let locale = Locale(identifier: Locale.current.identifier.replacingOccurrences(of: "en_RU", with: "ru_RU"))
        formatter.locale = locale
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.createUI()

    }

    private func createUI() {
        configureMessageCollectionView()
        configureMessageInputBar()
        loadFirstMessages()
    }

    func configureMessageCollectionView() {

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self

        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false

        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }

    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.tintColor = UIColor(hue: 0.58, saturation: 0.81, brightness: 0.95, alpha: 1.00)
    }

    func insertMessage(_ message: MessageModel) {
        messageList.append(message)

        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
                if self?.isLastSectionVisible() == true {
                    self?.messagesCollectionView.scrollToBottom(animated: true)
                }
            })
    }

    func isLastSectionVisible() -> Bool {

        guard !messageList.isEmpty else { return false }

        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)

        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

    private func loadFirstMessages() {
        self.presenter.fetchMessages()
    }

    func initWith(_ messages: [MessageModel]) {
        // TODO: - inserting from Cache
        self.messageList = messages
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom(animated: true)
    }

    func insertMore(_ messages: [MessageModel]) {
        self.messageList.insert(contentsOf: messages, at: 0)
        self.messagesCollectionView.reloadDataAndKeepOffset()
        self.refreshControl.endRefreshing()
    }

    @objc func loadMoreMessages() {
        self.presenter.fetchMessages()
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {

        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

extension ChatViewController: ChatViewProtocol { }

extension ChatViewController: MessagesDataSource {

    func currentSender() -> Sender {
        return self.presenter.getSender()
    }

}

// MARK: - MessageCellDelegate
extension ChatViewController: MessageCellDelegate {

    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }

    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }

    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }

    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }

}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {

    func didSelectAddress(_ addressComponents: [String: String]) {

    }

    func didSelectDate(_ date: Date) {

    }

    func didSelectPhoneNumber(_ phoneNumber: String) {

    }

    func didSelectURL(_ url: URL) {

    }

    func didSelectTransitInformation(_ transitInformation: [String: String]) {

    }

}

// MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate {

    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {

        for component in inputBar.inputTextView.components {

            if let str = component as? String {
                self.presenter.sendMessage(str)
                let message = MessageModel(text: str, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = MessageModel(image: img, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }

        }

        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom(animated: true)
    }

}
