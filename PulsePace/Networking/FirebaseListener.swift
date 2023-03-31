//
//  FirebaseListener.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

import FirebaseDatabase

class FirebaseListener<T: Codable>: DatabaseListenerAdapter {
    typealias Data = T

    private let databaseReference: DatabaseReference
    private var observedPaths: Set<String> = Set()

    init() {
        self.databaseReference = Database.database().reference()
    }

    deinit {
//        observedPaths.forEach({ databaseReference.child($0).removeAllObservers() })
    }

    func setupAddChildListener(in path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        observedPaths.insert(path)
        databaseReference.child(path).observe(.childAdded, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.invalidData))
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    let data = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
          }) { error in
              completion(.failure(error))
        }
    }

    func setupUpdateChildListener(in path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        observedPaths.insert(path)
        databaseReference.child(path).observe(.childChanged, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.invalidData))
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    let data = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
          }) { error in
              completion(.failure(error))
        }
    }

    func setupRemoveChildListener(in path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        observedPaths.insert(path)
        databaseReference.child(path).observe(.childRemoved, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.invalidData))
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    let data = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
          }) { error in
              completion(.failure(error))
        }
    }

    func setupChildValueListener(in path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        observedPaths.insert(path)
        databaseReference.child(path).observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.invalidData))
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    let data = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
          }) { error in
              completion(.failure(error))
        }
    }
}
