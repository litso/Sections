# Sections

[![CI Status](http://img.shields.io/travis/Robert%20Manson/Sections.svg?style=flat)](https://travis-ci.org/Robert%20Manson/Sections)
[![Version](https://img.shields.io/cocoapods/v/Sections.svg?style=flat)](http://cocoapods.org/pods/Sections)
[![License](https://img.shields.io/cocoapods/l/Sections.svg?style=flat)](http://cocoapods.org/pods/Sections)
[![Platform](https://img.shields.io/cocoapods/p/Sections.svg?style=flat)](http://cocoapods.org/pods/Sections)

## Example

To run the example project, clone the repo and open `Example/Sections.xcodeproj` in Xcode. It references the local `Sections` Swift package directly, so there is nothing else to install.

## Requirements

- Swift 6.0 or newer
- iOS 13 or newer
- macOS 10.15 or newer

## Usage

`Section` stores application-level metadata for a table or collection-view
section. Item values only need to conform to `Identifiable`; they do not need to
conform to `Hashable`.

```swift
enum ProfileSectionID: Hashable {
    case friends
}

struct Friend {
    let id: String
    let name: String
}

enum Item: Identifiable {
    case friend(Friend)

    var id: String {
        switch self {
        case .friend(let friend):
            return friend.id
        }
    }
}

let friends = [Friend(id: "alice", name: "Alice")]
let section: Section<ProfileSectionID, Item> = Section(
    .friends,
    title: "Friends",
    items: friends.map(Item.friend)
)
```

Section and item identifiers must be unique when constructing a
`SectionBuilder` result so it can be used safely with diffable snapshots.

## Installation

Sections is available through [CocoaPods](http://cocoapods.org) or SPM.

## Author

Robert Manson, robmanson@gmail.com

## License

Sections is available under the MIT license. See the LICENSE file for more info.
