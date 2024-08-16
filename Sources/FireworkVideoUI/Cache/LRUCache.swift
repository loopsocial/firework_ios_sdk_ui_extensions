//
//  File.swift
//  
//
//  Created by linjie jiang on 8/16/24.
//

import Foundation

private class ListNode<Key, Value> {
    var key: Key
    var value: Value
    var next: ListNode?
    var prev: ListNode?

    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}

class LRUCache<Key: Hashable, Value> {
    private let capacity: Int
    private var dictionary: [Key: ListNode<Key, Value>]
    private var head: ListNode<Key, Value>?
    private var tail: ListNode<Key, Value>?

    init(capacity: Int) {
        self.capacity = capacity
        self.dictionary = [Key: ListNode<Key, Value>]()
    }

    func get(_ key: Key) -> Value? {
        guard let node = dictionary[key] else {
            return nil
        }
        moveToHead(node)
        return node.value
    }

    func put(_ key: Key, value: Value) {
        if let node = dictionary[key] {
            node.value = value
            moveToHead(node)
        } else {
            let newNode = ListNode(key: key, value: value)
            if dictionary.count == capacity {
                removeTail()
            }
            addToHead(newNode)
            dictionary[key] = newNode
        }
    }

    private func moveToHead(_ node: ListNode<Key, Value>) {
        removeNode(node)
        addToHead(node)
    }

    private func addToHead(_ node: ListNode<Key, Value>) {
        node.next = head
        node.prev = nil
        if let head = head {
            head.prev = node
        }
        head = node
        if tail == nil {
            tail = node
        }
    }

    private func removeNode(_ node: ListNode<Key, Value>) {
        if let prev = node.prev {
            prev.next = node.next
        } else {
            head = node.next
        }
        if let next = node.next {
            next.prev = node.prev
        } else {
            tail = node.prev
        }
    }

    private func removeTail() {
        guard let tail = tail else {
            return
        }
        dictionary[tail.key] = nil
        removeNode(tail)
    }
}
