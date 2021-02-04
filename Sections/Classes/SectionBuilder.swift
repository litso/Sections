//
//  SectionBuilder.swift
//  Sections
//
//  Created by Robert Manson on 8/20/16.
//
//

@resultBuilder
public struct SectionBuilder {
    public static func buildExpression<Row>(_ section: Section<Row>) -> [Section<Row>] {
        return [section]
    }

    public static func buildBlock<Row>(_ sections: [Section<Row>]...) -> [Section<Row>] {
        return sections.flatMap { $0 }
    }

    public static func buildIf<Row>(_ sections: [Section<Row>]?) -> [Section<Row>] {
        return sections ?? []
    }

    public static func buildEither<Row>(first sections: [Section<Row>]) -> [Section<Row>] {
        return sections
    }

    public static func buildEither<Row>(second sections: [Section<Row>]) -> [Section<Row>] {
        return sections
    }
}
