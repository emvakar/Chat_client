//
//  IKTableControllerProtocols+ErrorView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - FooterErrorView->Table
public protocol IKViewToTableProtocol: class {
    func fetchNextPageFromView(_ view: IKBaseFooterView)
    func footerViewDidChangeFrame(_ view: IKBaseFooterView)
}

// MARK: - Table->FooterErrorView
public protocol IKTableToViewProtocol: class {
    func displayActivity(_ inProgress: Bool)
    func getViewHeight() -> CGFloat
}
