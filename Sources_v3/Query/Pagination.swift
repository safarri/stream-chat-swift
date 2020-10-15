//
// Copyright © 2020 Stream.io Inc. All rights reserved.
//

import Foundation

public extension Int {
    /// A default channels page size.
    static let channelsPageSize = 20
    /// A default channels page size for the next page.
    static let channelsNextPageSize = 30
    /// A default messages page size.
    static let messagesPageSize = 25
    /// A default messages page size for the next page.
    static let messagesNextPageSize = 50
    /// A default users page size.
    static let usersPageSize = 30
    /// A default channel members page size.
    static let channelMembersPageSize = 30
}

public struct Pagination: Encodable, Equatable {
    /// A page size
    let pageSize: Int?
    /// Set of options for pagination.
    let options: Set<PaginationOption>
    
    /// Failable initializer for attempts of creating invalid pagination.
    init?(pageSize: Int? = nil, options: Set<PaginationOption> = []) {
        guard pageSize != nil || !options.isEmpty else { return nil }
        self.pageSize = pageSize
        self.options = options
    }
    
    init(pageSize: Int, offset: Int) {
        self.pageSize = pageSize
        options = [.offset(offset)]
    }
    
    private enum CodingKeys: String, CodingKey {
        case pageSize = "limit"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pageSize, forKey: .pageSize)
        try options.forEach { try $0.encode(to: encoder) }
    }
}

/// Pagination options
public enum PaginationOption: Encodable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case offset
        case greaterThan = "id_gt"
        case greaterThanOrEqual = "id_gte"
        case lessThan = "id_lt"
        case lessThanOrEqual = "id_lte"
    }
    
    /// The offset of requesting items.
    /// - Note: Using `lessThan` or `lessThanOrEqual` for pagination is preferable to using `offset`.
    case offset(_ offset: Int)
    
    /// Filter on ids greater than the given value.
    case greaterThan(_ id: String)
    
    /// Filter on ids greater than or equal to the given value.
    case greaterThanOrEqual(_ id: String)
    
    /// Filter on ids smaller than the given value.
    case lessThan(_ id: String)
    
    /// Filter on ids smaller than or equal to the given value.
    case lessThanOrEqual(_ id: String)

    /// An offset value, if the pagination has it or nil.
    public var offset: Int? {
        if case let .offset(offset) = self {
            return offset
        }
        
        return nil
    }
    
    /// Parameters for a request.
    var parameters: [String: Any] {
        switch self {
        case let .offset(offset):
            return ["offset": offset]
        case let .greaterThan(id):
            return ["id_gt": id]
        case let .greaterThanOrEqual(id):
            return ["id_gte": id]
        case let .lessThan(id):
            return ["id_lt": id]
        case let .lessThanOrEqual(id):
            return ["id_lte": id]
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .offset(offset):
            try container.encode(offset, forKey: .offset)
        case let .greaterThan(id):
            try container.encode(id, forKey: .greaterThan)
        case let .greaterThanOrEqual(id):
            try container.encode(id, forKey: .greaterThanOrEqual)
        case let .lessThan(id):
            try container.encode(id, forKey: .lessThan)
        case let .lessThanOrEqual(id):
            try container.encode(id, forKey: .lessThanOrEqual)
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.offset(value1), .offset(value2)):
            return value1 == value2
        case let (.greaterThan(value1), .greaterThan(value2)),
             let (.greaterThanOrEqual(value1), .greaterThanOrEqual(value2)),
             let (.lessThan(value1), .lessThan(value2)),
             let (.lessThanOrEqual(value1), .lessThanOrEqual(value2)):
            return value1 == value2
        default:
            return false
        }
    }
}
