//
//  DatabaseAdapter.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import FirebaseDatabase

protocol DatabaseAdapter<Data> {
    associatedtype Data
    func saveData(at path: String, data: Data, completion: @escaping (Result<Void, Error>) -> Void)
    func saveData(in path: String, data: Data, completion: @escaping (Result<Void, Error>) -> Void)
    func setValue(at path: String, value: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchData(at path: String, completion: @escaping (Result<Data, Error>) -> Void)
    func deleteData(at path: String, completion: @escaping (Result<Void, Error>) -> Void)
    func runTransactionBlock(at path: String, updateBlock: @escaping (MutableData) -> TransactionResult,
                             completion: @escaping (Result<Void, Error>) -> Void)
}
