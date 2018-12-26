//
//  IKSearchBuffer.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public class IKSearchBuffer: NSObject {

    private var delay = 0.8
    private var minSearchCount = 3

    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem?

    public init(queue: DispatchQueue, delay: Double = 0.8, minSearchCount: Int = 3) {
        self.queue = queue
        self.minSearchCount = minSearchCount
        self.delay = delay
    }

    public func searchBy(text: String?, _ closure: @escaping (String?) -> Void) {
        self.workItem?.cancel()

        guard let text = text, !text.isEmpty else {
            closure(nil)
            return
        }

        if text.count < self.minSearchCount {
            return
        }

        self.workItem = DispatchWorkItem {
            closure(text)
        }

        if let workItem = self.workItem {
            self.queue.asyncAfter(deadline: .now() + self.delay, execute: workItem)
        }
    }
}
