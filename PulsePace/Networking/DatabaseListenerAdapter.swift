//
//  DatabaseListenerAdapter.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

protocol DatabaseListenerAdapter<Data> {
    associatedtype Data
    func setupAddChildListener(in path: String, completion: @escaping (Result<Data, Error>) -> Void)
    func setupUpdateChildListener(in path: String, completion: @escaping (Result<Data, Error>) -> Void)
    func setupRemoveChildListener(in path: String, completion: @escaping (Result<Data, Error>) -> Void)
//    func setupChildValueListener(in path: String, completion: @escaping (Result<Data, Error>) -> Void)
}
