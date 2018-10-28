//
//  Data Model.swift
//  TODO
//
//  Created by 杨非凡 on 2018/10/28.
//  Copyright © 2018 Feifan Yang. All rights reserved.
//

import Foundation
class Item :Encodable,Decodable{
    var title = ""
    var done = false
}
