//
//  IKSearchBarExtension.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

extension UISearchBar {

    static func make() -> IKSearchBarView {

        var searchConfig = IKSearchBarViewContent()
        searchConfig.background = UIColor.appMainColor()
        searchConfig.fieldBackground = UIColor.RGB(r: 142, g: 142, b: 147, a: 0.14)
        searchConfig.cancelImage = IKInterfaceImageProvider.getImage("clear")

        let searchBar = IKSearchBarView(searchBarViewContent: searchConfig)
        return searchBar
    }
}
