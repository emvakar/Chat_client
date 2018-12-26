//
//  SearchBarView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

struct IKSearchBarViewContent {
    var placeholderText: String = "Поиск"
    var searchImage: UIImage?
    var cancelImage: UIImage?
    var cancelText: String = "Отмена"
    var fieldBackground: UIColor = UIColor.white
    var background: UIColor = UIColor.white

    init() { }
}

class IKSearchBarView: UISearchBar {

    private var searchBarViewContent: IKSearchBarViewContent

    init(searchBarViewContent: IKSearchBarViewContent) {
        self.searchBarViewContent = searchBarViewContent
        super.init(frame: .zero)

        self.tintColor = UIColor.white
        self.backgroundImage = UIImage()
        self.placeholder = searchBarViewContent.placeholderText
        self.clipsToBounds = true

        self.layer.borderColor = searchBarViewContent.background.cgColor
        self.layer.cornerRadius = 0
        self.searchBarStyle = UISearchBar.Style.prominent

        self.setImage(searchBarViewContent.searchImage, for: .search, state: .normal)
        self.setImage(searchBarViewContent.cancelImage, for: .clear, state: .normal)

        self.barTintColor = searchBarViewContent.background
        self.backgroundColor = searchBarViewContent.background

        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)

        let barButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        barButtonAppearance.title = searchBarViewContent.cancelText
        barButtonAppearance.tintColor = UIColor.white

        let searchPlaceholderLabelApperance = UILabel.appearance(whenContainedInInstancesOf: [UITextField.self, UISearchBar.self])
        searchPlaceholderLabelApperance.textColor = UIColor.white
        searchPlaceholderLabelApperance.alpha = 0.5

        let searchBarIconAppearance = UIImageView.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchBarIconAppearance.tintColor = UIColor.white

        self.subviews[0].subviews.compactMap { $0 as? UITextField }.first?.tintColor = UIColor.white
        if let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField {

            textFieldInsideSearchBar.textColor = UIColor.white
            textFieldInsideSearchBar.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            textFieldInsideSearchBar.backgroundColor = searchBarViewContent.fieldBackground
            textFieldInsideSearchBar.textAlignment = .left

            if let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = UIColor.white.withAlphaComponent(0.5)
            }
            if let clearButton = textFieldInsideSearchBar.value(forKey: "_clearButton") as? UIButton {
                let image = searchBarViewContent.cancelImage
                clearButton.setImage(image, for: .normal)
                clearButton.tintColor = .white
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
