#if canImport(UIKit)
import UIKit

public extension Array {
    /// Builds a diffable snapshot while preserving section and item order.
    func snapshot<SectionID, Item>() -> NSDiffableDataSourceSnapshot<SectionID, Item.ID>
    where Element == Section<SectionID, Item>,
          SectionID: Hashable & Sendable,
          Item: Identifiable,
          Item.ID: Sendable {
        var snapshot = NSDiffableDataSourceSnapshot<SectionID, Item.ID>()

        for section in self {
            snapshot.appendSections([section.id])
            snapshot.appendItems(section.items.map(\.id), toSection: section.id)
        }

        return snapshot
    }
}
#endif
