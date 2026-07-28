import Foundation
import Sections
import Testing

@Suite("SectionBuilder")
struct SectionBuilderTests {
    private enum SectionID: Hashable, Sendable {
        case first
        case second
        case third
    }

    private struct Item: Identifiable, Sendable {
        let id: String
        let values: [String]
    }

    @Test("Creates sections in registration order")
    func createsSectionsInRegistrationOrder() {
        let builder = SectionBuilder<SectionID, Item>(initialSections: [])
            .addSections { _ in
                [Section(.first, title: "First", items: [Self.item("first")])]
            }
            .addSections { _ in
                [
                    Section(.second, title: "Second", items: [Self.item("second")]),
                    Section(.third, title: "Third", items: [Self.item("third")])
                ]
            }

        #expect(builder.sections.map(\.id) == [.first, .second, .third])
        #expect(builder.sections.map(\.title) == ["First", "Second", "Third"])
    }

    @Test("Returns initial sections without closures")
    func returnsInitialSectionsWithoutClosures() {
        let initial = Section<SectionID, Item>(
            .first,
            title: "Initial",
            items: [Self.item("first")]
        )
        let builder = SectionBuilder<SectionID, Item>(initialSections: [initial])

        #expect(builder.sections.map(\.id) == [.first])
        #expect(builder.sections[0].items.map(\.id) == ["first"])
    }

    @Test("Places generated sections after initial sections")
    func appendsGeneratedSectionsAfterInitialSections() {
        let initial = Section<SectionID, Item>(.first, items: [Self.item("first")])
        let builder = SectionBuilder<SectionID, Item>(initialSections: [initial])
            .addSections { _ in
                [Section(.second, items: [Self.item("second")])]
            }

        #expect(builder.sections.map(\.id) == [.first, .second])
    }

    @Test("Passes the same initial sections to every closure")
    func passesInitialSectionsToClosures() {
        let initial = Section<SectionID, Item>(.first, items: [Self.item("first")])
        var observedSectionIDs = [[SectionID]]()
        let builder = SectionBuilder<SectionID, Item>(initialSections: [initial])
            .addSections { sections in
                observedSectionIDs.append(sections.map(\.id))
                return [Section(.second, items: [Self.item("second")])]
            }
            .addSections { sections in
                observedSectionIDs.append(sections.map(\.id))
                return [Section(.third, items: [Self.item("third")])]
            }

        _ = builder.sections

        #expect(observedSectionIDs == [[.first], [.first]])
    }

    @Test("Ignores empty closure results without disturbing order")
    func ignoresEmptyClosureResults() {
        let builder = SectionBuilder<SectionID, Item>(initialSections: [])
            .addSections { _ in
                [Section(.first, items: [Self.item("first")])]
            }
            .addSections { _ in [] }
            .addSections { _ in
                [Section(.second, items: [Self.item("second")])]
            }

        #expect(builder.sections.map(\.id) == [.first, .second])
    }

    @Test("Finds non-Hashable items by identifier")
    func findsNonHashableItemsByIdentifier() {
        let first = Self.item("first")
        let second = Self.item("second")
        let third = Self.item("third")
        let builder = SectionBuilder<SectionID, Item>(initialSections: [])
            .addSections { _ in
                [Section(.first, items: [first])]
            }
            .addSections { _ in
                [Section(.second, items: [second, third])]
            }

        #expect(builder.indexPathOfItem(withID: first.id) == IndexPath(indexes: [0, 0]))
        #expect(builder.indexPathOfItem(withID: second.id) == IndexPath(indexes: [1, 0]))
        #expect(builder.indexPathOfItem(withID: third.id) == IndexPath(indexes: [1, 1]))
        #expect(builder.indexPathOfItem(withID: "missing") == nil)
    }

#if os(macOS)
    @Test("Rejects duplicate section identifiers")
    func rejectsDuplicateSectionIdentifiers() async {
        await #expect(processExitsWith: .failure) {
            let builder = SectionBuilder<SectionID, Item>(initialSections: [])
                .addSections { _ in
                    [Section(.first, items: [Self.item("first")])]
                }
                .addSections { _ in
                    [Section(.first, items: [Self.item("second")])]
                }
            _ = builder.sections
        }
    }

    @Test("Rejects duplicate item identifiers across sections")
    func rejectsDuplicateItemIdentifiersAcrossSections() async {
        await #expect(processExitsWith: .failure) {
            let builder = SectionBuilder<SectionID, Item>(initialSections: [])
                .addSections { _ in
                    [Section(.first, items: [Self.item("duplicate")])]
                }
                .addSections { _ in
                    [Section(.second, items: [Self.item("duplicate")])]
                }
            _ = builder.sections
        }
    }
#endif

    private static func item(_ id: String) -> Item {
        Item(id: id, values: [id])
    }
}
