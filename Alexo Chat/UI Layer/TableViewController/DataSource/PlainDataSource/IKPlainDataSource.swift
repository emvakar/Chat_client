//
//  IKPlainDataSource.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - IKPlainDatsSource
class IKPlainDatsSource<Template: NSObject>: IKDataSource {
    typealias T = Template

    // MARK: - properties
    var uniqueKeypath: String
    var title: String?
    var section = IKModelSection<T>.init(title: nil)

    weak var _client: IKDataSourceClient?
    var client: IKDataSourceClient? {
        get { return _client }
        set { _client = newValue }
    }

    // MARK: - Init
    init(uniqueKeypath: String, title: String? = nil) {
        self.title = title
        self.section = IKModelSection<T>(title: self.title)
        self.uniqueKeypath = uniqueKeypath
    }

    // MARK: - IKDataSource
    func titleFor(section: Int) -> String? {
        return self.section.title
    }

    func numberOfSections() -> Int {
        return self.section.getItemsCount() == 0 ? 0 : 1
    }

    func numberOfRowsInSection(indexOfSection: Int) -> Int {
        return self.section.getItemsCount()
    }

    func getModelAtIndexPath(indexPath: IndexPath) -> Template {
        return self.section.getItemAtIndex(index: indexPath.row)
    }

    func getIndexPathForModel(_ model: Template) -> IndexPath {
        if let index = self.section.getIndexForModel(model) {
            return IndexPath.init(row: index, section: 0)
        }

        return IndexPath.init(row: 0, section: 0)
    }
}

// MARK: - Delete
extension IKPlainDatsSource {
    func deleteModelAtIndexPaths(indexPaths: [IndexPath], animated: Bool) {
        let deletedSectionIndex = NSMutableIndexSet()
        let deletedItemsIndexes = indexPaths

        if indexPaths.isEmpty || self.numberOfSections() == 0 || self.numberOfRowsInSection(indexOfSection: 0) == 0 {
            return
        }

        var sectionsCopy = self.section.getItems()
        for indexPath in indexPaths {
            let deletedModel = self.section.getItemAtIndex(index: indexPath.row)
            let index = sectionsCopy.index(of: deletedModel)
            sectionsCopy.remove(at: index!)
        }
        self.section.setItems(sectionsCopy)

        if self.section.getItemsCount() == 0 {
            deletedSectionIndex.add(0)
        }

        var updateParams: IKModelTableUpdateParams? = IKModelTableUpdateParams.getEmpty()
        updateParams?.sectionsDelete = deletedSectionIndex as IndexSet
        updateParams?.rowsDelete = deletedItemsIndexes

        let updateModel = animated ? IKModelTableUpdate(updateType: .update, params: updateParams) : IKModelTableUpdate(updateType: .reload)
        self.client?.updateWithModel(model: updateModel)
    }

    func deleteIndexPathsOfModels(models: [Template], animated: Bool) {
        var deletedItemsIndexes: [IndexPath] = []

        for model in models {
            if let row = self.section.getIndexForModel(model) {
                deletedItemsIndexes.append(IndexPath.init(row: row, section: 0))
            }
        }

        self.deleteModelAtIndexPaths(indexPaths: deletedItemsIndexes, animated: animated)
    }

    func removeModels() {
        self.deleteIndexPathsOfModels(models: self.section.getItems(), animated: false)
    }
}

extension IKPlainDatsSource {
    func insertModels(models: [Template], animated: Bool) {
        let insertedSectionIndex = NSMutableIndexSet()
        var insertedItemsIndexes: [IndexPath] = []

        if models.isEmpty {
            return
        }

        if self.section.getItemsCount() == 0 && self.numberOfSections() == 0 {
            insertedSectionIndex.add(0)
        }

        for model in models {
            insertedItemsIndexes.append(IndexPath.init(row: self.section.getItemsCount(), section: 0))
            self.section.addItem(item: model)
        }

        var updateParams: IKModelTableUpdateParams? = IKModelTableUpdateParams.getEmpty()
        updateParams?.sectionsInsert = insertedSectionIndex as IndexSet
        updateParams?.rowsInsert = insertedItemsIndexes

        let updateModel = animated ? IKModelTableUpdate(updateType: .update, params: updateParams) : IKModelTableUpdate(updateType: .reload)
        self.client?.updateWithModel(model: updateModel)
    }
}

// MARK: - Update
extension IKPlainDatsSource {

    func updateModels(models: [Template], animated: Bool) {
        var updatedItemsIndexes: [IndexPath] = []
        let insertedSectionIndex = NSMutableIndexSet()
        var insertedItemsIndexes: [IndexPath] = []

        if models.isEmpty {
            return
        }

        if self.section.getItemsCount() == 0 && self.numberOfSections() == 0 {
            insertedSectionIndex.add(0)
        }

        for model in models {
            if let index = self.section.getIndexForModel(model) {
                updatedItemsIndexes.append(IndexPath.init(row: index, section: 0))
            } else {
                insertedItemsIndexes.append(IndexPath.init(row: self.section.getItemsCount(), section: 0))
                self.section.addItem(item: model)
            }
        }

        var updateParams: IKModelTableUpdateParams? = IKModelTableUpdateParams.getEmpty()
        updateParams?.sectionsInsert = insertedSectionIndex as IndexSet
        updateParams?.rowsInsert = insertedItemsIndexes
        updateParams?.rowsUpdate = updatedItemsIndexes

        let updateModel = animated ? IKModelTableUpdate(updateType: .update, params: updateParams) : IKModelTableUpdate(updateType: .reload)
        self.client?.updateWithModel(model: updateModel)
    }

    func updateModel(at index: IndexPath, with model: T, animated: Bool) {
        self.section.replaceItemAt(index: index.row, item: model)

        var updateParams: IKModelTableUpdateParams? = IKModelTableUpdateParams.getEmpty()

        updateParams?.sectionsUpdate = IndexSet([index.section])
        updateParams?.rowsInsert = [index]

        DispatchQueue.main.async {
            var updateModel: IKModelTableUpdate! = nil
            if animated {
                updateModel = IKModelTableUpdate(updateType: .update, params: updateParams)
                self.client?.updateWithModel(model: updateModel)
            } else {
                updateModel = IKModelTableUpdate(updateType: .reload)
                self.client?.updateWithModel(model: updateModel)
            }
        }
    }

    func updateModel(model: Template, animated: Bool) {

        if let index = section.getIndexForModel(model) {
            self.section.replaceItemAt(index: index, item: model)
        }

        let indexPath = self.getIndexPathForModel(model)
        var updateParams: IKModelTableUpdateParams? = IKModelTableUpdateParams.getEmpty()

        updateParams?.sectionsUpdate = IndexSet([indexPath.section])
        updateParams?.rowsInsert = [indexPath]

        DispatchQueue.main.async {
            var updateModel: IKModelTableUpdate! = nil
            if animated {
                updateModel = IKModelTableUpdate(updateType: .update, params: updateParams)
                self.client?.updateWithModel(model: updateModel)
            } else {
                updateModel = IKModelTableUpdate(updateType: .reload)
                self.client?.updateWithModel(model: updateModel)
            }
        }
    }

    func updateModelsByIndexPaths(indexPaths: [IndexPath], animated: Bool) {
        var models = [Template]()

        for indexPath in indexPaths {
            let model = self.section.getItemAtIndex(index: indexPath.row)
            models.append(model)
        }

        self.updateModels(models: models, animated: animated)
    }
}
