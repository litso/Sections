//
//  SectionBuilder.swift
//  Sections
//
//  Created by Robert Manson on 8/20/16.
//

import Foundation

public struct SectionBuilder<ID: Hashable, Item: Identifiable> {
    public typealias SectionsClosure = ([Section<ID, Item>]) -> [Section<ID, Item>]

    private var sectionClosures: [SectionsClosure] = []
    public var values: [Section<ID, Item>]

    public var sections: [Section<ID, Item>] {
        sectionClosures.flatMap { $0(values) }
    }

    public init(initialValues: [Section<ID, Item>]) {
        values = initialValues
    }

    public func addSections(_ closure: @escaping SectionsClosure) -> SectionBuilder<ID, Item> {
        var builder = self
        builder.sectionClosures.append(closure)
        return builder
    }

    public func indexPathOfItem(withID id: Item.ID) -> IndexPath? {
        for (sectionIndex, section) in sections.enumerated() {
            if let itemIndex = section.items.firstIndex(where: { $0.id == id }) {
                return IndexPath(indexes: [sectionIndex, itemIndex])
            }
        }

        return nil
    }
}
