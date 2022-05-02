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
        let rowA = EquatableType(val: "First Value")
        let rowB = EquatableType(val: "Second Value")
        let rowC = EquatableType(val: "Third Value")

        let sections = SectionBuilder<EquatableType>(initialValues: [])
            .addSections { _ in
                return [Section(name: "First Section", rows: [rowA])]
            }.addSections { _ in
                return [Section(name: "Second Section", rows: [rowB, rowC])]
            }

        XCTAssert(sections.sections.count == 2)

        XCTAssert(sections.sections[0].name == "First Section")
        XCTAssert(sections.sections[0].rows[0] == rowA)
        XCTAssert(sections.sections[0].rows.count == 1)

        XCTAssert(sections.sections[1].rows.count == 2)
        XCTAssert(sections.sections[1].name == "Second Section")
        XCTAssert(sections.sections[1].rows[0] == rowB)
        XCTAssert(sections.sections[1].rows[1] == rowC)

        XCTAssert(sections.indexPathOfValue(rowA) == IndexPath(item: 0, section: 0))
        XCTAssert(sections.indexPathOfValue(rowB) == IndexPath(item: 0, section: 1))
        XCTAssert(sections.indexPathOfValue(rowC) == IndexPath(item: 1, section: 1))
    }

    func testSectionIndexable() {
        func testIndexPathOfValue() {
            let rowA = EquatableType(val: "First Value")
            let rowB = EquatableType(val: "Second Value")
            let rowC = EquatableType(val: "Third Value")

            let sectionBuilder = SectionBuilder<EquatableType>(initialValues: [])
                .addSections { _ in
                    return [Section(name: "First Section", rows: [rowA])]
                }.addSections { _ in
                    return [Section(name: "Second Section", rows: [rowB, rowC])]
                }

            let sections = sectionBuilder.sections

            XCTAssert(sectionBuilder.sections.count == 2)
            XCTAssert(sectionBuilder.sections[0].rows[0] == rowA)
            XCTAssert(sectionBuilder.sections[1].rows[1] == rowC)

            XCTAssert(sections.indexPathForRow(rowA) == IndexPath(item: 0, section: 0))
            XCTAssert(sections.indexPathForRow(rowA) == IndexPath(item: 1, section: 1))
        }
    }
}
