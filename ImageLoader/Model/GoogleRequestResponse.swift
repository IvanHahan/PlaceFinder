//
//  GoogleRequestResponse.swift
//  ImageLoader
//
//  Created by Ivan Hahanov on 3/20/18.
//  Copyright © 2018 Ivan Hahanov. All rights reserved.
//

import Foundation

struct GoogleRequestResponse<T: Decodable>: Decodable {
    let data: T
    
    private enum CodingKeys: String, CodingKey {
        case data = "results"
    }
}
