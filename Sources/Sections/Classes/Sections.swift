//
//  Sections.swift
//  Robert Manson
//
//  Created by Robert Manson on 7/7/16.
//

public struct Section<ID: Hashable, Item: Identifiable> {
    public let id: ID
    public let title: String?
    public let items: [Item]

    public init(
        _ id: ID,
        title: String? = nil,
        items: [Item]
    ) {
        self.id = id
        self.title = title
        self.items = items
    }
}
