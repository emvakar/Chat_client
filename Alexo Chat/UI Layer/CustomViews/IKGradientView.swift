//
//  IKGradientView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - VSDGradientView
class IKGradientView: UIView {

    // MARK: - Properties
    var startColor: UIColor = .black { didSet { self.updateColors() }}
    var endColor: UIColor = .white { didSet { self.updateColors() }}
    var startLocation: Double =   0.05 { didSet { self.updateLocations() }}
    var endLocation: Double =   0.95 { didSet { self.updateLocations() }}
    var inversionMode: Bool  =  false { didSet { self.inversionGradient() }}

    override class var layerClass: AnyClass { return CAGradientLayer.self }
    var gradientLayer: CAGradientLayer? {
        return self.layer as? CAGradientLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.inversionGradient()
        self.updateLocations()
        self.updateColors()
    }
}

// MARK: - Private
extension IKGradientView {

    private func inversionGradient() {
        guard let gradientLayer = self.gradientLayer else { return }
        gradientLayer.startPoint = self.inversionMode ? CGPoint(x: 0, y: 0.5) : CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint   = self.inversionMode ? CGPoint(x: 1, y: 0.5) : CGPoint(x: 0.5, y: 1)
    }

    private func updateLocations() {
        guard let gradientLayer = self.gradientLayer else { return }
        gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    }

    private func updateColors() {
        guard let gradientLayer = self.gradientLayer else { return }
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
}
