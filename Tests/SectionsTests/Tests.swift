import UIKit
import XCTest
import Sections

class SectionsTests: XCTestCase {
    struct MyType {
        let val: String
    }

    /**
     Test creating two sections from a homogenious data type.
     */
    func testSections() {
        let rowA = MyType(val: "First Value")
        let rowB = MyType(val: "Second Value")

        let sections = SectionBuilder<MyType>(initialValues: [])
            .addSections { _ in
                return [Section<MyType>(name: "First", rows: [rowA])]
            }.addSections { _ in
                return [Section(name: "Second", rows: [rowB])]
            }

        XCTAssert(sections.sections.count == 2)

        XCTAssert(sections.sections[0].name == "First")
        XCTAssert(sections.sections[0].rows[0] == rowA)
        XCTAssert(sections.sections[0].rows.count == 1)

        XCTAssert(sections.sections[1].name == "Second")
        XCTAssert(sections.sections[1].rows[0] == rowB)
        XCTAssert(sections.sections[1].rows.count == 1)
    }

    /**
     Test returning multiple sections in one closure.
     */
    func testSections2() {
        let rowA = MyType(val: "First Value")
        let rowB = MyType(val: "Second Value")
        let rowC = MyType(val: "Third Value")

        let sections = SectionBuilder<MyType>(initialValues: [])
            .addSections { _ in
                return [Section(name: "First", rows: [rowA])]
            }.addSections { _ in
                return [Section<MyType>(name: "Second", rows: [rowB])]
                + [Section<MyType>(name: "Third", rows: [rowC])]
            }

        XCTAssert(sections.sections.count == 3)

        XCTAssert(sections.sections[0].name == "First")
        XCTAssert(sections.sections[0].rows[0] == rowA)
        XCTAssert(sections.sections[0].rows.count == 1)

        XCTAssert(sections.sections[1].name == "Second")
        XCTAssert(sections.sections[1].rows[0] == rowB)
        XCTAssert(sections.sections[1].rows.count == 1)

        XCTAssert(sections.sections[2].name == "Third")
        XCTAssert(sections.sections[2].rows[0] == rowC)
        XCTAssert(sections.sections[2].rows.count == 1)
    }
}

extension SectionsTests.MyType: Equatable {}

func == (lhs: SectionsTests.MyType, rhs: SectionsTests.MyType) -> Bool {
    return lhs.val == rhs.val
}
