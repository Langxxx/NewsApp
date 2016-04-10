//
//  Result.swift
//  网易新闻
//
//  Created by wl on 4/9/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit

enum Result<Value> {
    case Success(Value)
    case Failure(ErrorType)
    
    
}
extension Result {
    func map<T>(f: Value -> T) -> Result<T> {
        switch self {
        case .Success(let v):
            return .Success(f(v))
        case .Failure(let e):
            return .Failure(e)
        }
    }
}
extension Result {
    func flatMap<T>(f: Value -> Result<T>) -> Result<T> {
        switch self {
        case .Success(let v):
            return f(v)
        case .Failure(let e):
            return .Failure(e)
        }
    }
}


enum Error: ErrorType {
    case NetworkError
}


