//
//  NewApiErrorModel.swift
//  CommonDataModelsKit-iOS
//
//  Created by Osama Rabie on 22/01/2023.
//

import Foundation

/// A model that represents the new errors coming in the payment types api
/***
 {
 "message" : "",
 "code" : "1117",
 "reason" : "Error from BACKEND: Invalid Order Amount"
 }
 */
public struct NewAPIErrorModel: Codable {
    var message, reason: String?
    var code: String
}

// MARK: NewAPIErrorModel convenience initializers and mutators

public extension NewAPIErrorModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NewAPIErrorModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        message: String?? = nil,
        code: String,
        reason: String?? = nil
    ) -> NewAPIErrorModel {
        return NewAPIErrorModel(
            message: message ?? self.message,
            reason: reason ?? self.reason,
            code: code
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
    func description() -> String {
        return "\(code)\n\(message ?? "")\n\(reason ?? "")"
    }
}
