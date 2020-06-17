//
//  SectionTests.swift
//  Sections_Tests
//
//  Created by Erik Strottmann on 6/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

import Sections

final class SectionTests: XCTestCase {
    private struct Row: Equatable {
        var value: Int
    }

    func testInit() {
        let section = Section(name: "Section", rows: [
            Row(value: 10),
            Row(value: 11),
        ])

        XCTAssertEqual(section.name, "Section")
        XCTAssertEqual(section.rows.count, 2)
        XCTAssertEqual(section.rows[0], Row(value: 10))
        XCTAssertEqual(section.rows[1], Row(value: 11))
    }

    func testNonEquatableRows() {
        struct NonEquatable {
            let property: String
        }

        let section = Section(name: "A section", rows: [
            NonEquatable(property: "first"),
            NonEquatable(property: "second")
        ])

        XCTAssertEqual(section.rows.count, 2)
        XCTAssertEqual(section.rows[0].property, "first")
        XCTAssertEqual(section.rows[1].property, "second")
    }

    func testMutatingRows() {
        var section = Section(name: "Some Section", rows: [
            Row(value: 102),
            Row(value: 101),
            Row(value: 100),
        ])

        XCTAssertEqual(section.rows.count, 3)
        XCTAssertEqual(section.rows[0], Row(value: 102))
        XCTAssertEqual(section.rows[1], Row(value: 101))
        XCTAssertEqual(section.rows[2], Row(value: 100))

        section.rows[2] = Row(value: 103)

        XCTAssertEqual(section.rows[0], Row(value: 102))
        XCTAssertEqual(section.rows[1], Row(value: 101))
        XCTAssertEqual(section.rows[2], Row(value: 103), "Mutating a row should change the row")

        var row0 = section.rows[0]
        row0.value = 104

        XCTAssertEqual(row0, Row(value: 104))
        XCTAssertEqual(section.rows[0], Row(value: 102), "Mutating a copy of a row shouldn’t change the section’s row")
        XCTAssertEqual(section.rows[1], Row(value: 101))
        XCTAssertEqual(section.rows[2], Row(value: 103))
    }
}
