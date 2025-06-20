//
//  PostViewModel.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    func fetchPosts() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.getPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let posts):
                    self?.posts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func createPost() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.createPost(title: "New Post", body: "This is a test", userId: 1) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.successMessage = "Post created successfully!"
                    self?.fetchPosts()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
