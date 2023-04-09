//
//  StorageAdapter.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/08.
//

import Foundation

// TODO: Data generic
protocol StorageAdapter {
    func upload(data: Data, completion: @escaping (Result<URL, Error>) -> Void)
    func download(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
