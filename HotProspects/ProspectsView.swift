//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Vivien on 5/17/23.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingSortOrderDialog = false
    
    private let randomData: [(name: String, email: String)] = [
        ("Alice Johnson", "alice@example.com"),
        ("Bob Smith", "bob@example.com"),
        ("Carol Danvers", "carol@example.com"),
        ("Zack Mayor", "zack@example.com"),
        ("Katie Lim", "katie@example.com"),
        ("Tobius Lee", "tobius@example.com"),
        ("Helen Kim", "helen@example.com"),
        ("Emily Pilsben", "emily@example.com"),
        ("Samantha Mill", "samantha@example.com"),
        ("Michael Brown", "michaelb@example.com"),
        ("Laura Martin", "lauram@example.com"),
        ("John Davis", "johnd@example.com"),
        ("Sarah Wilson", "sarahw@example.com"),
        ("Jason Clark", "jasonc@example.com"),
        ("Rebecca Moore", "rebeccam@example.com"),
        ("Oliver Green", "oliverg@example.com"),
        ("Emma Turner", "emmat@example.com"),
        ("Lucas Scott", "lucass@example.com"),
        ("Sophia Hall", "sophiah@example.com"),
        ("Ethan Rivera", "ethanr@example.com")
    ]
    
    let filter: FilterType
    
    var sortedProspects: [Prospect] {
           switch prospects.sortOrder {
           case .name:
               return filteredProspects.sorted { $0.name < $1.name }
           case .recent:
               return filteredProspects.sorted { $0.dateAdded > $1.dateAdded }
           }
       }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    HStack {
                        Image(systemName: prospect.isContacted ? "checkmark.circle" : "questionmark.diamond")
                            .foregroundColor(prospect.isContacted ? .green : .blue)
                            .font(.system(size: 28, weight: .semibold))
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        .swipeActions {
                            if prospect.isContacted {
                                Button {
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    prospects.toggle(prospect)
                                } label: {
                                    Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                                }
                                .tint(.green)
                                
                                Button {
                                    addNotification(for: prospect)
                                } label: {
                                    Label("Remind Me", systemImage: "bell")
                                }
                                .tint(.orange)
                                
                                Button(role: .destructive) {
                                    prospects.remove(prospect)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Sort") {
                        isShowingSortOrderDialog = true
                }
            }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
            }
            .confirmationDialog("Sort Prospects", isPresented: $isShowingSortOrderDialog) {
                Button("By Name") {
                    prospects.sortOrder = .name
                }
                                
                Button("Most Recent") {
                    prospects.sortOrder = .recent
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                let randomPerson = randomData.randomElement() ?? ("John Doe", "john@example.com")
                        let simulatedData = "\(randomPerson.name)\n\(randomPerson.email)"

                        CodeScannerView(codeTypes: [.qr], simulatedData: simulatedData, completion: handleScan)
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled!")
                }
            }
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error = error {
                        print("Error requesting notification permissions: \(error)")
                    }
                }
            }
        }
    }

}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
