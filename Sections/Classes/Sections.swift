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

extension Sections: Collection {
    public typealias Element = Section<T>
    public typealias Index = Int

    public var startIndex: Index {
        return sections.startIndex
    }

    public var endIndex: Index {
        return sections.endIndex
    }

    public subscript(i: Index) -> Element {
        get { sections[i] }
        set { sections[i] = newValue }
    }

    public func index(after i: Index) -> Index {
        return sections.index(after: i)
    }
}

extension Sections: RangeReplaceableCollection {
    public init() {
        sections = []
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Index>, with newElements: C) where C: Collection, C.Element == Element {
        sections.replaceSubrange(subrange, with: newElements)
    }
}

extension Sections: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        sections = elements
    }
}
