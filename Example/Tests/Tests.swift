import UIKit
import XCTest
import Sections

class SectionsTests: XCTestCase {
    struct MyType {
        let val: String
    }


    func testSections() {
        let a = MyType(val: "First Value")
        let b = MyType(val: "Second Value")

        var sections = BuildSection<MyType>(values: []).addSection { values in
            return Section(name: "First", rows: [values[0]])
            }.addSection { values in
                return Section(name: "Second", rows: [values[1]])
        }

        sections.values = [ a, b]

        XCTAssert(sections.sections.count == 2)

        XCTAssert(sections.sections[0].name == "First")
        XCTAssert(sections.sections[0].rows[0] == a)
        XCTAssert(sections.sections[0].rows.count == 1)

        XCTAssert(sections.sections[1].name == "Second")
        XCTAssert(sections.sections[1].rows[0] == b)
        XCTAssert(sections.sections[1].rows.count == 1)
    }
}


extension SectionsTests.MyType: Equatable {}

func == (lhs: SectionsTests.MyType, rhs: SectionsTests.MyType) -> Bool {
    return lhs.val == rhs.val
}
