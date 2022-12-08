//
//  TapSerializer.swift
//  TapNetworkManager/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Tap Serializer class.
internal class TapSerializer {

    internal static func serialize(_ object: Any, with format: TapSerializationType) throws -> Any {

        switch format {

        case .json:

            return try TapJSONSerializer.shared.encode(object)

        case .propertyList:

            return try TapPropertyListSerializer.shared.encode(object)

        case .url:

            return try TapURLSerializer.shared.encode(object)
        }
    }

    internal static func deserialize(_ data: Any, with format: TapSerializationType) throws -> Any {

        switch format {

        case .json:

            return try TapJSONSerializer.shared.decode(data)

        case .propertyList:

            return try TapPropertyListSerializer.shared.decode(data)

        case .url:

            return try TapURLSerializer.shared.decode(data)
        }
    }

    // MARK: - Private -
    // MARK: Methods

    @available(*, unavailable) private init() {}
}
