/*
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation

/// Represent the model of an ITEM inside an order/transaction
@objcMembers public class ItemModel : NSObject, Codable {
    
    /// The title of the item
    public var title : String?
    /// A description of the item
    public let itemDescription : String?
    /// Payment item id
    public var productID: String?
    /// Payment item fulfillment_service
    public var fulfillmentService: String?
    /// Payment item category
    public var category: String?
    /// Payment item code
    public var itemCode: String?
    /// Payment item tags
    public var tags: String?
    /// Payment item account code
    public var accountCode: String?
    /// The item's vendor
    public var vendor: Vendor?
    /// Payment item shiping
    public var requiresShipping: Bool {
        didSet {
            if requiresShipping {
                category = "PHYSICAL_GOODS"
            }else{
                category = "DIGITAL_GOODS"
            }
        }
    }
    /// The raw original price in the original currency
    public var price : Double? {
        didSet {
            totalAmount = price ?? 0 * quantity
        }
    }
    /// The discount applied to the item's price
    public let discount : [AmountModificatorModel]?
    /// The list of Taxes to be applied to the item's price after discount
    public let taxes : [Tax]?
    /// The price final amount after applyig discount & taxes
    public var totalAmount:Double = 0 {
        didSet {
            // Check if we need to auto compute it
            if totalAmount == 0 { totalAmount = itemFinalPrice() }
        }
    }
    
    /// Quantity of payment item(s).
    public var quantity: Double
    
    /// Items currency
    public var currency: TapCurrencyCode?
    
    /**
     - Parameter title: The title of the item
     - Parameter description: A description of the item
     - Parameter price: The raw original price in the original currency
     - Parameter quantity: The quantity added to this item
     - Parameter discount: The discounts applied to the item's price
     - Parameter taxes: The list of Taxs to be applied to the item's price after discount
     - Parameter totalAmount: The price final amount after applyig discount & taxes
     - Parameter currency: Item currency
     */
    @objc public init(title: String?, description: String?, price: Double = 0, quantity: Double = 0, discount: [AmountModificatorModel]?,taxes:[Tax]? = nil,totalAmount:Double = 0,currency:TapCurrencyCode = .undefined,productID:String? = "", category:String? = "", vendor:Vendor? = nil, fulfillmentService:String? = "", requiresShipping:Bool = false, itemCode:String? = "", accountCode:String? = "", tags:String? = "" ) {
        self.title = title
        self.itemDescription = description
        self.price = price
        self.quantity = quantity
        self.discount = discount
        self.taxes = taxes
        self.requiresShipping = requiresShipping
        self.totalAmount = totalAmount
        self.currency = currency
        self.productID = productID
        self.category = category
        self.fulfillmentService = fulfillmentService
        self.vendor = vendor
        self.itemCode = itemCode
        self.accountCode = accountCode
        self.tags = tags
        self.currency = currency
        
        super.init()
        defer {
            self.totalAmount = totalAmount
            self.requiresShipping = requiresShipping
        }
    }
    
    enum CodingKeys: String, CodingKey {
        
        case title              = "name"
        case itemDescription    = "description"
        case quantity           = "quantity"
        case price              = "amount"
        case discount           = "discount"
        case taxes              = "taxes"
        case tags               = "tags"
        case currency           = "currency"
        case productID          = "product_id"
        case category           = "category"
        case vendor             = "vendor"
        case fulfillmentService = "fulfillment_service"
        case requiresShipping   = "requires_shipping"
        case itemCode           = "item_code"
        case accountCode        = "account_code"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        itemDescription = try values.decodeIfPresent(String.self, forKey: .itemDescription)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        quantity = try values.decode(Double.self, forKey: .quantity)
        
        discount = try values.decodeIfPresent([AmountModificatorModel].self, forKey: .discount)
        taxes = try values.decodeIfPresent([Tax].self, forKey: .taxes)
        itemCode = try values.decodeIfPresent (String.self            , forKey: .itemCode        )
        accountCode = try values.decodeIfPresent (String.self            , forKey: .accountCode        )
        requiresShipping = try values.decodeIfPresent (Bool.self            , forKey: .requiresShipping        ) ?? false
        fulfillmentService = try values.decodeIfPresent (String.self            , forKey: .fulfillmentService        )
        category        = try values.decodeIfPresent (String.self            , forKey: .category         )
        vendor          = try values.decodeIfPresent (Vendor.self            , forKey: .vendor           )
        tags            = try values.decodeIfPresent (String.self             , forKey: .tags            )
        currency            = try values.decodeIfPresent (TapCurrencyCode.self             , forKey: .currency            )
    }
    
    /**
     Holds the logic to calculate the final price of the item based on price, quantity and discount
     - Parameter convertFromCurrency: The original currency if needed to convert from
     - Parameter convertToCurrenct: The new currency if needed to convert to
     - Returns: The total price of the item as follows : (itemPrice-discount+taxes) * quantity
     */
    public func itemFinalPrice(convertFromCurrency:AmountedCurrency? = nil,convertToCurrenct:AmountedCurrency? = nil) -> Double {
        
        // Defensive coding, make sure all values are set
        guard let price = price else { return 0 }
        
        // First apply the discount if any
        let discountedItemPrice:Double = discount?.reduce(price){ $0 - $1.caluclateActualModificationValue(with: price) } ?? price
        
        //price - (discount?.caluclateActualModificationValue(with: price) ?? 0)
        // Secondly apply the taxes if any
        var discountedWithTaxesPrice:Double = taxes?.reduce(discountedItemPrice) { $0 + $1.amount.caluclateActualModificationValue(with: discountedItemPrice) } ?? discountedItemPrice
        // Put in the quantity in action
        discountedWithTaxesPrice = discountedWithTaxesPrice * quantity
        
        // Check if the caller wants to make a conversion to a certain currency
        guard let originalCurrency = convertFromCurrency, let conversionCurrency = convertToCurrenct,
              originalCurrency.currency != .undefined, conversionCurrency.currency !=  .undefined else {
            return discountedWithTaxesPrice
        }
        
        return discountedWithTaxesPrice * (conversionCurrency.rate ?? 1)
    }
    
}


/// The products vendor model
@objcMembers public class Vendor: NSObject, Codable {
    
    @objc public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Payment item title.
    @objc public var id: String
    
    /// Payment item description text.
    @objc public var name: String
    
    // MARK: - NSCopying
    /// Copies the receiver.
    ///
    /// - Parameter zone: Zone.
    /// - Returns: Copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        return Vendor(id: self.id, name: self.name)
    }
}
