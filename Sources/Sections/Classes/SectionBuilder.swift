//
//  SectionBuilder.swift
//  Sections
//
//  Created by Robert Manson on 8/20/16.
//
//

import Foundation

public struct SectionBuilder<T> {
    public typealias SectionsClosure = (Sections<T>) -> Sections<T>
    fileprivate var sectionClosures: [SectionsClosure] = []
    public var values: Sections<T>

    public var sections: Sections<T> {
        let values = sectionClosures.flatMap { $0(self.values) }
        return Sections<T>(sections: values)
    }

    public func addSections(_ f: @escaping SectionsClosure) -> SectionBuilder<T> {
        var sections = self
        sections.sectionClosures.append(f)
        return sections
    }

    public init(initialValues: Sections<T>) {
        self.values = initialValues
    }
}

extension SectionBuilder where T: Equatable {
    /**
     Find index path for value.

     - parameter value: Value to find.

     - returns: Index path of match or nil.
     */
    public func indexPathOfValue(_ value: T) -> IndexPath? {
        guard let sectionIndex = sections.firstIndex(where: { $0.rows.contains(value) }) else { return nil }
        guard let rowIndex = sections[sectionIndex].rows.firstIndex(of: value) else { return nil }

        return IndexPath(row: rowIndex, section: sectionIndex)
    }
}
