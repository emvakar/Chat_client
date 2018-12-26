//
//  IKFullScreenAlertViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

//MAKR: - VSDFullScreenAlertControllerDelegate
public protocol IKFullScreenAlertViewControllerDelegate: class {
    func willDissmissController()
    func didDissmissController()
}

// MARK: - VSDFullScreenAlertController
public class IKFullScreenAlertViewController: UIViewController {

    // MARK: - Properties
    private var titleText: String! = nil
    private var messageText: String?
    private var mainImageView: UIImageView?
    private var detailImageView: UIImageView?
    private var tapImage: UIImage?
    private var tapGestureClosure : (() -> Void)?
    private var mainImageContentMode: UIView.ContentMode = .scaleAspectFit
    private var backgroundColor: UIColor = .white
    public weak var delegate: IKFullScreenAlertViewControllerDelegate?

    //MAKR: - Init
    public init(configuration: IKFullScreenAlertConfiguration) {
        self.titleText = configuration.title
        self.messageText = configuration.message
        self.mainImageView = UIImageView.init(image: configuration.mainImage)
        self.detailImageView = UIImageView.init(image: configuration.detailImage)
        self.tapImage = configuration.tapImage
        self.backgroundColor = configuration.backgroundColor ?? .white
        self.tapGestureClosure = configuration.tapGestureClosure
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
    }
}

//MAKR: - Actions
extension IKFullScreenAlertViewController {

    @objc func close() {
        self.delegate?.willDissmissController()
        self.dismiss(animated: true, completion: {
            self.delegate?.didDissmissController()
        })
    }
}

// MARK: - Prviate
extension IKFullScreenAlertViewController {

    private func createUI() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.view.backgroundColor = self.backgroundColor

        let tapGsetureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tapGsetureRecognizer)

        let labelTitle = UILabel.makeLabel(size: 20, weight: .semibold, color: .white)
        labelTitle.text = self.titleText
        labelTitle.textAlignment = .center

        self.view.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-180)
            $0.centerX.equalToSuperview()
        }

        let mainPicture = self.mainImageView ?? UIView()
        mainPicture.contentMode = self.mainImageContentMode
        self.view.addSubview(mainPicture)

        mainPicture.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-60)
        }

        if let detailImageView = self.detailImageView {
            self.view.addSubview(detailImageView)
            detailImageView.contentMode = .scaleAspectFit
            detailImageView.snp.makeConstraints {
                $0.left.equalTo(mainPicture.snp.centerX)
                $0.centerY.equalTo(mainPicture.snp.bottom).offset(5)
                $0.height.equalTo(55)
                $0.width.equalTo(55)
            }
        }

        let descriptionLabel = UILabel.makeLabel(size: 15, weight: .light, color: .white)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = self.messageText
        descriptionLabel.textAlignment = .center
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(75)
        }

        let tapImageView = UIImageView(image: tapImage)
        tapImageView.contentMode = .scaleAspectFit
        self.view.addSubview(tapImageView)
        tapImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-25)
        }
    }
}
