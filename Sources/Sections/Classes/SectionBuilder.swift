//
//  SectionBuilder.swift
//  Sections
//
//  Created by Robert Manson on 8/20/16.
//

import Foundation

public struct SectionBuilder<ID: Hashable, Item: Identifiable> {
    public typealias SectionsClosure = ([Section<ID, Item>]) -> [Section<ID, Item>]

    private let initialSections: [Section<ID, Item>]
    private var sectionClosures: [SectionsClosure] = []

    /// Initial sections followed by generated sections in registration order.
    ///
    /// Section identifiers and item identifiers must be unique in the result.
    public var sections: [Section<ID, Item>] {
        let generatedSections = sectionClosures.flatMap { $0(initialSections) }
        let sections = initialSections + generatedSections
        Self.validateUniqueIdentifiers(in: sections)
        return sections
    }

    public init(initialSections: [Section<ID, Item>]) {
        Self.validateUniqueIdentifiers(in: initialSections)
        self.initialSections = initialSections
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

    private static func validateUniqueIdentifiers(in sections: [Section<ID, Item>]) {
        var sectionIDs = Set<ID>()
        var itemIDs = Set<Item.ID>()

        for section in sections {
            precondition(
                sectionIDs.insert(section.id).inserted,
                "Section identifiers must be unique."
            )

            for item in section.items {
                precondition(
                    itemIDs.insert(item.id).inserted,
                    "Item identifiers must be unique across sections."
                )
            }
        }
    }
}
