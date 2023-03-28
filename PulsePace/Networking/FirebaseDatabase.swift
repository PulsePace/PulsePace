//
//  FirebaseDatabase.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import FirebaseDatabase

class FirebaseDatabase<T: Codable>: DatabaseAdapter {
    typealias Data = T

    private let databaseReference: DatabaseReference
    
    init() {
        self.databaseReference = Database.database().reference()
    }

    func saveData(path: String, data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            databaseReference.child(path).setValue(dict) { (error, _) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchData(path: String, completion: @escaping (Result<T, Error>) -> Void) {
        databaseReference.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.invalidData))
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                let data = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(data))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func deleteData(path: String, completion: @escaping (Result<Void, Error>) -> Void) {
        databaseReference.child(path).removeValue { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
