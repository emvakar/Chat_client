//
//  IKBaseSegmentedViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

open class IKBaseSegmentedViewController: IKBaseViewController {

    private var segmentedControl = UISegmentedControl()
    private var viewContent = UIView()

    public weak var currentVC: UIViewController?
    public var slaveViewControllers: [UIViewController]?

    public var mainAppColor: UIColor

    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
    }

    // MARK: - Init
    public init(mainAppColor: UIColor) {
        self.mainAppColor = mainAppColor

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func segmentAction(_ sender: UISegmentedControl) {
        self.didChangeSelection(selectedIndex: sender.selectedSegmentIndex)
    }

    // MARK: - Private
    private func createUI() {
        //ui
        self.view.backgroundColor = mainAppColor
        self.segmentedControl = IKAppearanceUI.segmentControlUI(items: [], selector: #selector(self.segmentAction(_:)), target: self, backgroundColor: mainAppColor)
        self.viewContent.backgroundColor = ThemeManager.currentTheme().tableBackground
        self.viewContent.frame = self.view.frame
        self.viewContent.clipsToBounds = true

        //add
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.viewContent)

        //Constraints
        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeArea.top).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }

        self.viewContent.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeArea.bottom)
        }
    }

    // MARK: - Public
    public func setSegmentItems(items: [UIViewController]) {
        self.segmentedControl.removeAllSegments()
        self.children.forEach { (childViewController) in
            childViewController.willMove(toParent: nil)
            childViewController.removeFromParent()
            childViewController.didMove(toParent: nil)
        }
        self.currentVC?.view.removeFromSuperview()

        var counter: Int = 0
        items.forEach { (item) in
            self.segmentedControl.insertSegment(withTitle: item.title, at: counter, animated: false)

            item.willMove(toParent: self)
            self.addChild(item)
            item.didMove(toParent: self)

            counter += 1
        }

        for i in 0..<self.segmentedControl.numberOfSegments {
            let view: UIView = self.segmentedControl.subviews[i]
            view.accessibilityLabel = "tabItem\(i)"
        }

        self.slaveViewControllers = items
        if  !items.isEmpty {
            self.segmentedControl.selectedSegmentIndex = 0
            self.didChangeSelection(selectedIndex: self.segmentedControl.selectedSegmentIndex)
        }
    }

    public func selectViewController(_ viewController: UIViewController) {
        if self.currentVC == viewController {
            return
        }
        self.segmentedControl.selectedSegmentIndex = (self.slaveViewControllers?.index(of: viewController))!
    }

    public func didChangeSelection(selectedIndex: Int) {
        let targetVC = self.slaveViewControllers![selectedIndex]
        if self.currentVC == targetVC {
            return
        }

        let currentVC = self.currentVC
        self.currentVC = targetVC

        self.viewContent.addSubview(targetVC.view)
        targetVC.view.frame = self.viewContent.bounds
        targetVC.viewDidAppear(false)

        currentVC?.viewWillDisappear(false)
        currentVC?.view.removeFromSuperview()
    }
}
