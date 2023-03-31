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

    func saveData(at path: String, data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            databaseReference.child(path).setValue(dict) { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func saveData(in path: String, data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            databaseReference.child(path).childByAutoId().setValue(dict) { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func fetchData(at path: String, completion: @escaping (Result<T, Error>) -> Void) {
        databaseReference.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.invalidData))
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                let data = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func deleteData(at path: String, completion: @escaping (Result<Void, Error>) -> Void) {
        databaseReference.child(path).removeValue { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func setValue(path: String, value: String) {

    }

    func runTransactionBlock(at path: String, updateBlock: @escaping (MutableData) -> TransactionResult,
                             completion: @escaping (Result<Void, Error>) -> Void) {
        databaseReference.child(path).runTransactionBlock(updateBlock) { error, _, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
