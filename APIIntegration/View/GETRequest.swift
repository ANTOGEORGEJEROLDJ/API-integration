//
//  GETRequest.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//

import SwiftUI
import Alamofire

struct GETRequest: View {
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var post: Post?
    @State private var rawJSON: String = ""
    @State private var statusCode: Int?

    var body: some View {
        VStack(spacing: 20) {
            Text("🔍 GET API Tester")
                .font(.title)
                .bold()
                .foregroundColor(.blue)
                .padding(.top)

            if isLoading {
                ProgressView("Fetching...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }

            if let error = errorMessage {
                Text("❌ Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            if let post = post {
                VStack(alignment: .leading, spacing: 8) {
                    Text("📦 Decoded Post:")
                        .font(.headline)
                    Text("🆔 ID: \(post.id)")
                    Text("🧑‍💻 User ID: \(post.userId)")
                    Text("📌 Title: \(post.title)")
                    Text("📝 Body: \(post.body)")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                .shadow(radius: 5)
                .transition(.opacity)
            }

            if !rawJSON.isEmpty {
                VStack(alignment: .leading) {
                    Text("🧾 Raw JSON Response:")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        Text(rawJSON)
                            .font(.system(.body, design: .monospaced))
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 5)
            }

            if let code = statusCode {
                Text("📡 Status Code: \(code)")
                    .font(.subheadline)
                    .foregroundColor(code == 200 ? .green : .orange)
            }

            Spacer()

            VStack(spacing: 12) {
                Button("GET (responseJSON)") {
                    fetchRawJSON()
                }
                .padding()
                .bold()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(15)

                Button("GET (responseDecodable)") {
                    fetchDecodedPost()
                }
                .padding()
                .bold()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(15)
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [.white, .blue.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }

    func fetchRawJSON() {
        reset()
        isLoading = true

        AF.request("https://jsonplaceholder.typicode.com/posts/1")
            .validate()
            .responseJSON { response in
                isLoading = false
                statusCode = response.response?.statusCode

                switch response.result {
                case .success(let value):
                    rawJSON = "\(value)"
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
    }

    func fetchDecodedPost() {
        reset()
        isLoading = true

        NetworkManager.shared.getRequest(url: "https://jsonplaceholder.typicode.com/posts/1") { (result: Result<Post, AFError>) in
            DispatchQueue.main.async {
                isLoading = false

                switch result {
                case .success(let fetchedPost):
                    post = fetchedPost
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func reset() {
        post = nil
        rawJSON = ""
        errorMessage = nil
        statusCode = nil
    }
}
