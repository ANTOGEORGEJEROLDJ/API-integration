//
//  UploadResponse.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import Foundation

struct UploadResponse: Codable {
    let data: UploadData
    let success: Bool
    let status: Int
}

struct UploadData: Codable {
    let url: String
}

