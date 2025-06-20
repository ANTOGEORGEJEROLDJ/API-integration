//
//  PostStore.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import Foundation
import Combine

class PostStore: ObservableObject {
    static let shared = PostStore()
    @Published var locallyCreatedPosts: [Post] = []
}
