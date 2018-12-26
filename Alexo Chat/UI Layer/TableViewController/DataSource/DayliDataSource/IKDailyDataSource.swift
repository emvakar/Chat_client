//
//  IKDayliDataSource.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

//Data Source
class IKDailyDataSource<T: NSObject>: IKDataSource {
    func updateModel(at index: IndexPath, with model: T, animated: Bool) {
        print(index, model, animated)
    }

    var uniqueKeyPath: String
    var dateKeyPath: String

    lazy var uniqueKeys = Set<String>()
    var sections = [IKModelSection<T>]()
    var useUtc: Bool = false
    var selectedItems = [T]()

    weak var client: IKDataSourceClient?

    init(uniqueKeyPath: String, dateKeyPath: String) {
        self.uniqueKeyPath = uniqueKeyPath
        self.dateKeyPath = dateKeyPath
    }

    //methods
    func numberOfSections() -> Int {
        return self.sections.count
    }

    func numberOfRowsInSection(indexOfSection: Int) -> Int {
        return self.sections[indexOfSection].getItemsCount()
    }

    func getModelAtIndexPath(indexPath: IndexPath) -> T {
        let section = self.sections[indexPath.section]
        return section.getItemAtIndex(index: indexPath.row)
    }

    func getSelectedItems() -> [T] {
        return selectedItems
    }

    func getAllItems() -> [T] {
        var itemsArray = [T]()

        sections.forEach { (section) in
            let itemsInSection = section.getItems()
            itemsArray.append(contentsOf: itemsInSection)
        }

        return itemsArray
    }

    func removeModels() {
        self.sections = []
        self.uniqueKeys = Set<String>()

        let model = IKModelTableUpdate(updateType: .reset)
        self.client?.updateWithModel(model: model)
    }

    func removeModels(withScreenAnimation: Bool) {
        self.sections = []
        self.uniqueKeys = Set<String>()

        if withScreenAnimation {
            let model = IKModelTableUpdate(updateType: .reset)
            self.client?.updateWithModel(model: model)
        }

    }

    // MARK: - Private methods
    func roundedDateForModel(_ model: AnyObject, useUtc: Bool = true) -> Date? {

        var dateFromModel: Date?
        if let dateTimeInterval = model.value(forKeyPath: self.dateKeyPath) as? Int {
            dateFromModel = Date.init(timeIntervalSince1970: Double(dateTimeInterval))
        } else if let dateTimeString = model.value(forKeyPath: self.dateKeyPath) as? String {
            dateFromModel = Date.init(fromString: dateTimeString, format: .isoDateTimeSec)

        } else if let date = model.value(forKeyPath: self.dateKeyPath) as? Date {
            dateFromModel = date
        } else {
            return nil
        }

        guard let date = dateFromModel else {
            return nil
        }

        var calendar = Calendar.current
        calendar.timeZone = useUtc ? TimeZone(abbreviation: "UTC")! : TimeZone.current

        var dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        dateComponents.second = 0
        dateComponents.minute = 0
        dateComponents.hour = 0

        return calendar.date(from: dateComponents)
    }

    func getIndexPathForModel(_ model: T) -> IndexPath {
        for (indexSection, section) in sections.enumerated() {
            if let index = section.getIndexForModel(model) {
                return IndexPath.init(row: index, section: indexSection)
            }
        }

        return IndexPath.init(row: 0, section: 0)
    }
}

// MARK: - Insert
extension IKDailyDataSource {
    func insertModels(models: [T], animated: Bool) {
        self.insertModels(models: models, animated: animated, completionBlock: nil)
    }

    func insertModels(models: [T], animated: Bool, completionBlock: (() -> Void)?) {

        if self.sections.isEmpty && models.isEmpty {
            DispatchQueue.main.async {
                let modelUpdate = IKModelTableUpdate(updateType: .reload)
                self.client?.updateWithModel(model: modelUpdate)
            }
            return
        }

        var existingUniqueKeys: Set<String> = self.uniqueKeys
        var updateParams: IKModelTableUpdateParams? = IKModelTableUpdateParams.getEmpty()
        var sectionsCopy = self.sections

        let insertedSectionIndexes = NSMutableIndexSet()
        var insertedItemsIndexes: [IndexPath] = []

        for model in models {
            // check for exist by unique key
            let uniqueKey = model.value(forKeyPath: self.uniqueKeyPath) as? String
            if !existingUniqueKeys.contains(uniqueKey!) {
                existingUniqueKeys.insert(uniqueKey!)
            }

            guard let date = self.roundedDateForModel(model, useUtc: !self.useUtc) else {
                continue
            }

            // choose section to push
            var currentSection: IKModelSection<T>
            let sectionIndex: Int
            let currentSectionTitle = date.formatDMYRelative(systemTZ: self.useUtc)

            if !sectionsCopy.isEmpty && sectionsCopy[sectionsCopy.count - 1].title == currentSectionTitle {
                sectionIndex = sectionsCopy.count - 1
                currentSection = sectionsCopy[sectionIndex]
            } else {
                currentSection = IKModelSection<T>(title: currentSectionTitle)
                sectionIndex = sectionsCopy.count
                sectionsCopy.append(currentSection)
                insertedSectionIndexes.add(sectionIndex)
            }
            // add item in section
            currentSection.addItem(item: model)
            let row = currentSection.getItemsCount() - 1
            insertedItemsIndexes.append(IndexPath(row: row, section: sectionIndex))
        }

        updateParams?.sectionsInsert = insertedSectionIndexes as IndexSet
        updateParams?.rowsInsert = insertedItemsIndexes

        DispatchQueue.main.async {
            self.sections = sectionsCopy
            self.uniqueKeys = existingUniqueKeys
            var updateModel: IKModelTableUpdate! = nil
            if animated {
                updateModel = IKModelTableUpdate(updateType: .update, params: updateParams)
                self.client?.updateWithModel(model: updateModel)
            } else {
                updateModel = IKModelTableUpdate(updateType: .reload)
                self.client?.updateWithModel(model: updateModel)
            }

            completionBlock?()
        }
    }
}

// MARK: - Update
extension IKDailyDataSource {

    func updateModel(model: T, animated: Bool) {
        for section in sections {
            if let index = section.getIndexForModel(model) {
                section.replaceItemAt(index: index, item: model)
            }
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

    func updateModels(models: [T], animated: Bool) {
        var indexPathsOfModels = [IndexPath]()
        var indexSetOfSections = IndexSet()

        models.forEach { (model) in
            for section in sections {
                if let index = section.getIndexForModel(model) {
                    section.replaceItemAt(index: index, item: model)
                }
            }

            let indexPath = self.getIndexPathForModel(model)
            indexPathsOfModels.append(indexPath)
            indexSetOfSections.insert(indexPath.section)
        }

        var updateParams = IKModelTableUpdateParams.getEmpty()
        updateParams.sectionsUpdate = indexSetOfSections
        updateParams.rowsInsert = indexPathsOfModels

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
}

// MARK: - Delete
extension IKDailyDataSource {

    func deleteModelAtIndexPaths(indexPaths: [IndexPath], animated: Bool) {
        var deletedSections = IndexSet()
        var deletedIndexes = [IndexPath]()

        // добавили удаляемые ячпейки
        deletedIndexes = indexPaths

        //Найдем все удаляемые модели
        var deletedModels = [T]()
        for indexPath in indexPaths {
            let deletedModel = self.sections[indexPath.section].getItemAtIndex(index: indexPath.row)
            deletedModels.append(deletedModel)
        }

        //теперь нужно удалить эти модели из sections и из массива с выделенными ячейками (если удаляем в editing mode)
        for section in sections {
            for deletedModel in deletedModels {

                if section.getItems().contains(deletedModel) {
                    if let index = section.getIndexForModel(deletedModel) {
                        section.removeItemAt(index)
                    }
                }

                if selectedItems.contains(deletedModel) {
                    if let index = selectedItems.index(of: deletedModel) {
                        selectedItems.remove(at: index)
                    }
                }
            }
        }

        //находим секции, где нет итемов
        for (sectionIndex, section) in sections.enumerated() {
            if section.getItemsCount() == 0 {
                deletedSections.insert(sectionIndex)
            }
        }

        var indexes = [Int]()
        deletedSections.forEach { (index) in
            indexes.append(index)
        }
        //кастомный remove, так как из массива секций все элементы удалять нужно одновременно
        self.sections.remove(at: indexes)

        var updateParams = IKModelTableUpdateParams.getEmpty()
        updateParams.rowsDelete = deletedIndexes
        updateParams.sectionsDelete = deletedSections

        let updateModel = animated ? IKModelTableUpdate(updateType: .update, params: updateParams) : IKModelTableUpdate(updateType: .reload)
        self.client?.updateWithModel(model: updateModel)
    }

    func deleteSelectedItems() {
        let selectedItems = self.selectedItems
        var indexPaths = [IndexPath]()

        selectedItems.forEach { (selectedItem) in
            for (sectionIndex, section) in sections.enumerated() {
                let itemsInsection = section.getItems()
                if itemsInsection.contains(selectedItem) {
                    if let index = section.getIndexForModel(selectedItem) {
                        let indexPath = IndexPath(row: index, section: sectionIndex)
                        indexPaths.append(indexPath)
                    }
                }
            }
        }

        self.deleteModelAtIndexPaths(indexPaths: indexPaths, animated: true)
    }
}

// MARK: - Selection
extension IKDailyDataSource {

    //вызывается при нажатии на ячейку при editing mode
    func selectOrDeselectItem(at indexPath: IndexPath) {
        let section = self.sections[indexPath.section]
        let selectedItem = section.getItemAtIndex(index: indexPath.row)

        if self.selectedItems.isEmpty {
            self.selectedItems.append(selectedItem)
            return
        }

        if !selectedItems.contains(selectedItem) {
            self.selectedItems.append(selectedItem)
        } else {
            if let index = selectedItems.index(of: selectedItem) {
                self.selectedItems.remove(at: index)
            }
        }
    }

    func selectAll() -> [IndexPath] {
        var indexPaths = [IndexPath]()

        for (index, section) in sections.enumerated() {
            let items = section.getItems()
            items.forEach({ (item) in
                if !selectedItems.contains(item) {
                    selectedItems.append(item)
                    if let row = section.getIndexForModel(item) {
                        indexPaths.append(IndexPath(row: row, section: index))
                    }
                }
            })
        }

        return indexPaths
    }

    func deselectAll() -> [IndexPath] {
        var indexPaths = [IndexPath]()

        let selectedItems = self.getSelectedItems()
        selectedItems.forEach { (selectedItem) in
            for (index, section) in sections.enumerated() {
                let items = section.getItems()
                if items.contains(selectedItem) {
                    if let row = section.getIndexForModel(selectedItem) {
                        indexPaths.append(IndexPath(row: row, section: index))
                    }
                }
            }
        }

        self.selectedItems = []
        return indexPaths
    }
}
