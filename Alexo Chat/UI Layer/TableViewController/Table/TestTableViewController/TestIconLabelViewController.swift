//
//  TestIconLabelViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

class TestIconLabelViewController: IKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Лейбл с иконкой"
        self.createUI()
    }

    func createUI() {
        //self.view.backgroundColor = UIColor.mainAppColor()
        let iconLabel = IKIconLabelView(icon: #imageLiteral(resourceName: "serverIcon"), text: "Пример текста c изображением", insets: .zero)
        iconLabel.label.textColor = UIColor.white
        self.view.addSubview(iconLabel)

        iconLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
    }

}
