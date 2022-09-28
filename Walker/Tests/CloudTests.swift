import XCTest
@testable import Archivable
@testable import Walker

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testPreferences() async {
        var preferences = await cloud.model.preferences
        XCTAssertTrue(preferences.distance)
        
        preferences.distance = false
        await cloud.update(preferences: preferences)
        
        preferences = await cloud.model.preferences
        XCTAssertFalse(preferences.distance)
    }
}
