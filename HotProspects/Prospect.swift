//
//  Prospect.swift
//  HotProspects
//
//  Created by Vivien on 5/17/23.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var dateAdded = Date()
}

enum SortOrder {
    case name, recent
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect] = []
    @Published var sortOrder: SortOrder = .name
    private var saveFileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("SavedData.json")
    }()
    
    init() {
        load()
    }
    
    private func load() {
        do {
            let data = try Data(contentsOf: saveFileURL)
            let decodedData = try JSONDecoder().decode([Prospect].self, from: data)
            people = decodedData
        } catch {
            print("Couldn't load data: \(error)")
            // If we couldn't load data, just keep `people` as an empty array
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: saveFileURL)
        } catch {
            print("Couldn't save data: \(error)")
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
