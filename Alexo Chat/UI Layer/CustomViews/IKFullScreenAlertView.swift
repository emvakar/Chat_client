//
//  IKFullScreenAlertView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - IKFullScreenAlertView
@available(*, deprecated, message: "Use IKFullScreenAlertViewController class instead of IKFullScreenAlertView")
public class IKFullScreenAlertView: UIView {

    // MARK: - Proeprties
    private var title: String! = nil
    private var message: String?
    private var mainImageView: UIImageView?
    private var detailImageView: UIImageView?
    private var tapImage: UIImage?
    private var tapGestureClosure: (() -> Void)?

    // MARK: - Init
    public init() {
        super.init(frame: CGRect.zero)
    }

    convenience public init(configuration: IKFullScreenAlertConfiguration) {
        self.init()
        self.title = configuration.title
        self.message = configuration.message
        self.mainImageView = UIImageView.init(image: configuration.mainImage)
        self.detailImageView = UIImageView.init(image: configuration.detailImage)
        self.tapImage = configuration.tapImage
        self.backgroundColor = configuration.backgroundColor
        self.tapGestureClosure = configuration.tapGestureClosure
        let tapGsetureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBlock))
        self.addGestureRecognizer(tapGsetureRecognizer)
        self.createUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {

        //Top Label
        let labelTitle = UILabel.makeLabel(size: 20, weight: .semibold, color: .white)
        labelTitle.text = self.title
        labelTitle.textAlignment = .center
        labelTitle.textColor = UIColor.white

        //center image
        let mainPicture = self.mainImageView ?? UIView()
        mainPicture.contentMode = .scaleAspectFit

        //bottom label
        let descriptionLabel = UILabel.makeLabel(size: 15, weight: .semibold, color: .white)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = self.message
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor.white

        //bottom image for dissmiss
        let tapImageView = UIImageView(image: tapImage)
        tapImageView.contentMode = .scaleAspectFit

        self.addSubview(labelTitle)
        self.addSubview(mainPicture)
        self.addSubview(descriptionLabel)
        self.addSubview(tapImageView)

        labelTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-180)
            $0.centerX.equalToSuperview()
        }

        mainPicture.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-60)
        }

        if let detailImageView = self.detailImageView {
            self.addSubview(detailImageView)
            detailImageView.contentMode = .scaleAspectFit
            detailImageView.snp.makeConstraints {
                $0.left.equalTo(mainPicture.snp.centerX)
                $0.centerY.equalTo(mainPicture.snp.bottom).offset(5)
                $0.height.equalTo(55)
                $0.width.equalTo(55)
            }
        }

        descriptionLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(75)
        }

        tapImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-25)
        }
    }

    // MARK: - Public methods
    public func hideView() {
        UIView.setAnimationsEnabled(true)

        UIView.animate(withDuration: 0.3, animations: { self.alpha = 0 }) {
            if $0 { self.removeFromSuperview() }
        }
    }

    @objc func tapBlock() {

        if let action = self.tapGestureClosure {
            action()
        }

        hideView()
    }
}
