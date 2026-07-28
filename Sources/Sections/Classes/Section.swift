//
//  Section.swift
//  Robert Manson
//
//  Created by Robert Manson on 7/7/16.
//

/// Application-level metadata for a table or collection-view section.
///
/// Item values do not need to be `Hashable`; their identifiers must be unique
/// within the section.
public struct Section<ID: Hashable, Item: Identifiable> {
    public let id: ID
    public let title: String?
    public let items: [Item]

    public init(
        _ id: ID,
        title: String? = nil,
        items: [Item]
    ) {
        precondition(
            Set(items.map(\.id)).count == items.count,
            "A section cannot contain duplicate item identifiers."
        )

        self.id = id
        self.title = title
        self.items = items
    }
}
