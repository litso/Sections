//
//  SectionBuilderTests.swift
//  Sections_Tests
//
//  Created by Erik Strottmann on 6/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

import Sections

final class SectionBuilderTests: XCTestCase {
    func testInit() {
        let initialValues = Sections(sections: [
            Section(name: "initial section", rows: ["initial row"])
        ])
        let sectionBuilder = SectionBuilder(initialValues: initialValues).addSections { _ in
            Sections(sections: [
                Section(name: "first section", rows: ["first row", "second row"]),
                Section(name: "second section", rows: ["third row", "fourth row"]),
            ])
        }.addSections { initialValues in
            initialValues + Sections(sections: [
                Section(name: "third section", rows: ["fifth row"])
            ])
        }

        let values = sectionBuilder.values
        XCTAssertEqual(values.count, 1)
        XCTAssertEqual(values[0].name, "initial section")
        XCTAssertEqual(values[0].rows, ["initial row"])

        let sections = sectionBuilder.sections
        XCTAssertEqual(sections.count, 4)
        XCTAssertEqual(sections[0].name, "first section")
        XCTAssertEqual(sections[0].rows, ["first row", "second row"])
        XCTAssertEqual(sections[1].name, "second section")
        XCTAssertEqual(sections[1].rows, ["third row", "fourth row"])
        XCTAssertEqual(sections[2].name, "initial section")
        XCTAssertEqual(sections[2].rows, ["initial row"])
        XCTAssertEqual(sections[3].name, "third section")
        XCTAssertEqual(sections[3].rows, ["fifth row"])
    }

    func testMutatingValues() {
        let initialValues = Sections(sections: [
            Section(name: "initial", rows: [0])
        ])
        var sectionBuilder = SectionBuilder(initialValues: initialValues).addSections { initialValues in
            initialValues + Sections(sections: [
                Section(name: "first", rows: [-1, 1])
            ])
        }.addSections { initialValues in
            initialValues + Sections(sections: [
                Section(name: "second", rows: [-2, 2])
            ])
        }.addSections { _ in
            Sections(sections: [
                Section(name: "third", rows: [-3, 3])
            ])
        }

        let sections = sectionBuilder.sections
        XCTAssertEqual(sections.count, 5)
        XCTAssertEqual(sections[0].name, "initial")
        XCTAssertEqual(sections[0].rows, [0])
        XCTAssertEqual(sections[1].name, "first")
        XCTAssertEqual(sections[1].rows, [-1, 1])
        XCTAssertEqual(sections[2].name, "initial")
        XCTAssertEqual(sections[2].rows, [0])
        XCTAssertEqual(sections[3].name, "second")
        XCTAssertEqual(sections[3].rows, [-2, 2])
        XCTAssertEqual(sections[4].name, "third")
        XCTAssertEqual(sections[4].rows, [-3, 3])

        sectionBuilder.values = Sections(sections: [
            Section(name: "initial prime first", rows: [.min, .max]),
            Section(name: "initial prime second", rows: [.min + 1, .max - 1])
        ])

        let sectionsPrime = sectionBuilder.sections
        XCTAssertEqual(sectionsPrime.count, 7)
        XCTAssertEqual(sectionsPrime[0].name, "initial prime first")
        XCTAssertEqual(sectionsPrime[0].rows, [.min, .max])
        XCTAssertEqual(sectionsPrime[1].name, "initial prime second")
        XCTAssertEqual(sectionsPrime[1].rows, [.min + 1, .max - 1])
        XCTAssertEqual(sectionsPrime[2].name, "first")
        XCTAssertEqual(sectionsPrime[2].rows, [-1, 1])
        XCTAssertEqual(sectionsPrime[3].name, "initial prime first")
        XCTAssertEqual(sectionsPrime[3].rows, [.min, .max])
        XCTAssertEqual(sectionsPrime[4].name, "initial prime second")
        XCTAssertEqual(sectionsPrime[4].rows, [.min + 1, .max - 1])
        XCTAssertEqual(sectionsPrime[5].name, "second")
        XCTAssertEqual(sectionsPrime[5].rows, [-2, 2])
        XCTAssertEqual(sectionsPrime[6].name, "third")
        XCTAssertEqual(sectionsPrime[6].rows, [-3, 3])
    }

    func testIndexPathOfValue() {
        let initialValues = Sections(sections: [
            Section(name: "initial", rows: ["a"])
        ])
        let sectionBuilder = SectionBuilder(initialValues: initialValues).addSections { initialValues in
            Sections(sections: [
                Section(name: "one", rows: ["b"])
            ]) + initialValues
        }.addSections { initialValues in
            initialValues + Sections(sections: [
                Section(name: "two", rows: ["c", "d"])
            ])
        }

        XCTAssertEqual(
            sectionBuilder.indexPathOfValue("a"),
            IndexPath(row: 0, section: 1),
            "indexPathOfValue(_:) should return the index path of the first instance of the row"
        )
        XCTAssertEqual(sectionBuilder.indexPathOfValue("b"), IndexPath(row: 0, section: 0))
        XCTAssertEqual(sectionBuilder.indexPathOfValue("c"), IndexPath(row: 0, section: 3))
        XCTAssertEqual(sectionBuilder.indexPathOfValue("d"), IndexPath(row: 1, section: 3))
        XCTAssertNil(sectionBuilder.indexPathOfValue("e"))
    }
}
