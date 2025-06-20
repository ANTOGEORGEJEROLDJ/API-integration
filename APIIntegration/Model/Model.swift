//
//  Model.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import Foundation


struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
