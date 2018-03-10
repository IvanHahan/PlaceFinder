//
//  Actions.swift
//  CoreDataNetworkLayer
//
//  Created by Ivan Hahanov on 2/16/18.
//  Copyright © 2018  Ivan Hahanov. All rights reserved.
//

import Foundation
import ReSwift

struct Loading: Action {}
struct Failure: Action { let error: Error }

