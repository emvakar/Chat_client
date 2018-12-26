//
//  IKTableVCProtocol.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Table->Parent VC
protocol IKTableControllerDelegate: UITableViewDelegate, UITableViewDataSource {
    func pullToRefresh(tableController: IKTableController)
    func fetchNextPage(tableController: IKTableController)
    func closeFilter(tableController: IKTableController, completion: (_ result: Bool) -> Void)
}

// MARK: - Table->ViewController
protocol IKTableToViewControllerProtocol: class {
    func getSearchBarView() -> (searchBar: UISearchBar, viewForLayout: UIView)
    func getToolbarView() -> (toolbar: UIToolbar, viewForLayout: IKTableToToolbarProtocol)
    func getFooterView() -> IKBaseContainerFooterView
}

// MARK: - Default realization IKTableControllerDelegate
extension IKTableControllerDelegate {
    func pullToRefresh(tableController: IKTableController) { }

    func fetchNextPage(tableController: IKTableController) { }

    func closeFilter(tableController: IKTableController, completion: (_ result: Bool) -> Void) {
        completion(false)
    }
}

// MARK: - Default footer IKTableToViewControllerProtocol
extension IKTableToViewControllerProtocol {

    func getSearchBarView() -> (searchBar: UISearchBar, viewForLayout: UIView) {
        let searchBar = UISearchBar.make()
        return (searchBar, searchBar)
    }

    //Default IKTableFooterContainer
    func getFooterView() -> IKBaseContainerFooterView {
        return IKTableFooterView()
    }

    //Default IKTableToolBar
    func getToolbarView() -> (toolbar: UIToolbar, viewForLayout: IKTableToToolbarProtocol) {
        let toolbarView = IKToolbarView()
        return (toolbarView.filterToolbar, toolbarView)
    }
}
