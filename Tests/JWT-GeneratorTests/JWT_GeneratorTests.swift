import XCTest
@testable import JWT_Generator

final class JWT_GeneratorTests: XCTestCase {
    func testRegex() throws {
        let string = "AuthKey_8ABNFDM7XX.p8"
        let dupplicatedString = "AuthKey_ABC123.p8AuthKey_ABC123.p8"
        let failString = "AuthKey_ABC123.p8 copy"
        
        XCTAssertTrue(string.isMatchPattern(String.RegEx.authKeyFile))
        XCTAssertFalse(failString.isMatchPattern(String.RegEx.authKeyFile))
        XCTAssertFalse(dupplicatedString.isMatchPattern(String.RegEx.authKeyFile))
    }
    
    func testKeyId() throws {
        let string = "AuthKey_8ABNFDM7XX.p8"
        XCTAssertEqual(string.keyId, "8ABNFDM7XX")
    }
}
