//
//  FirebaseStorage.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/08.
//

import Foundation
import FirebaseStorage

class FirebaseStorage: StorageAdapter {
    let storage = Storage.storage()

    func upload(data: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let filename = UUID().uuidString
        let ref = storage.reference(withPath: "uploads/\(filename).mp3")

        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                ref.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    } else {
                        completion(.failure(NSError(domain: "FirebaseStorage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    }
                }
            }
        }
    }

    func download(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {

    }
}
