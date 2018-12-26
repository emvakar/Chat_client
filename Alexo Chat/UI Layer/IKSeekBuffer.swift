//
//  IKSeekBuffer.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 10/11/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

class IKSeekBuffer: NSObject {

    private var delay = 0.8
    private var minSearchCount = 3

    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem?

    init(queue: DispatchQueue, delay: Double = 0.8, minSearchCount: Int = 3) {
        self.queue = queue
        self.minSearchCount = minSearchCount
        self.delay = delay
    }

//    func seeking(track: TrackModel, _ closure: @escaping (TrackModel) -> Void) {
//        self.workItem?.cancel()
//
//        self.workItem = DispatchWorkItem {
//            closure(track)
//        }
//
//        if let workItem = self.workItem {
//            self.queue.asyncAfter(deadline: .now() + self.delay, execute: workItem)
//        }
//    }
}
