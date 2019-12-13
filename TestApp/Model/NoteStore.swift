//
//  NoteStore.swift
//  TestApp
//
//  Created by HARDIK-SNEHAL on 2019-12-11.
//  Copyright © 2019 AlayaCare. All rights reserved.
//

import UIKit

enum NoteResult {
    case success([Note])
    case failure(Error)
}

class NoteStore {
    
    var notes = [Note]()
    let userDefaults = UserDefaults.standard

    func getNotes(completion: @escaping (NoteResult) -> Void) {
        
        guard
            let url = Bundle.main.url(forResource: "NotesData", withExtension: "json"),
            let data = try? Data(contentsOf: url)
            else {
                return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let result = try decoder.decode([Note].self, from: data)
                completion(.success(result))
        } catch let error {
             completion(.failure(error))
        }
    }
}

struct Pref {
    static let keyNote = "NotesArray"
    static var note: [Note]? {
        get {
            if let data = UserDefaults.standard.object(forKey: keyNote) as? Data {
                do {
                    return try JSONDecoder().decode([Note].self, from: data)
                } catch {
                    print("Error while decoding user data")
                }
            }
            return nil
        }
        set {
            if let newValue = newValue {
                do {
                    let data = try JSONEncoder().encode(newValue)
                    UserDefaults.standard.set(data, forKey: keyNote)
                } catch {
                    print("Error while encoding user data")
                }
            }
        }
    }
}
