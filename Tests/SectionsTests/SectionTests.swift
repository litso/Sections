import Foundation
import Sections
import Testing

@Suite("Section")
struct SectionTests {
    private enum SectionID: Hashable, Sendable {
        case friends
    }

    private struct Item: Identifiable, Sendable {
        let id: Int
        let value: String
    }

    private struct Friend: Sendable {
        let id: Int
    }

    private enum ProfileItem: Identifiable, Sendable {
        case friend(Friend)

        var id: Int {
            switch self {
            case .friend(let friend):
                return friend.id
            }
        }
    }

    @Test("Initializer stores immutable metadata and items")
    func initializerStoresValues() {
        let item = Item(id: 1, value: "First Value")
        let section = Section<SectionID, Item>(.friends, title: "Friends", items: [item])

        #expect(section.id == .friends)
        #expect(section.title == "Friends")
        #expect(section.items.map(\.id) == [1])
        #expect(section.items.map(\.value) == ["First Value"])
    }

    @Test("Initializer uses contextual generic type inference")
    func initializerUsesContextualTypeInference() {
        let friends = [Friend(id: 1)]
        let section: Section<SectionID, ProfileItem> = Section(
            .friends,
            title: "Friends",
            items: friends.map(ProfileItem.friend)
        )

        #expect(section.id == .friends)
        #expect(section.items.map(\.id) == [1])
    }

    @Test("Title defaults to nil")
    func titleDefaultsToNil() {
        let section = Section<SectionID, Item>(.friends, items: [])

        #expect(section.title == nil)
    }

#if os(macOS)
    @Test("Rejects duplicate item identifiers")
    func rejectsDuplicateItemIdentifiers() async {
        await #expect(processExitsWith: .failure) {
            _ = Section<SectionID, Item>(
                .friends,
                items: [
                    Item(id: 1, value: "Alice"),
                    Item(id: 1, value: "Another Alice")
                ]
            )
        }
    }

    @Test("Public metadata is immutable")
    func publicMetadataIsImmutable() throws {
        let testsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        let packageDirectory = testsDirectory
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let sectionSource = packageDirectory
            .appendingPathComponent("Sources/Sections/Classes/Section.swift")
        let fixture = testsDirectory
            .appendingPathComponent("Fixtures/MutateSection.swift.fixture")
        let temporaryDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let stagedFixture = temporaryDirectory.appendingPathComponent("MutateSection.swift")
        try FileManager.default.createDirectory(
            at: temporaryDirectory,
            withIntermediateDirectories: true
        )
        try FileManager.default.copyItem(at: fixture, to: stagedFixture)
        defer { try? FileManager.default.removeItem(at: temporaryDirectory) }

        let process = Process()
        let standardError = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        process.arguments = [
            "swiftc",
            "-typecheck",
            sectionSource.path,
            stagedFixture.path
        ]
        process.standardError = standardError

        try process.run()
        process.waitUntilExit()

        let diagnostics = String(
            decoding: standardError.fileHandleForReading.readDataToEndOfFile(),
            as: UTF8.self
        )

        #expect(process.terminationStatus != 0)
        #expect(diagnostics.contains("'id' is a 'let' constant"))
        #expect(diagnostics.contains("'title' is a 'let' constant"))
        #expect(diagnostics.contains("'items' is a 'let' constant"))
    }
#endif
}
