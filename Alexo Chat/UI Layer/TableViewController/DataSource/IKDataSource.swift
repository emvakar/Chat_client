//
//  IKIDataSource.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

protocol IKDataSource {
    associatedtype T

    func numberOfSections() -> Int
    func numberOfRowsInSection(indexOfSection: Int) -> Int
    func getModelAtIndexPath(indexPath: IndexPath) -> T
    func removeModels()
    func insertModels(models: [T], animated: Bool)
    func updateModels(models: [T], animated: Bool)
    func updateModel(model: T, animated: Bool)
    func updateModel(at index: IndexPath, with model: T, animated: Bool)
    func deleteModelAtIndexPaths(indexPaths: [IndexPath], animated: Bool)

    func compareUnknownType(a: Any, b: Any) -> Bool
}

extension IKDataSource {

    func compareUnknownType(a: Any, b: Any) -> Bool {

        if let va = a as? Int, let vb = b as? Int {return va > vb} else if let va = a as? String, let vb = b as? String {return va > vb} else if let va = a as? Date, let vb = b as? Date {return va > vb} else if let va = a as? Double, let vb = b as? Double {return va > vb} else if let va = a as? Float, let vb = b as? Float {return va > vb} else {

            fatalError("tried to compare unsupported type")
        }
    }
}
