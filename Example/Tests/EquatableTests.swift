//
//  EquatableTests.swift
//  Sections
//
//  Created by Robert Manson on 7/25/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
import Sections

struct EquatableType {
    let val: String
}

extension EquatableType: Equatable {}

func == (lhs: EquatableType, rhs: EquatableType) -> Bool {
    return lhs.val == rhs.val
}

class EquatableTests: XCTestCase {

    /**
     Test indexPathOfValue
     */
    func testIndexPathOfValue() {
        let a = EquatableType(val: "First Value")
        let b = EquatableType(val: "Second Value")
        let c = EquatableType(val: "Third Value")

        var values = [ a, b, c]

        let sections = SectionBuilder<EquatableType>(initialValues: []).addSections { _ in
            return [Section(name: "First Section", rows: [values[0]])]
            }.addSections { _ in
                return [Section(name: "Second Section", rows: [values[1], values[2]])]
        }

        XCTAssert(sections.sections.count == 2)

        XCTAssert(sections.sections[0].name == "First Section")
        XCTAssert(sections.sections[0].rows[0] == a)
        XCTAssert(sections.sections[0].rows.count == 1)

        XCTAssert(sections.sections[1].rows.count == 2)
        XCTAssert(sections.sections[1].name == "Second Section")
        XCTAssert(sections.sections[1].rows[0] == b)
        XCTAssert(sections.sections[1].rows[1] == c)


        XCTAssert(sections.indexPathOfValue(a) == NSIndexPath(forItem: 0, inSection: 0))
        XCTAssert(sections.indexPathOfValue(b) == NSIndexPath(forItem: 0, inSection: 1))
        XCTAssert(sections.indexPathOfValue(c) == NSIndexPath(forItem: 1, inSection: 1))
    }

    func testSectionIndexable() {
        func testIndexPathOfValue() {
            let a = EquatableType(val: "First Value")
            let b = EquatableType(val: "Second Value")
            let c = EquatableType(val: "Third Value")

            var values = [ a, b, c]

            let sectionBuilder = SectionBuilder<EquatableType>(initialValues: []).addSections { _ in
                return [Section(name: "First Section", rows: [values[0]])]
                }.addSections { _ in
                    return [Section(name: "Second Section", rows: [values[1], values[2]])]
            }

            let sections = sectionBuilder.sections

            XCTAssert(sectionBuilder.sections.count == 2)
            XCTAssert(sectionBuilder.sections[0].rows[0] == a)
            XCTAssert(sectionBuilder.sections[1].rows[1] == c)

            XCTAssert(sections.indexPathForRow(a) == NSIndexPath(forItem: 0, inSection: 0))
            XCTAssert(sections.indexPathForRow(a) == NSIndexPath(forItem: 1, inSection: 1))
        }
    }
}
