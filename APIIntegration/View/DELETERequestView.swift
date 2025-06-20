//
//  DELETERequestView.swift
//  APIIntegration
//
//  Created by Paranjothi iOS MacBook Pro on 20/06/25.
//


import SwiftUI
import Alamofire

struct DELETERequestView: View {
    @State private var deleteStatus = ""
    @State private var isLoading = false
    @State private var apiURL = ""
    @State private var httpCode: Int?
    @State private var timestamp = ""
    @State private var deletedPostID = ""
    @State private var showDetails = false

    // 🔗 Change this to delete different posts
    let deleteURL = "https://jsonplaceholder.typicode.com/posts/1"

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("🗑️ DELETE Request")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)

                Text("This will delete the post at:")
                    .font(.subheadline)

                Text(deleteURL)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if isLoading {
                    ProgressView("Deleting...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .padding()
                }

                Button("Delete Post") {
                    deletePost()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(colors: [Color.red, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(15)
                .padding(.horizontal)
                .disabled(isLoading)

                if !deleteStatus.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(deleteStatus)
                            .font(.headline)
                            .foregroundColor(deleteStatus.contains("Success") ? .green : .red)

                        if showDetails {
                            Divider()
                            Text("📮 Deleted Post ID: \(deletedPostID)")
                            Text("🌐 API: \(apiURL)")
                            Text("📡 Status Code: \(httpCode ?? 0)")
                            Text("🕒 Time: \(timestamp)")
                        }
                    }
                    .padding()
                    .background(deleteStatus.contains("Success") ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .frame(width: 300, height: 600)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(colors: [Color.white, Color.red.opacity(0.05)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
    }

    func deletePost() {
        isLoading = true
        deleteStatus = ""
        showDetails = false
        apiURL = ""
        httpCode = nil
        timestamp = ""
        deletedPostID = ""

        NetworkManager.shared.deleteRequest(url: deleteURL) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let (url, statusCode, date)):
                    deleteStatus = "✅ Success: Post deleted!"
                    apiURL = url
                    httpCode = statusCode
                    timestamp = date
                    deletedPostID = extractPostID(from: url)
                    showDetails = true
                case .failure(let error):
                    deleteStatus = "❌ Failed to delete: \(error.localizedDescription)"
                    showDetails = false
                }
            }
        }
    }

    func extractPostID(from url: String) -> String {
        if let id = url.components(separatedBy: "/").last {
            return id
        }
        return "N/A"
    }
}





//import SwiftUI
//import Alamofire
//
//struct DELETERequestView: View {
//    @State private var deleteStatus = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Delete Post #1")
//                .font(.title2)
//
//            Button("Delete Post") {
//                deletePost()
//            }
//            .buttonStyle(.borderedProminent)
//
//            if !deleteStatus.isEmpty {
//                Text(deleteStatus)
//                    .font(.subheadline)
//                    .foregroundColor(deleteStatus.contains("Success") ? .green : .red)
//                    .padding()
//            }
//        }
//        .padding()
//    }
//
//    func deletePost() {
//        let url = "https://jsonplaceholder.typicode.com/posts/1"
//
//        NetworkManager.shared.deleteRequest(url: url) { result in
//            switch result {
//            case .success:
//                deleteStatus = "✅ Success: Post deleted!"
//            case .failure(let error):
//                deleteStatus = "❌ Failed to delete: \(error.localizedDescription)"
//            }
//        }
//    }
//
//}
