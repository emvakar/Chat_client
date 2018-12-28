//
//  CustomMessagesFlowLayout.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 28/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import MessageKit

open class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {

    open lazy var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)

    open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath)
    }

    open override func messageSizeCalculators() -> [MessageSizeCalculator] {
        var superCalculators = super.messageSizeCalculators()

        superCalculators.append(customMessageSizeCalculator)
        return superCalculators
    }
}

open class CustomMessageSizeCalculator: MessageSizeCalculator {

    public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }

    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = layout else { return .zero }
        let collectionViewWidth = layout.collectionView?.bounds.width ?? 0
        let contentInset = layout.collectionView?.contentInset ?? .zero
        let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
        return CGSize(width: collectionViewWidth - inset, height: 44)
    }

}
