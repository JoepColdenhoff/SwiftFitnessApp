import Foundation

// Define possible network errors
enum NetworkError: Error {
    case invalidURL
    case noData 
}

class APIService {
    // API key should ideally be stored securely, not hardcoded
    // Environment file wasn't working
    private let apiKey = ""
    private let baseUrl = "https://api.api-ninjas.com/v1/exercises"

    // fetchExercisesFromAPI uses a completion handler to return data asynchronously.
    // @escaping allows the closure to outlive the function's scope (needed for async tasks).
    // Result<[Exercise], Error> returns either the fetched data or an error, ensuring type-safe handling.
    func fetchExercisesFromAPI(completion: @escaping (Result<[Exercise], Error>) -> Void) {
        // Validate URL before making a request. Prevents invalid API requests.
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        // Data task runs asynchronously in a background thread
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Ensure data is received before attempting to decode it
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Decode JSON response into an array of Exercise objects
                let exercises = try JSONDecoder().decode([Exercise].self, from: data) // Without .self, Swift doesn't know that it's a type.
                completion(.success(exercises))
            } catch {
                completion(.failure(error))
            }
        }.resume() // Start the data task
    }
}
