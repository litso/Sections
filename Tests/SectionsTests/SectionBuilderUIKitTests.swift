#if canImport(UIKit)
import Sections
import Testing
import UIKit

@Suite("SectionBuilder UIKit")
struct SectionBuilderUIKitTests {
    private enum SectionID: Hashable, Sendable {
        case first
        case second
    }

    private struct Item: Identifiable {
        let id: Int
    }

    @Test("Index paths expose UIKit section and item components")
    func indexPathUsesUIKitComponents() {
        let builder = SectionBuilder<SectionID, Item>(initialSections: [
            Section(.first, items: [Item(id: 1)]),
            Section(.second, items: [Item(id: 2), Item(id: 3)])
        ])

        let indexPath = builder.indexPathOfItem(withID: 3)

        #expect(indexPath?.section == 1)
        #expect(indexPath?.item == 1)
    }

    @Test("Section arrays create diffable snapshots")
    func sectionArraysCreateDiffableSnapshots() {
        let sections = [
            Section<SectionID, Item>(.first, items: [Item(id: 1)]),
            Section<SectionID, Item>(.second, items: [Item(id: 2), Item(id: 3)])
        ]

        let snapshot = sections.snapshot()

        #expect(snapshot.sectionIdentifiers == [.first, .second])
        #expect(snapshot.itemIdentifiers == [1, 2, 3])
        #expect(snapshot.itemIdentifiers(inSection: .first) == [1])
        #expect(snapshot.itemIdentifiers(inSection: .second) == [2, 3])
    }
}
#endif
