//
//  LocalDataManager.swift
//  PulsePace
//
//  Created by James Chiu on 2/4/23.
//

import Foundation

final class LocalDataManager<T: Codable> {
    private static func fileURL(_ filename: String) throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
           .appendingPathComponent(filename)
    }

    func readDefault(bundlePath: String?, initData: T) -> T {
        if bundlePath == nil {
            return initData
        }
        if let url = Bundle.main.url(forResource: bundlePath, withExtension: "json"),
            let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                if let defaultData = try? decoder.decode(T.self, from: data) {
                    return defaultData
                }
        }
        return initData
    }

    func load(filename: String, bundlePath: String?, initData: T, completion: @escaping (Result<T, Error>) -> Void) {
          DispatchQueue.global(qos: .background).async {
              do {
                  let fileURL = try LocalDataManager.fileURL(filename)
                  print(fileURL)
                  guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                      DispatchQueue.main.async {
                          completion(.success(self.readDefault(bundlePath: bundlePath, initData: initData)))
                      }
                      return
                  }
                  let values = try JSONDecoder().decode(T.self, from: file.availableData)
                  DispatchQueue.main.async {
                      completion(.success(values))
                  }
              } catch {
                  DispatchQueue.main.async {
                      completion(.failure(error))
                  }
              }
          }
      }

    func save(values: T, filename: String, completion: @escaping (Result<Bool, Error>) -> Void) {
       DispatchQueue.global(qos: .background).async {
           do {
               let data = try JSONEncoder().encode(values)
               let outfile = try LocalDataManager.fileURL(filename)
               try data.write(to: outfile)
               DispatchQueue.main.async {
                   completion(.success(true))
               }
           } catch {
               DispatchQueue.main.async {
                   completion(.failure(error))
               }
           }
       }
   }
}
