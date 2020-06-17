//
//  SectionsTests.swift
//  Sections_Tests
//
//  Created by Erik Strottmann on 6/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

import Sections

final class SectionsTests: XCTestCase {
    private struct Row: Equatable {
        var value: Int
    }

    func testInit() {
        let sections = Sections(sections: [
            Section(name: "A section", rows: [
                Row(value: 100)
            ]),
            Section(name: "Another section", rows: [
                Row(value: 101),
                Row(value: 102)
            ])
        ])

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].name, "A section")
        XCTAssertEqual(sections[0].rows.count, 1)
        XCTAssertEqual(sections[0].rows[0], Row(value: 100))
        XCTAssertEqual(sections[1].name, "Another section")
        XCTAssertEqual(sections[1].rows.count, 2)
        XCTAssertEqual(sections[1].rows[0], Row(value: 101))
        XCTAssertEqual(sections[1].rows[1], Row(value: 102))
    }

    func testNonEquatableRows() {
        struct NonEquatable {
            let tuple: (Int, Int)
        }

        let sections = Sections(sections: [
            Section(name: "THE SECTION", rows: [
                NonEquatable(tuple: (-1, 1)),
                NonEquatable(tuple: (.max, 1234))
            ])
        ])

        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections[0].rows.count, 2)
        XCTAssertEqual(sections[0].rows[0].tuple.0, -1)
        XCTAssertEqual(sections[0].rows[0].tuple.1, 1)
        XCTAssertEqual(sections[0].rows[1].tuple.0, .max)
        XCTAssertEqual(sections[0].rows[1].tuple.1, 1234)
    }

    func testMutating() {
        var sections = Sections(sections: [
            Section(name: "A", rows: [
                Row(value: 1),
                Row(value: 11)
            ]),
            Section(name: "B", rows: [
                Row(value: 2)
            ])
        ])

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].rows.count, 2)
        XCTAssertEqual(sections[0].rows[0], Row(value: 1))
        XCTAssertEqual(sections[0].rows[1], Row(value: 11))
        XCTAssertEqual(sections[1].rows.count, 1)
        XCTAssertEqual(sections[1].rows[0], Row(value: 2))

        sections[1] = Section(name: "B prime", rows: [
            Row(value: 22),
            Row(value: 222),
        ])

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].rows.count, 2)
        XCTAssertEqual(sections[0].rows[0], Row(value: 1))
        XCTAssertEqual(sections[0].rows[1], Row(value: 11))
        XCTAssertEqual(sections[1].rows.count, 2, "Mutating a section should change the section")
        XCTAssertEqual(sections[1].rows[0], Row(value: 22), "Mutating a section should change the section")
        XCTAssertEqual(sections[1].rows[1], Row(value: 222), "Mutating a section should change the section")

        var section0 = sections[0]
        section0.rows[1].value = 111

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].rows.count, 2)
        XCTAssertEqual(sections[0].rows[0], Row(value: 1))
        XCTAssertEqual(
            sections[0].rows[1],
            Row(value: 11),
            "Mutating a copy of a section shouldn’t change the collection’s section"
        )
        XCTAssertEqual(sections[1].rows.count, 2)
        XCTAssertEqual(sections[1].rows[0], Row(value: 22))
        XCTAssertEqual(sections[1].rows[1], Row(value: 222))
    }

    func testIndexPathForRow() {
        let sections = Sections(sections: [
            Section(name: "one", rows: [
                Row(value: 0),
                Row(value: 1),
                Row(value: 0)
            ]),
            Section(name: "two", rows: [
                Row(value: 0),
                Row(value: 2),
                Row(value: 0)
            ])
        ])

        XCTAssertEqual(
            sections.indexPathForRow(Row(value: 0)),
            IndexPath(row: 0, section: 0),
            "indexPathForRow(_:) should return the index path of the first instance of the row"
        )
        XCTAssertEqual(sections.indexPathForRow(Row(value: 1)), IndexPath(row: 1, section: 0))
        XCTAssertEqual(sections.indexPathForRow(Row(value: 2)), IndexPath(row: 1, section: 1))
        XCTAssertNil(sections.indexPathForRow(Row(value: 3)))
    }

    func testSequenceConformance() {
        let sections = Sections(sections: [
            Section(name: "x", rows: [
                Row(value: 2),
                Row(value: 3)
            ]),
            Section(name: "y", rows: [
                Row(value: 5)
            ]),
        ])

        var combinedName = ""
        var combinedValue = 1

        for section in sections {
            combinedName += section.name
            for row in section.rows {
                combinedValue *= row.value
            }
        }

        XCTAssertEqual(combinedName, "xy")
        XCTAssertEqual(combinedValue, 30)
    }

    func testCollectionConformance() {
        var sections = Sections(sections: [
            Section(name: "g", rows: [Row(value: 9)]),
            Section(name: "G", rows: [Row(value: 6)])
        ])

        XCTAssertEqual(sections.startIndex, 0)
        XCTAssertEqual(sections.endIndex, 2)

        XCTAssertEqual(sections[0].name, "g")
        XCTAssertEqual(sections[0].rows, [Row(value: 9)])
        XCTAssertEqual(sections[1].name, "G")
        XCTAssertEqual(sections[1].rows, [Row(value: 6)])

        sections[0] = Section(name: "S", rows: [Row(value: 5)])

        XCTAssertEqual(sections[0].name, "S")
        XCTAssertEqual(sections[0].rows, [Row(value: 5)])
        XCTAssertEqual(sections[1].name, "G")
        XCTAssertEqual(sections[1].rows, [Row(value: 6)])

        XCTAssertEqual(sections.index(after: sections.startIndex), 1)
        XCTAssertEqual(sections.index(after: sections.endIndex), 3)
    }

    func testRangeReplaceableCollectionConformance() {
        let emptySections = Sections<Row>()
        XCTAssertTrue(emptySections.isEmpty)

        var sections = Sections(sections: [
            Section(name: "p", rows: [Row(value: 2)]),
            Section(name: "q", rows: [Row(value: 4)]),
            Section(name: "r", rows: [Row(value: 6)])
        ])

        XCTAssertEqual(sections.count, 3)
        XCTAssertEqual(sections[0].name, "p")
        XCTAssertEqual(sections[0].rows, [Row(value: 2)])
        XCTAssertEqual(sections[1].name, "q")
        XCTAssertEqual(sections[1].rows, [Row(value: 4)])
        XCTAssertEqual(sections[2].name, "r")
        XCTAssertEqual(sections[2].rows, [Row(value: 6)])

        sections.replaceSubrange(0..<2, with: [
            Section(name: "s", rows: [
                Row(value: 8),
                Row(value: 0),
            ])
        ])

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].name, "s")
        XCTAssertEqual(sections[0].rows, [Row(value: 8), Row(value: 0)])
        XCTAssertEqual(sections[1].name, "r")
        XCTAssertEqual(sections[1].rows, [Row(value: 6)])
    }

    func testExpressibleByArrayLiteralConformance() {
        let sections: Sections = [
            Section(name: "array 0", rows: [
                Row(value: 0),
                Row(value: 1),
            ]),
            Section(name: "array 1", rows: [
                Row(value: 2)
            ]),
        ]

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].name, "array 0")
        XCTAssertEqual(sections[0].rows.count, 2)
        XCTAssertEqual(sections[0].rows[0], Row(value: 0))
        XCTAssertEqual(sections[0].rows[1], Row(value: 1))
        XCTAssertEqual(sections[1].name, "array 1")
        XCTAssertEqual(sections[1].rows.count, 1)
        XCTAssertEqual(sections[1].rows[0], Row(value: 2))
    }
}
