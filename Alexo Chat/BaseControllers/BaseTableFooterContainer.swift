//
//  BaseTableFooterContainer.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22.09.2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - BaseTableFooterContainer
open class BaseTableFooterContainer: IKBaseContainerFooterView {

    // MARK: - Properties
    public var loader: IKBaseFooterView?
    public var noContentCurtain: IKBaseFooterView?
    public var errorCurtain: IKBaseFooterView?
    public var pageLoaderErrorView: IKBaseFooterView?

    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(noContentMessage: String, errorMessage: String) {
        let errorView = IKCurtainView(message: errorMessage, backgroundColor: ThemeManager.currentTheme().tableBackground)
        let noContentView = IKCurtainView(message: noContentMessage, backgroundColor: ThemeManager.currentTheme().tableBackground)
        self.init(noContentCurtain: noContentView, errorCurtain: errorView)
    }

    public init(loader: IKBaseFooterView? = IKLoadingView(), noContentCurtain: IKBaseFooterView? = nil, errorCurtain: IKBaseFooterView? = nil, pageLoaderErrorView: IKBaseFooterView? = IKPageLoaderErrorView()) {
        super.init(frame: .zero)

        self.loader = loader
        self.loader?.delegate = self

        self.noContentCurtain = noContentCurtain
        self.noContentCurtain?.delegate = self

        self.errorCurtain = errorCurtain
        self.errorCurtain?.delegate = self

        self.pageLoaderErrorView = pageLoaderErrorView
        self.pageLoaderErrorView?.delegate = self

        self.backgroundColor = ThemeManager.currentTheme().tableBackground
    }

    // MARK: - Overrided method
    override open func displayActivity(_ inProgress: Bool) {
        inProgress ? self.startLoadingView() : self.stopLoadingView()
    }

    override open func displayState(_ contentState: IKTableFooterType) {
        DispatchQueue.main.async {
            for view in self.subviews {
                view.removeFromSuperview()
            }

            switch contentState {
            case .empty: self.setEmptyView()
            case .loader: self.setLoadingView()
            case .noContent: self.setNoContentCurtainView()
            case .error: self.setErrorCurtainView()
            case .nextPageError: self.setPageErrorFooterView()
            }

            self.delegate?.footerViewDidChangeFrame(self)
        }
    }
}

// MARK: - IKViewToTableProtocol
extension BaseTableFooterContainer: IKViewToTableProtocol {

    public func fetchNextPageFromView(_ view: IKBaseFooterView) {
        self.delegate?.fetchNextPageFromView(self)
    }

    public func footerViewDidChangeFrame(_ view: IKBaseFooterView) {
        self.delegate?.footerViewDidChangeFrame(self)
    }
}

// MARK: - Public methods
extension BaseTableFooterContainer {

    public func updateNoContentMessage(_ message: String?) {
        if let noContentView = self.noContentCurtain as? IKCurtainView {
            noContentView.updateMessage(message: message)
        }
    }

    public func updateErrorMessage(_ message: String?) {
        if let errorView = self.errorCurtain as? IKCurtainView {
            errorView.updateMessage(message: message)
        }
    }
}

// MARK: - Private methods
extension BaseTableFooterContainer {

    //failed load page view
    private func setPageErrorFooterView() {
        if let loader = self.pageLoaderErrorView {
            loader.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: loader.getViewHeight())
            self.frame = loader.frame
            self.addSubview(loader)
        }
    }

    //No content Error
    private func setNoContentCurtainView() {
        if let noContent = self.noContentCurtain {
            noContent.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: noContent.getViewHeight())
            self.frame = noContent.frame
            self.addSubview(noContent)
        }
    }

    //Error view
    private func setErrorCurtainView() {
        if let errorView = self.errorCurtain {
            errorView.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: errorView.getViewHeight())
            self.frame = errorView.frame
            self.addSubview(errorView)
        }
    }

    //Loader
    private func setLoadingView() {
        if let loader = self.loader {
            loader.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: loader.getViewHeight())
            self.frame = loader.frame
            self.addSubview(loader)
        }
    }

    //Empty footer
    private func setEmptyView() {
        self.frame = .zero
        self.addSubview(UIView())
    }

    private func stopLoadingView() {
        self.noContentCurtain?.displayActivity(false)
        self.errorCurtain?.displayActivity(false)
        self.pageLoaderErrorView?.displayActivity(false)
    }

    private func startLoadingView() {
        self.noContentCurtain?.displayActivity(true)
        self.errorCurtain?.displayActivity(true)
        self.pageLoaderErrorView?.displayActivity(true)
    }
}
