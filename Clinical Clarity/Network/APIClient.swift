import Foundation
import SwiftUI

final class APIClient {
    
    static let shared = APIClient()
    private init() {}
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        body: Encodable? = nil,
        headers: [String: String]? = nil,
        requiresAuth: Bool = false
    ) async throws -> T {
        
        // MARK: - URL
        guard let url = URL(string: APIConfig.baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // MARK: - Headers
        var finalHeaders = APIConfig.defaultHeaders
        
        if let headers = headers {
            finalHeaders.merge(headers) { $1 }
        }
        
        // MARK: - Auth Token (optional for other APIs)
        if requiresAuth,
           let token = UserDefaults.standard.string(forKey: "authToken") {
            finalHeaders["Authorization"] = "Bearer \(token)"
        }
        
        request.allHTTPHeaderFields = finalHeaders
        
        // MARK: - Body (ONLY for non-GET)
        if let body = body, endpoint.method != .GET {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }
        
        // MARK: - Debug Logs
        print("👉 URL:", request.url?.absoluteString ?? "")
        print("👉 Method:", request.httpMethod ?? "")
        print("👉 Headers:", finalHeaders)
        
        // MARK: - API Call
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // MARK: - Response Check
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("👉 Status Code:", httpResponse.statusCode)
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        // MARK: - Decode
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Decoding Error:", error)
            throw APIError.decodingError
        }
    }
    
    func multipartRequest<T: Decodable>(
        endpoint: Endpoint,
        parameters: [String: String],
        requiresAuth: Bool = false   // ✅ added
    ) async throws -> T {
        
        guard let url = URL(string: APIConfig.baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        let boundary = UUID().uuidString
        
        // MARK: - Headers
        var headers = APIConfig.defaultHeaders
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        // ✅ ADD AUTH SUPPORT (same as your request() method)
        if requiresAuth,
           let token = UserDefaults.standard.string(forKey: "authToken") {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        request.allHTTPHeaderFields = headers
        
        // MARK: - Body
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        // MARK: - Debug Logs (VERY IMPORTANT 🔥)
        print("👉 URL:", url.absoluteString)
        print("👉 Headers:", headers)
        print("👉 Params:", parameters)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("👉 Status Code:", httpResponse.statusCode)
        print("👉 Response:", String(data: data, encoding: .utf8) ?? "")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func multipartRequestWithImages<T: Decodable>(
        endpoint: Endpoint,
        parameters: [String: String],
        images: [String: UIImage?],
        requiresAuth: Bool = false
    ) async throws -> T {
        
        guard let url = URL(string: APIConfig.baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        let boundary = UUID().uuidString
        
        // Headers
        var headers = APIConfig.defaultHeaders
        
        if requiresAuth,
           let token = UserDefaults.standard.string(forKey: "authToken") {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        request.allHTTPHeaderFields = headers
        
        var body = Data()
        
        // MARK: - Add Text Fields
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        // MARK: - Add Images
        for (key, image) in images {
            if let image,
               let data = image.jpegData(compressionQuality: 0.7) {
                
                let fileName = "\(key)_\(UUID().uuidString).jpg" // ✅ UNIQUE
                
                print("⬆️ Uploading:", key, "as", fileName) // ✅ debug
                
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                body.append("Content-Type: image/jpeg\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            }
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        // MARK: - API Call
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("👉 Status Code:", httpResponse.statusCode)
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}


// MARK: - Helpers

struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    
    init<T: Encodable>(_ wrapped: T) {
        encodeFunc = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
}
