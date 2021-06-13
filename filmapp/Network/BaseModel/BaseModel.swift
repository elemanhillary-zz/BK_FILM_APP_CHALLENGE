//
//  BaseModel.swift
//  filmapp
//
//  Created by MacBook Pro on 6/12/21.
//

import Foundation
import HandyJSON

class BaseModel: NSObject, HandyJSON {
    required override init() {}
}

class BaseRequest: BaseModel {}
