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
    public func indexPathForRow(row: T) -> NSIndexPath? {
        for (sectionIndex, section) in sections.enumerate() {
            if let rowIndex = section.rows.indexOf(row) {
                return NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
            }
        }
        return nil
    }

}
extension Sections: SequenceType {
    public typealias Generator = AnyGenerator<Section<T>>

    public func generate() -> Sections.Generator {
        let g = sections.generate()
        return AnyGenerator(g)
    }
}

extension Sections: CollectionType {
    public typealias Index = Int

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return sections.count
    }

    public subscript(i: Int) -> Section<T> {
        get {
            return sections[i]
        }
        set {
            sections[i] = newValue
        }
    }
}

extension Sections: ArrayLiteralConvertible {
    public typealias Element = Section<T>
    public init(arrayLiteral elements: Sections.Element...) {
        self.sections = elements
    }
}

extension Sections: RangeReplaceableCollectionType {
    public init() {
        self.sections = []
    }

    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Sections.Index>, with newElements: C) {
        self.sections.replaceRange(subRange, with: newElements)
    }
}
