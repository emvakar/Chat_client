//
//  IKFullScreenAlertConfiguration.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - IKFullScreenAlertConfiguration
public struct IKFullScreenAlertConfiguration {
    public var title: String! = nil
    public var message: String?
    public var mainImage: UIImage?
    public var detailImage: UIImage?
    public var tapImage: UIImage?
    public var tapGestureClosure : (() -> Void)?
    public var backgroundColor: UIColor? = .clear

    public init(title: String, message: String?, mainImage: UIImage?, detailImage: UIImage?, tapImage: UIImage?, tapGestureClosure: (() -> Void)?, backgroundColor: UIColor?) {
        self.title = title
        self.message = message
        self.mainImage = mainImage
        self.tapImage = tapImage
        self.tapGestureClosure = tapGestureClosure
        self.backgroundColor = backgroundColor
        self.detailImage = detailImage
    }
}
