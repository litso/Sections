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
        let a = MyType(val: "First Value")
        let b = MyType(val: "Second Value")

        let sections = SectionBuilder<MyType>(initialValues: []).addSections { _ in
            return [Section<MyType>(name: "First", rows: [a])]
            }.addSections { _ in
                return [Section(name: "Second", rows: [b])]
        }

        XCTAssert(sections.sections.count == 2)

        XCTAssert(sections.sections[0].name == "First")
        XCTAssert(sections.sections[0].rows[0] == a)
        XCTAssert(sections.sections[0].rows.count == 1)

        XCTAssert(sections.sections[1].name == "Second")
        XCTAssert(sections.sections[1].rows[0] == b)
        XCTAssert(sections.sections[1].rows.count == 1)
    }

    /**
     Test changing the `values` captured by the section build after the capture. Also test returning multiple sections in one closure.
     */
    func testSections2() {
        let a = MyType(val: "First Value")
        let b = MyType(val: "Second Value")
        let c = MyType(val: "Third Value")

        var values = [a, b, c]

        let sections = SectionBuilder<MyType>(initialValues: []).addSections { _ in
            return [Section(name: "First", rows: [values[0]])]
            }.addSections { _ in
                return [Section<MyType>(name: "Second", rows: [values[1]])]
                    + [Section<MyType>(name: "Third", rows: [values[2]])]
        }

        XCTAssert(sections.sections.count == 3)

        XCTAssert(sections.sections[0].name == "First")
        XCTAssert(sections.sections[0].rows[0] == a)
        XCTAssert(sections.sections[0].rows.count == 1)

        XCTAssert(sections.sections[1].name == "Second")
        XCTAssert(sections.sections[1].rows[0] == b)
        XCTAssert(sections.sections[1].rows.count == 1)

        XCTAssert(sections.sections[2].name == "Third")
        XCTAssert(sections.sections[2].rows[0] == c)
        XCTAssert(sections.sections[2].rows.count == 1)
    }
}


extension SectionsTests.MyType: Equatable {}

func == (lhs: SectionsTests.MyType, rhs: SectionsTests.MyType) -> Bool {
    return lhs.val == rhs.val
}
