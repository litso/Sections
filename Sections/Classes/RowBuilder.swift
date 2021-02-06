//
//  RowBuilder.swift
//  Sections
//
//  Created by Erik Strottmann on 6/17/20.
//

@resultBuilder
public struct RowBuilder {
    public static func buildExpression<Row>(_ row: Row) -> [Row] {
        return [row]
    }

    public static func buildBlock<Row>(_ rows: [Row]...) -> [Row] {
        return rows.flatMap { $0 }
    }

    public static func buildIf<Row>(_ rows: [Row]?) -> [Row] {
        return rows ?? []
    }

    public static func buildEither<Row>(first rows: [Row]) -> [Row] {
        return rows
    }

    public static func buildEither<Row>(second rows: [Row]) -> [Row] {
        return rows
    }
}
