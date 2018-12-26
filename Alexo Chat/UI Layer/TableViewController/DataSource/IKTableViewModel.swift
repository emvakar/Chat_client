//
//  IKTableViewModel.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

protocol IKTableViewModel: class {

    var title: String { get set }

    func isEqual(_ object: AnyObject) -> Bool

}

enum IKModelTableUpdateType {
    case reset
    case reload
    case update
}

struct IKModelTableUpdateParams {

    var sectionsInsert: IndexSet
    var sectionsDelete: IndexSet
    var sectionsUpdate: IndexSet

    var rowsInsert: [IndexPath]
    var rowsDelete: [IndexPath]
    var rowsUpdate: [IndexPath]

    static func getEmpty() -> IKModelTableUpdateParams {
        return IKModelTableUpdateParams(sectionsInsert: IndexSet(), sectionsDelete: IndexSet(), sectionsUpdate: IndexSet(), rowsInsert: [IndexPath](), rowsDelete: [IndexPath](), rowsUpdate: [IndexPath]())
    }
}

struct IKModelTableUpdate {

    var updateType: IKModelTableUpdateType
    var params: IKModelTableUpdateParams?

    init(updateType: IKModelTableUpdateType, params: IKModelTableUpdateParams? = nil) {
        if updateType == .update && params == nil {
            fatalError(String("IKModelTableUpdateType of type .update must include params"))
        }
        self.updateType = updateType
        self.params = params
    }
}

protocol IKDataSourceClient: class {
    func updateWithModel(model: IKModelTableUpdate)
}
