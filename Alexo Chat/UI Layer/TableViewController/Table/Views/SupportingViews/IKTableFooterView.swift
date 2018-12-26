//
//  IKTableFooterView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Footer fabric
public class IKTableFooterView: IKBaseContainerFooterView {

    // MARK: - Properties
    private var loader: IKBaseFooterView! = nil
    private var noContentCurtain: IKBaseFooterView! = nil
    private var errorCurtain: IKBaseFooterView! = nil
    private var pageLoaderErrorView: IKBaseFooterView! = nil

    // MARK: - Default init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init() {
        super.init(frame: .zero)

        self.loader = IKLoadingView()
        self.loader.delegate = self

        self.noContentCurtain = IKCurtainView(message: "Нет данных", backgroundColor: ThemeManager.currentTheme().tableBackground)
        self.noContentCurtain.delegate = self

        self.errorCurtain = IKCurtainView(message: "Ошибка загрузки данных", backgroundColor: ThemeManager.currentTheme().tableBackground)
        self.errorCurtain.delegate = self

        self.pageLoaderErrorView = IKPageLoaderErrorView()
        self.pageLoaderErrorView.delegate = self
    }

    // MARK: - IKTableToViewProtocol
    override public func displayActivity(_ inProgress: Bool) {
        inProgress ? self.startLoadingView() : self.stopLoadingView()
    }

    public override func displayState(_ contentState: IKTableFooterType) {
        for view in self.subviews {
            view.removeFromSuperview()
        }

        switch contentState {
        case .empty:         self.setEmptyView()
        case .loader:        self.setLoadingView()
        case .noContent:     self.setNoContentCurtainView()
        case .error:         self.setErrorCurtainView()
        case .nextPageError: self.setPageErrorFooterView()
        }

        self.delegate?.footerViewDidChangeFrame(self)
    }
}

// MARK: - IKViewToTableProtocol
extension IKTableFooterView: IKViewToTableProtocol {

    public func fetchNextPageFromView(_ view: IKBaseFooterView) {

        self.delegate?.fetchNextPageFromView(self)
    }

    public func footerViewDidChangeFrame(_ view: IKBaseFooterView) {

        self.delegate?.footerViewDidChangeFrame(self)
    }
}

// MARK: - Public methods
extension IKTableFooterView {

    //failed load page view
    private func setPageErrorFooterView() {
        if self.pageLoaderErrorView != nil {
            self.pageLoaderErrorView.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: self.pageLoaderErrorView.getViewHeight())
            self.frame = self.pageLoaderErrorView.frame
            self.addSubview(self.pageLoaderErrorView)
        }
    }

    //No content Error
    private func setNoContentCurtainView() {
        if self.noContentCurtain != nil {
            self.noContentCurtain.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: self.noContentCurtain.getViewHeight())
            self.frame = self.noContentCurtain.frame
            self.addSubview(self.noContentCurtain)
        }
    }

    //Error view
    private func setErrorCurtainView() {
        if self.errorCurtain != nil {
            self.errorCurtain.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: self.errorCurtain.getViewHeight())
            self.frame = self.errorCurtain.frame
            self.addSubview(self.errorCurtain)
        }
    }

    //Loader
    private func setLoadingView() {
        if self.loader != nil {
            self.loader.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: self.loader.getViewHeight())
            self.frame = self.loader.frame
            self.addSubview(self.loader)
        }
    }

    //Empty footer
    private func setEmptyView() {
        self.frame = .zero
        self.addSubview(UIView())
    }

    private func stopLoadingView() {
        self.noContentCurtain.displayActivity(false)
        self.errorCurtain.displayActivity(false)
        self.pageLoaderErrorView.displayActivity(false)
    }

    private func startLoadingView() {
        self.noContentCurtain.displayActivity(true)
        self.errorCurtain.displayActivity(true)
        self.pageLoaderErrorView.displayActivity(true)
    }
}
