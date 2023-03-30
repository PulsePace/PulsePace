//
//  DatabaseAdapter.swift
//  PulsePace
//
//  Created by Charisma Kausar on 26/3/23.
//

import FirebaseDatabase

protocol DatabaseAdapter<Data> {
    associatedtype Data
    func saveData(path: String, data: Data, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchData(path: String, completion: @escaping (Result<Data, Error>) -> Void)
    func deleteData(path: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchAllData(path: String, completion: @escaping (Result<Data, Error>) -> Void)
    func runTransactionBlock(path: String, updateBlock: @escaping (MutableData) -> TransactionResult,
                             completion: @escaping (Result<Void, Error>) -> Void)
}
