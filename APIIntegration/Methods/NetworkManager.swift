//
//  NetworkManager.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import Foundation
import Alamofire

class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager() // Singleton instance
        private init() {} // Prevent external initialization
    
    
    func getPosts(completion: @escaping (Result<[Post], AFError>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        AF.request(url)
            .validate()
            .responseDecodable(of: [Post].self) { response in
                completion(response.result)
            }
    }
    
    func createPost(title: String, body: String, userId: Int, completion: @escaping (Result<Post, AFError>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        let parameters: [String: Any] = [
            "title": title,
            "body": body,
            "userId": userId
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: Post.self) { response in
                completion(response.result)
            }
    }
    
    func uploadImage(
            imageData: Data,
            progressHandler: ((Double) -> Void)? = nil,
            completion: @escaping (Result<String, AFError>) -> Void
        ) {
            let url = "https://api.imgbb.com/1/upload"
            let apiKey = "a7204cdc25bccbe2030e9ea67a416b6d"

            let parameters: [String: String] = [
                "key": apiKey
            ]

            AF.upload(
                multipartFormData: { multipart in
                    multipart.append(imageData, withName: "image", fileName: "photo.jpg", mimeType: "image/jpeg")
                    for (key, value) in parameters {
                        multipart.append(Data(value.utf8), withName: key)
                    }
                },
                to: url
            )
            .uploadProgress { progress in
                progressHandler?(progress.fractionCompleted)
            }
            .responseDecodable(of: UploadResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("✅ Upload Success:\n\(data)")
                    completion(.success(data.data.url))
                case .failure(let error):
                    print("❌ Upload Failed:\n\(error)")
                    completion(.failure(error))
                }
            }
        }
    
    // MARK: - GET Request
        func getRequest<T: Decodable>(
            url: String,
            headers: HTTPHeaders? = nil,
            completion: @escaping (Result<T, AFError>) -> Void
        ) {
            AF.request(url, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    completion(response.result)
                }
        }

        // MARK: - POST Request
        func postRequest<T: Decodable>(
            url: String,
            parameters: [String: Any],
            headers: HTTPHeaders? = nil,
            completion: @escaping (Result<T, AFError>) -> Void
        ) {
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    completion(response.result)
                }
        }

        // MARK: - PUT Request
        func putRequest<T: Decodable>(
            url: String,
            parameters: [String: Any],
            headers: HTTPHeaders? = nil,
            completion: @escaping (Result<T, AFError>) -> Void
        ) {
            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    completion(response.result)
                }
        }

        // MARK: - DELETE Request
//    func deleteRequest(
//        url: String,
//        headers: HTTPHeaders? = nil,
//        completion: @escaping (Result<Bool, AFError>) -> Void
//    ) {
//        AF.request(url, method: .delete, headers: headers)
//            .validate()
//            .response { response in
//                switch response.result {
//                case .success:
//                    completion(.success(true))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
    func deleteRequest(
        url: String,
        completion: @escaping (Result<(url: String, statusCode: Int?, date: String), AFError>) -> Void
    ) {
        AF.request(url, method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .medium
                    let now = formatter.string(from: Date())

                    let statusCode = response.response?.statusCode
                    completion(.success((url, statusCode, now)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }



        // MARK: - PATCH (UPDATE) Request
        func patchRequest<T: Decodable>(
            url: String,
            parameters: [String: Any],
            headers: HTTPHeaders? = nil,
            completion: @escaping (Result<T, AFError>) -> Void
        ) {
            AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    completion(response.result)
                }
        }
        
   

        

}
