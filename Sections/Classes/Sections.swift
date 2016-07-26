//
//  Sections.swift
//  Robert Manson
//
//  Created by Robert Manson on 7/7/16.
//

import Foundation

public struct Section<T> {
    public let name: String
    public let rows: [T]

    public init (name: String, rows: [T]) {
        self.name = name
        self.rows = rows
    }
}

public struct SectionBuilder<T> {
    public typealias SectionsClosure = ([T]) -> [Section<T>]
    private var sectionClosures: [SectionsClosure] = []
    public var values: [T]

    public var sections: [Section<T>] {
        return sectionClosures.flatMap { $0(self.values) }
    }

    public func addSections(f: SectionsClosure) -> SectionBuilder<T> {
        var sections = self
        sections.sectionClosures.append(f)
        return sections
    }

    public init(initialValues: [T]) {
        self.values = initialValues
    }
}

extension SectionBuilder where T: Equatable {
    /**
     Find index path for value.

     - parameter value: Value to find.

     - returns: Index path of match or nil.
     */
    public func indexPathOfValue(value: T) -> NSIndexPath? {
        guard let sectionIndex = sections.indexOf({ $0.rows.contains(value) }) else { return nil }
        guard let rowIndex = sections[sectionIndex].rows.indexOf(value) else { return nil }

        return NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
    }
}
