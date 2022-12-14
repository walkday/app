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
        XCTAssertTrue(settings.stats.distance)
        
        settings.stats.distance = false
        await cloud.update(settings: settings)
        
        settings = await cloud.actor.model.settings
        XCTAssertFalse(settings.stats.distance)
    }
}
