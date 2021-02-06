//
//  RowBuilderTests.swift
//  Sections_Tests
//
//  Created by Erik Strottmann on 6/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

import Sections

final class RowBuilderTests: XCTestCase {
    private struct Row: Equatable {
        var value: String
    }

    private let _false = false
    private let _true = true

    func testSingleExpressionClosure() {
        let section = Section(name: "the section") {
            Row(value: "the row")
        }

        XCTAssertEqual(section.name, "the section")
        XCTAssertEqual(section.rows, [Row(value: "the row")])
    }

    func testMultipleExpressionClosure() {
        let section = Section(name: "a section") {
            Row(value: "a row")
            Row(value: "another row")
        }

        XCTAssertEqual(section.name, "a section")
        XCTAssertEqual(section.rows, [
            Row(value: "a row"),
            Row(value: "another row")
        ])
    }

    func testSingleExpressionBuildIf() {
        let section0 = Section(name: "section") {
            if _true {
                Row(value: "a")
            }
        }
        XCTAssertEqual(section0.rows, [Row(value: "a")])

        let section1 = Section(name: "section") {
            if _false {
                Row(value: "b")
            }
        }
        XCTAssertEqual(section1.rows, [])
    }

    func testMultipleExpressionBuildIf() {
        let section = Section(name: "section") {
            if _true {
                Row(value: "a")
                Row(value: "b")
            }
            if _false {
                Row(value: "c")
                Row(value: "d")
            }
        }

        XCTAssertEqual(section.rows, [
            Row(value: "a"),
            Row(value: "b")
        ])
    }

    func testSingleExpressionBuildEither() {
        let section0 = Section(name: "section") {
            if _true {
                Row(value: "a")
            } else {
                Row(value: "b")
            }
        }
        XCTAssertEqual(section0.rows, [Row(value: "a")])

        let section1 = Section(name: "section") {
            if _false {
                Row(value: "c")
            } else {
                Row(value: "d")
            }
        }
        XCTAssertEqual(section1.rows, [Row(value: "d")])
    }

    func testMultipleExpressionBuildEither() {
        let section = Section(name: "section") {
            if _true {
                Row(value: "a")
                Row(value: "b")
            } else {
                Row(value: "c")
                Row(value: "d")
            }

            if _false {
                Row(value: "e")
                Row(value: "f")
            } else {
                Row(value: "g")
                Row(value: "h")
            }
        }

        XCTAssertEqual(section.rows, [
            Row(value: "a"),
            Row(value: "b"),
            Row(value: "g"),
            Row(value: "h")
        ])
    }

    func testSingleExpressionBuildEitherAndBuildIf() {
        func showRow(at index: Int) -> Bool {
            return index.isMultiple(of: 3)
        }

        let section0 = Section(name: "section") {
            if _true {
                Row(value: "a")
            } else if _false {
                Row(value: "b")
            } else {
                Row(value: "c")
            }
        }
        XCTAssertEqual(section0.rows, [Row(value: "a")])

        let section1 = Section(name: "section") {
            if _false {
                Row(value: "d")
            } else if _true {
                Row(value: "e")
            } else {
                Row(value: "f")
            }
        }
        XCTAssertEqual(section1.rows, [Row(value: "e")])

        let section2 = Section(name: "section") {
            if _false {
                Row(value: "g")
            } else if _false {
                Row(value: "h")
            } else {
                Row(value: "i")
            }
        }
        XCTAssertEqual(section2.rows, [Row(value: "i")])
    }

    func testMultipleExpressionBuildEitherAndBuildIf() {
        func showRow(at index: Int) -> Bool {
            return index.isMultiple(of: 3)
        }

        let section = Section(name: "section") {
            if _true {
                Row(value: "a")
                Row(value: "b")
            } else if _false {
                Row(value: "c")
                Row(value: "d")
            } else {
                Row(value: "e")
                Row(value: "f")
            }

            if _false {
                Row(value: "g")
                Row(value: "h")
            } else if _true {
                Row(value: "i")
                Row(value: "j")
            } else {
                Row(value: "k")
                Row(value: "l")
            }

            if _false {
                Row(value: "m")
                Row(value: "n")
            } else if _false {
                Row(value: "o")
                Row(value: "p")
            } else {
                Row(value: "q")
                Row(value: "r")
            }
        }

        XCTAssertEqual(section.rows, [
            Row(value: "a"),
            Row(value: "b"),
            Row(value: "i"),
            Row(value: "j"),
            Row(value: "q"),
            Row(value: "r")
        ])
    }
}
