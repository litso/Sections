//
//  Section.swift
//  Sections
//
//  Created by Erik Strottmann on 6/16/20.
//

public struct Section<T> {
    public let name: String
    public var rows: [T]

    public init(name: String, rows: [T]) {
        self.name = name
        self.rows = rows
    }

    public init(name: String, @RowBuilder _ rows: () -> [T]) {
        self.name = name
        self.rows = rows()
    }
}
