//
//  TransactionExpiry.swift
//  EditableTextInsetsTextField
//
//  Created by Osama Rabie on 06/02/2020.
//

@objcMembers
@objc(CheckoutTransactionExpiry) public final class TransactionExpiry: NSObject{
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Transaction Exxpiry period count.
    public let period: Int
    /// Transaction Exxpiry period component (months, days, minutes, etc.)
    public let type: String
    
    // MARK: Methods
    
    /// Initializes expiration object with time left and time component
    ///
    /// - Parameters:
    ///   - period: The count left until epxiration
    ///   - orderNumber: Decsripes what component does this count stands for, e.g. minutes, seconds, etc.
    public init(period: Int, type: String) {
        
        self.period = period
        self.type = type
        
        super.init()
    }
    
    // MARK: - Private
    
    private enum CodingKeys: String, CodingKey {
        
        case type     = "type"
        case period   = "period"
    }
}

// MARK: - Decodable
extension TransactionExpiry: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type        = try container.decode            (String.self,   forKey: .type)
        let period      = try container.decode          (Int.self,     forKey: .period)
        
        self.init(period: period, type: type)
    }
}

// MARK: - Encodable
extension TransactionExpiry: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(period, forKey: .period)
    }
}


extension TransactionExpiry {
    
    /// transfers the expiration type to an understandable swift calendar component
    public func toCalendarComponent () -> Calendar.Component? {
        
        if type.lowercased().hasPrefix("second") {
            return .second
        }else if type.lowercased().hasPrefix("minute") {
            return .minute
        }else if type.lowercased().hasPrefix("hour") {
            return .hour
        }else if type.lowercased().hasPrefix("day") {
            return .day
        }else if type.lowercased().hasPrefix("month") {
            return .month
        }else if type.lowercased().hasPrefix("year") {
            return .year
        }
        
        return nil
    }
}
