//
//  IKBaseTableCell.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public protocol RedrawCellDelegate: class {
    func cellRequestsLayoutUpdate(cell: UITableViewCell)
}

open class IKBaseTableCell: UITableViewCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func getClientInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 11, right: 36)
    }

    public func getDefaultInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 10)
    }

    public var disclosureButton: UIButton! = nil

    public func makeDisclosureButton() {

        let disclosureButton = UIButton(type: .custom)
        self.contentView.addSubview(disclosureButton)
        disclosureButton.contentVerticalAlignment = .top
        disclosureButton.contentHorizontalAlignment = .right
        disclosureButton.imageEdgeInsets = UIEdgeInsets(top: 13, left: -15, bottom: -13, right: 15)
        disclosureButton.setImage(UIImage(named: "DisclosureIndicator"), for: .normal)
        disclosureButton.setImage(UIImage(named: "DisclosureIndicator"), for: .selected)
        disclosureButton.addTarget(self, action: #selector(toggleDisclosureView), for: .touchUpInside)
        disclosureButton.snp.makeConstraints {

            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(60)
        }
        self.disclosureButton = disclosureButton
    }

    @objc open func toggleDisclosureView(sender: UIButton) {
        fatalError("not implemented toggleDisclosureView:")
    }
}
