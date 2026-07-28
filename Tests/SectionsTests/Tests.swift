import Sections
import XCTest

final class SectionsTests: XCTestCase {
    private enum SectionID: Hashable {
        case first
        case second
        case third
    }

    private struct Item: Identifiable {
        let id: Int
        let value: String
    }

    func testSectionInitializer() {
        let item = Item(id: 1, value: "First Value")
        let section = Section<SectionID, Item>(.first, title: "First", items: [item])

        XCTAssertEqual(section.id, SectionID.first)
        XCTAssertEqual(section.title, "First")
        XCTAssertEqual(section.items.map(\.id), [1])
        XCTAssertEqual(section.items.map(\.value), ["First Value"])
    }

    func testSectionTitleDefaultsToNil() {
        let section = Section<SectionID, Item>(.first, items: [])

        XCTAssertNil(section.title)
    }

    func testBuilderCreatesSections() {
        let firstItem = Item(id: 1, value: "First Value")
        let secondItem = Item(id: 2, value: "Second Value")

        let builder = SectionBuilder<SectionID, Item>(initialValues: [])
            .addSections { _ in
                [Section(.first, title: "First", items: [firstItem])]
            }
            .addSections { _ in
                [Section(.second, title: "Second", items: [secondItem])]
            }

        XCTAssertEqual(builder.sections.map(\.id), [.first, .second])
        XCTAssertEqual(builder.sections.map(\.title), ["First", "Second"])
        XCTAssertEqual(builder.sections[0].items.map(\.id), [1])
        XCTAssertEqual(builder.sections[1].items.map(\.id), [2])
    }

    func testBuilderCanReturnMultipleSections() {
        let items = [
            Item(id: 1, value: "First Value"),
            Item(id: 2, value: "Second Value"),
            Item(id: 3, value: "Third Value")
        ]

        let builder = SectionBuilder<SectionID, Item>(initialValues: [])
            .addSections { _ in
                [Section(.first, title: "First", items: [items[0]])]
            }
            .addSections { _ in
                [
                    Section(.second, title: "Second", items: [items[1]]),
                    Section(.third, title: "Third", items: [items[2]])
                ]
            }

        XCTAssertEqual(builder.sections.map(\.id), [.first, .second, .third])
        XCTAssertEqual(builder.sections.map { $0.items.count }, [1, 1, 1])
    }
}
