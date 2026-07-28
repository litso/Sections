import Sections
import XCTest

final class ItemIdentityTests: XCTestCase {
    private enum SectionID: Hashable {
        case first
        case second
    }

    private struct NonHashableItem: Identifiable {
        let id: String
        let values: [String]
    }

    func testIndexPathLookupUsesItemID() {
        let first = NonHashableItem(id: "first", values: ["First Value"])
        let second = NonHashableItem(id: "second", values: ["Second Value"])
        let third = NonHashableItem(id: "third", values: ["Third Value"])

        let builder = SectionBuilder<SectionID, NonHashableItem>(initialValues: [])
            .addSections { _ in
                [Section(.first, title: "First Section", items: [first])]
            }
            .addSections { _ in
                [Section(.second, title: "Second Section", items: [second, third])]
            }

        XCTAssertEqual(builder.indexPathOfItem(withID: first.id), IndexPath(indexes: [0, 0]))
        XCTAssertEqual(builder.indexPathOfItem(withID: second.id), IndexPath(indexes: [1, 0]))
        XCTAssertEqual(builder.indexPathOfItem(withID: third.id), IndexPath(indexes: [1, 1]))
        XCTAssertNil(builder.indexPathOfItem(withID: "missing"))
    }
}
