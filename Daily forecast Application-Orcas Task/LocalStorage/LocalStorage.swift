//
//  LocalStorage.swift
//  Daily forecast Application-Orcas Task
//
//  Created by Youssef on 18/12/2020.
//

import Foundation
import RealmSwift

protocol LocalStorageProtocol {
    func save(_ object: ListVM)
    func findByPrimaryKey(_ id: String) -> ListVM?
}

class LocalStorage {
    
    private var realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            print(error)
            fatalError()
        }
    }
}

extension LocalStorage: LocalStorageProtocol {
    
    func save(_ object: ListVM) {
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print(error)
        }
    }
    
    func findByPrimaryKey(_ id: String) -> ListVM? {
        return realm.object(ofType: ListVM.self, forPrimaryKey: id)
    }
}
