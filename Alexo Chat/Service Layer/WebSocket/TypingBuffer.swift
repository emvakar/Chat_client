//
//  TypingBuffer.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

public class TypingBuffer: NSObject {

    private var delay = 2.0

    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem?

    public init(queue: DispatchQueue, delay: Double = 2) {
        self.queue = queue
        self.delay = delay
    }

    func typing(typing: Bool, _ closure: @escaping (Bool) -> Void) {
        self.workItem?.cancel()

        self.workItem = DispatchWorkItem {
            closure(typing)
        }

        if let workItem = self.workItem {
            self.queue.asyncAfter(deadline: .now() + self.delay, execute: workItem)
        }
    }
}
