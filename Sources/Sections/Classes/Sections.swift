//
//  Sections.swift
//  Robert Manson
//
//  Created by Robert Manson on 7/7/16.
//

import Foundation

public struct Section<T> {
    public let name: String
    public var rows: [T]

    public init (name: String, rows: [T]) {
        self.name = name
        self.rows = rows
    }
}

public struct Sections<T> {
    public var sections: [Section<T>]
    public init(sections: [Section<T>]) {
        self.sections = sections
    }
}

extension Sections where T: Equatable {
    public func indexPathForRow(_ row: T) -> IndexPath? {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.rows.firstIndex(of: row) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return nil
    }

}
extension Sections: Sequence {
    public typealias Iterator = AnyIterator<Section<T>>

    public func makeIterator() -> Sections.Iterator {
        let g = sections.makeIterator()
        return AnyIterator(g)
    }
}

extension Sections: Collection {
    public typealias Index = Int

    public var startIndex: Int {
        return sections.startIndex
    }

    public var endIndex: Int {
        return sections.endIndex
    }

    public subscript(i: Int) -> Section<T> {
        get {
            return sections[i]
        }
        set {
            sections[i] = newValue
        }
    }

    public func index(after i: Index) -> Index {
        return sections.index(after: i)
    }
}

extension Sections: ExpressibleByArrayLiteral {
    public typealias Element = Section<T>
    public init(arrayLiteral elements: Sections.Element...) {
        self.sections = elements
    }
}

extension Sections: RangeReplaceableCollection {
    public init() {
        self.sections = []
    }

    public mutating func replaceSubrange<C : Collection>(_ subRange: Range<Sections.Index>, with newElements: C) where C.Iterator.Element == Iterator.Element {
        self.sections.replaceSubrange(subRange, with: newElements)
    }
}
