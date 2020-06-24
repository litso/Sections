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
    private struct Row: Equatable {
        var value: String
    }

    private let _false = false
    private let _true = true

    func testSingleExpressionClosure() {
        // Single-expression closures don’t use function builders as of
        // Swift 5.2. As a workaround, we can return an array of one row.
        // See https://bugs.swift.org/browse/SR-11628
        let sections = Sections {
            [Section(name: "the section") {
                [Row(value: "the row")]
            }]
        }

        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections[0].name, "the section")
        XCTAssertEqual(sections[0].rows, [Row(value: "the row")])
    }

    func testMultipleExpressionClosure() {
        let sections = Sections {
            Section(name: "a section") {
                Row(value: "a row")
                Row(value: "another row")
            }
            Section(name: "another section") {
                Row(value: "another other row")
                Row(value: "another other other row")
            }
        }

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].name, "a section")
        XCTAssertEqual(sections[0].rows, [
            Row(value: "a row"),
            Row(value: "another row")
        ])
        XCTAssertEqual(sections[1].name, "another section")
        XCTAssertEqual(sections[1].rows, [
            Row(value: "another other row"),
            Row(value: "another other other row")
        ])
    }

    func testComplexClosure() {
        let section0 = Section(name: "section 0") {
            Row(value: "row 0")
            Row(value: "row 1")
        }

        func makeRow(index: Int) -> Row {
            return Row(value: "row \(index)")
        }

        let sections = Sections {
            section0
            if _true {
                if _false {
                    Section(name: "section 1") {
                        if _true {
                            makeRow(index: 0)
                        }
                        Row(value: "row 1")
                    }
                } else if _false {
                    Section(name: "section 2") {
                        Row(value: "row 0")
                        if _true {
                            Row(value: "row 1")
                        } else {
                            Row(value: "row 2")
                        }
                    }
                } else {
                    Section(name: "section 3") {
                        Row(value: "row 0")
                        makeRow(index: 1)
                    }
                }
            }
            section0
        }

        XCTAssertEqual(sections.count, 3)
        XCTAssertEqual(sections[0].name, "section 0")
        XCTAssertEqual(sections[0].rows, [
            Row(value: "row 0"),
            Row(value: "row 1")
        ])
        XCTAssertEqual(sections[1].name, "section 3")
        XCTAssertEqual(sections[1].rows, [
            Row(value: "row 0"),
            Row(value: "row 1")
        ])
        XCTAssertEqual(sections[2].name, "section 0")
        XCTAssertEqual(sections[2].rows, [
            Row(value: "row 0"),
            Row(value: "row 1")
        ])
    }

    func testSingleExpressionBuildIf() {
        let sections0 = Sections {
            if _true {
                Section(name: "section a") {
                    [Row(value: "a")]
                }
            }
        }
        XCTAssertEqual(sections0.count, 1)
        XCTAssertEqual(sections0[0].name, "section a")
        XCTAssertEqual(sections0[0].rows, [Row(value: "a")])

        let sections1 = Sections {
            if _false {
                Section(name: "section b") {
                    [Row(value: "b")]
                }
            }
        }
        XCTAssertEqual(sections1.count, 0)
    }

    func testMultipleExpressionBuildIf() {
        let sections = Sections {
            if _true {
                Section(name: "section a") {
                    Row(value: "a")
                    Row(value: "b")
                }
                Section(name: "section b") {
                    Row(value: "c")
                    Row(value: "d")
                }
            }
            if _false {
                Section(name: "section c") {
                    Row(value: "e")
                    Row(value: "f")
                }
                Section(name: "section d") {
                    Row(value: "g")
                    Row(value: "h")
                }
            }
        }

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].name, "section a")
        XCTAssertEqual(sections[0].rows, [Row(value: "a"), Row(value: "b")])
        XCTAssertEqual(sections[1].name, "section b")
        XCTAssertEqual(sections[1].rows, [Row(value: "c"), Row(value: "d")])
    }

    func testSingleExpressionBuildEither() {
        let sections0 = Sections {
            if _true {
                Section(name: "section a") {
                    [Row(value: "a")]
                }
            } else {
                Section(name: "section b") {
                    [Row(value: "b")]
                }
            }
        }
        XCTAssertEqual(sections0.count, 1)
        XCTAssertEqual(sections0[0].name, "section a")
        XCTAssertEqual(sections0[0].rows, [Row(value: "a")])

        let sections1 = Sections {
            if _false {
                Section(name: "section c") {
                    [Row(value: "c")]
                }
            } else {
                Section(name: "section d") {
                    [Row(value: "d")]
                }
            }
        }
        XCTAssertEqual(sections1.count, 1)
        XCTAssertEqual(sections1[0].name, "section d")
        XCTAssertEqual(sections1[0].rows, [Row(value: "d")])
    }

    func testMultipleExpressionBuildEither() {
        let sections = Sections {
            if _true {
                Section(name: "section a") {
                    Row(value: "a")
                    Row(value: "b")
                }
                Section(name: "section b") {
                    Row(value: "c")
                    Row(value: "d")
                }
            } else {
                Section(name: "section c") {
                    Row(value: "e")
                    Row(value: "f")
                }
                Section(name: "section d") {
                    Row(value: "g")
                    Row(value: "h")
                }
            }

            if _false {
                Section(name: "section e") {
                    Row(value: "i")
                    Row(value: "j")
                }
                Section(name: "section f") {
                    Row(value: "k")
                    Row(value: "l")
                }
            } else {
                Section(name: "section g") {
                    Row(value: "m")
                    Row(value: "n")
                }
                Section(name: "section h") {
                    Row(value: "o")
                    Row(value: "p")
                }
            }
        }

        XCTAssertEqual(sections.count, 4)
        XCTAssertEqual(sections[0].name, "section a")
        XCTAssertEqual(sections[0].rows, [Row(value: "a"), Row(value: "b")])
        XCTAssertEqual(sections[1].name, "section b")
        XCTAssertEqual(sections[1].rows, [Row(value: "c"), Row(value: "d")])
        XCTAssertEqual(sections[2].name, "section g")
        XCTAssertEqual(sections[2].rows, [Row(value: "m"), Row(value: "n")])
        XCTAssertEqual(sections[3].name, "section h")
        XCTAssertEqual(sections[3].rows, [Row(value: "o"), Row(value: "p")])
    }

    func testSingleExpressionBuildEitherAndBuildIf() {
        let sections0 = Sections {
            if _true {
                Section(name: "section a") {
                    [Row(value: "a")]
                }
            } else if _false {
                Section(name: "section b") {
                    [Row(value: "b")]
                }
            } else {
                Section(name: "section c") {
                    [Row(value: "c")]
                }
            }
        }
        XCTAssertEqual(sections0.count, 1)
        XCTAssertEqual(sections0[0].name, "section a")
        XCTAssertEqual(sections0[0].rows, [Row(value: "a")])

        let sections1 = Sections {
            if _false {
                Section(name: "section d") {
                    [Row(value: "d")]
                }
            } else if _true {
                Section(name: "section e") {
                    [Row(value: "e")]
                }
            } else {
                Section(name: "section f") {
                    [Row(value: "f")]
                }
            }
        }
        XCTAssertEqual(sections1.count, 1)
        XCTAssertEqual(sections1[0].name, "section e")
        XCTAssertEqual(sections1[0].rows, [Row(value: "e")])

        let sections2 = Sections {
            if _false {
                Section(name: "section g") {
                    [Row(value: "g")]
                }
            } else if _false {
                Section(name: "section h") {
                    [Row(value: "h")]
                }
            } else {
                Section(name: "section i") {
                    [Row(value: "i")]
                }
            }
        }
        XCTAssertEqual(sections2.count, 1)
        XCTAssertEqual(sections2[0].name, "section i")
        XCTAssertEqual(sections2[0].rows, [Row(value: "i")])
    }

    func testMultipleExpressionBuildEitherAndBuildIf() {
        let sections = Sections {
            if _true {
                Section(name: "section a") {
                    Row(value: "a")
                    Row(value: "b")
                }
                Section(name: "section b") {
                    Row(value: "c")
                    Row(value: "d")
                }
            } else if _false {
                Section(name: "section c") {
                    Row(value: "e")
                    Row(value: "f")
                }
                Section(name: "section d") {
                    Row(value: "g")
                    Row(value: "h")
                }
            } else {
                Section(name: "section e") {
                    Row(value: "i")
                    Row(value: "j")
                }
                Section(name: "section f") {
                    Row(value: "k")
                    Row(value: "l")
                }
            }

            if _false {
                Section(name: "section g") {
                    Row(value: "m")
                    Row(value: "n")
                }
                Section(name: "section h") {
                    Row(value: "o")
                    Row(value: "p")
                }
            } else if _true {
                Section(name: "section i") {
                    Row(value: "q")
                    Row(value: "r")
                }
                Section(name: "section j") {
                    Row(value: "s")
                    Row(value: "t")
                }
            } else {
                Section(name: "section k") {
                    Row(value: "u")
                    Row(value: "v")
                }
                Section(name: "section l") {
                    Row(value: "w")
                    Row(value: "x")
                }
            }

            if _false {
                Section(name: "section m") {
                    Row(value: "y")
                    Row(value: "z")
                }
                Section(name: "section n") {
                    Row(value: "A")
                    Row(value: "B")
                }
            } else if _false {
                Section(name: "section o") {
                    Row(value: "C")
                    Row(value: "D")
                }
                Section(name: "section p") {
                    Row(value: "E")
                    Row(value: "F")
                }
            } else {
                Section(name: "section q") {
                    Row(value: "G")
                    Row(value: "H")
                }
                Section(name: "section r") {
                    Row(value: "I")
                    Row(value: "J")
                }
            }
        }

        XCTAssertEqual(sections.count, 6)
        XCTAssertEqual(sections[0].name, "section a")
        XCTAssertEqual(sections[0].rows, [Row(value: "a"), Row(value: "b")])
        XCTAssertEqual(sections[1].name, "section b")
        XCTAssertEqual(sections[1].rows, [Row(value: "c"), Row(value: "d")])
        XCTAssertEqual(sections[2].name, "section i")
        XCTAssertEqual(sections[2].rows, [Row(value: "q"), Row(value: "r")])
        XCTAssertEqual(sections[3].name, "section j")
        XCTAssertEqual(sections[3].rows, [Row(value: "s"), Row(value: "t")])
        XCTAssertEqual(sections[4].name, "section q")
        XCTAssertEqual(sections[4].rows, [Row(value: "G"), Row(value: "H")])
        XCTAssertEqual(sections[5].name, "section r")
        XCTAssertEqual(sections[5].rows, [Row(value: "I"), Row(value: "J")])
    }
}
