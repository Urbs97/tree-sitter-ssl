import XCTest
import SwiftTreeSitter
import TreeSitterSsl

final class TreeSitterSslTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_ssl())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Ssl grammar")
    }
}
