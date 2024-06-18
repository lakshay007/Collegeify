//  ContentView.swift
//  Collegeify
//
//  Created by lakshay chauhan on 18/06/24.
//

import SwiftUI
import WidgetKit


struct ContentView: View {
    @State private var subjects: [Subject] = []
    @State private var newSubjectName = ""
    @State private var selectedDay = "Monday"
    @State private var selectedTime = Date()

    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add New Subject")) {
                        TextField("Subject Name", text: $newSubjectName)
                        
                        Picker("Day", selection: $selectedDay) {
                            ForEach(days, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        
                        Button(action: addSubject) {
                            Text("Add Subject")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    Section(header: Text("Timetable")) {
                        List {
                            ForEach(subjects) { subject in
                                HStack {
                                    Text(subject.name)
                                    Spacer()
                                    Text("\(subject.day) at \(formatTime(subject.time))")
                                }
                            }
                            .onDelete(perform: deleteSubject)
                        }
                    }
                }
            }
            .navigationTitle("Collegeify")
            .toolbar {
                EditButton()
            }
        }
    }
    
   

    func addSubject() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: selectedTime)
        
        let newSubject = Subject(name: newSubjectName, day: selectedDay, time: timeString)
        subjects.append(newSubject)
        
        // Save to UserDefaults
        if let data = try? JSONEncoder().encode(subjects) {
            UserDefaults.standard.set(data, forKey: "subjects")
        }
        
       
        WidgetCenter.shared.reloadAllTimelines()
        
       
        newSubjectName = ""
        selectedDay = "Monday"
        selectedTime = Date()
    }

    
    func deleteSubject(at offsets: IndexSet) {
        subjects.remove(atOffsets: offsets)
    }
    
    func formatTime(_ time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = formatter.date(from: time) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        return time
    }
}

#Preview {
    ContentView()
}
