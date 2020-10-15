//
// Copyright © 2020 Stream.io Inc. All rights reserved.
//

@testable import StreamChatClient
import XCTest

class Pagination_Tests: XCTestCase {
    func test_invalidPaginationInit_returnsNil() {
        let pagination = Pagination(pageSize: nil, options: [])
        
        // Assert initializer returns nil on invalid pagination
        XCTAssertNil(pagination)
    }
    
    func test_pagination_Encoding() throws {
        let pageSize: Int = .channelMembersPageSize
        let offset: Int = 20
        let testId: String = "testId"
        
        // Create pagination
        let pagination = Pagination(pageSize: pageSize, options: [.lessThan(testId), .offset(offset)])
        
        // Mock expected JSON object
        let expectedData: [String: Any] = [
            "limit": pageSize,
            "offset": offset,
            "id_lt": testId
        ]
        
        let encodedJSON = try JSONEncoder.default.encode(pagination)
        let expectedJSON = try JSONSerialization.data(withJSONObject: expectedData, options: [])

        // Assert `Pagination` encoded correctly
        AssertJSONEqual(encodedJSON, expectedJSON)
    }
}
