//
//  IKDayliDataSource.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

//Модель секции
class IKModelSection<T: NSObject> {
    var items = Array<T>()
    var title: String?

    init(title: String?) {
        self.title = title
    }

    func addItem(item: T) {
        items.append(item)
    }

    func getItemsCount() -> Int {
        return items.count
    }

    func getItemAtIndex(index: Int) -> T {
        return items[index]
    }

    func getIndexForKey(key: String, keyPath: String) -> Int? {
        return items.index { (model) -> Bool in
            guard let checkable = model.value(forKeyPath: keyPath) as? String else {
                return false
            }
            return checkable == key
        }
    }

    func getIndexForModel(_ model: T) -> Int? {
        return items.index(where: { $0 === model })
    }

    func removeItemAt(_ index: Int) {
        items.remove(at: index)
    }

    func setItems(_ newItems: [T]) {
        items = newItems
    }

    func getItems() -> [T] {
        return items
    }

    func replaceItemAt(index: Int, item: T) {
        self.items.remove(at: index)
        self.items.insert(item, at: index)
    }
}
