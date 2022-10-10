import XCTest
@testable import Archivable
@testable import Walker

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testSettings() async {
        var settings = await cloud.actor.model.settings
        XCTAssertTrue(settings.iOS.stats.distance)
        
        settings.iOS.stats.distance = false
        await cloud.update(settings: settings)
        
        settings = await cloud.actor.model.settings
        XCTAssertFalse(settings.iOS.stats.distance)
    }
}
