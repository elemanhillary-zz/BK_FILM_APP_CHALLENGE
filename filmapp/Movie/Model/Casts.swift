//
//  Casts.swift
//  filmapp
//
//  Created by MacBook Pro on 6/13/21.
//

import Foundation
class Cast: BaseModel {
    var name: String?
    var original_name: String?
    var profile_path: String?
    var character: String?
}

class GuestSession: BaseModel {
    var success:Bool?
    var guest_session_id:String?
}
