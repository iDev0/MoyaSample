//
//  UserService.swift
//  MoyaSample
//
//  Created by iDev0 on 2020/07/26.
//  Copyright © 2020 Ju Young Jung. All rights reserved.
//

import Foundation
import Moya

enum UserService {
    case createUser(name: String)
    case readUser
    case detailUser(id: Int)
    case updateUser(id: Int, name: String)
    case deleteUser(id: Int)
}

extension UserService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .createUser(_), .readUser:
            return "/users"
        case .updateUser(let id, _), .deleteUser(let id), .detailUser(let id):
            return "/users/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser(_):
            return .post
        case .readUser, .detailUser(_):
            return .get
        case .updateUser(_, _):
            return .put
        case .deleteUser(_):
            return .delete
        }
    }
    
    var sampleData: Data {
        switch self {
        case .createUser(let name):
            return "{'name' : '\(name)'}".data(using: .utf8)!
        case .readUser:
            return Data()
        case .updateUser(let id, let name):
            return "{'id' : '\(id)', 'name' : '\(name)'}".data(using: .utf8)!
        case .deleteUser(let id), .detailUser(let id):
            return "{'id' : '\(id)'}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .readUser, .deleteUser(_), .detailUser(_):
            return .requestPlain
        case .createUser(let name), .updateUser(_, let name):
            return .requestParameters(parameters: ["name" : name], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    
}
