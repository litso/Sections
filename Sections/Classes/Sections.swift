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
