import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), subjects: [Subject(name: "Math", day: "Monday", time: "10:00 AM")])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let date = Date()
        let entry: SimpleEntry

        if context.isPreview {
           
            entry = SimpleEntry(date: date, subjects: [
                Subject(name: "Math", day: "Monday", time: "10:00 AM"),
                Subject(name: "Physics", day: "Tuesday", time: "1:00 PM"),
                Subject(name: "History", day: "Wednesday", time: "9:30 AM")
            ])
        } else {
            
            entry = placeholder(in: context)
        }

        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

      
        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, subjects: loadSubjectsForToday())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    
    func loadSubjectsForToday() -> [Subject] {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Full day name
        let todayString = formatter.string(from: today)
        
        if let data = UserDefaults.standard.data(forKey: "subjects"),
           let savedSubjects = try? JSONDecoder().decode([Subject].self, from: data) {
            let subjectsForToday = savedSubjects.filter { $0.day == todayString }
            return subjectsForToday
        }
        return []
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let subjects: [Subject]
}

struct CollegeifyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Subjects")
                .font(.headline)
            ForEach(entry.subjects) { subject in
                VStack(alignment: .leading) {
                    Text(subject.name)
                        .font(.subheadline)
                    Text(subject.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 2)
            }
        }
        .padding()
        .containerBackground(.background, for: .widget)
    }
}

struct CollegeifyWidget: Widget {
    let kind: String = "CollegeifyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CollegeifyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Collegeify Widget")
        .description("View today's subjects.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CollegeifyWidget_Previews: PreviewProvider {
    static var previews: some View {
        CollegeifyWidgetEntryView(entry: SimpleEntry(date: Date(), subjects: [Subject(name: "Math", day: "Monday", time: "10:00 AM")]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
