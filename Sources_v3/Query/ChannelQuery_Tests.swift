//
// Copyright © 2020 Stream.io Inc. All rights reserved.
//

@testable import StreamChatClient
import XCTest

class ChannelQuery_Tests: XCTestCase {
    // Test ChannelQuery encoded correctly
    func test_channelQuery_encodedCorrectly() throws {
        let cid: ChannelId = .unique
        let paginationOption: PaginationOption = .offset(3)
        let membersLimit = 10
        let watchersLimit = 10

        // Create ChannelQuery
        let query = ChannelQuery<DefaultExtraData>(
            cid: cid,
            paginationOptions: [paginationOption],
            membersLimit: membersLimit,
            watchersLimit: watchersLimit
        )

        let expectedData: [String: Any] = [
            "presence": true,
            "watch": true,
            "state": true,
            "messages": ["limit": 25, "offset": 3],
            "members": ["limit": 10],
            "watchers": ["limit": 10]
        ]

        let expectedJSON = try JSONSerialization.data(withJSONObject: expectedData, options: [])
        let encodedJSON = try JSONEncoder.default.encode(query)

        // Assert ChannelQuery encoded correctly
        AssertJSONEqual(expectedJSON, encodedJSON)
    }
    
    func test_pathParameters() {
        // Create query without id specified
        let query1: ChannelQuery<DefaultExtraData> = .init(channelPayload: .init(
            type: .messaging,
            team: nil,
            members: [.unique],
            invites: [],
            extraData: .defaultValue
        ))
        
        // Assert only type is part of path
        XCTAssertEqual(query1.pathParameters, "\(query1.type)")
        
        // Create query with id and type specified
        let cid: ChannelId = .unique
        let query2: ChannelQuery<DefaultExtraData> = .init(cid: cid)
        
        // Assert type and id are part of path
        XCTAssertEqual(query2.pathParameters, "\(query2.type)/\(query2.id!)")
    }
}
