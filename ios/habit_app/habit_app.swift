import WidgetKit
import SwiftUI

private let appGroupID = "group.habitFlutter"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> HabitEntry {
        HabitEntry(date: Date(), currentState: 0, habitTitle: "プレースホルダー")
    }

    func getSnapshot(in context: Context, completion: @escaping (HabitEntry) -> ()) {
        let entry: HabitEntry
        
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: appGroupID)
            let currentState = userDefaults?.integer(forKey: "currentState") ?? 0
            let habitTitle = userDefaults?.string(forKey: "habitTitle") ?? "習慣"
            
            entry = HabitEntry(
                date: Date(), 
                currentState: currentState, 
                habitTitle: habitTitle
            )
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HabitEntry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct HabitEntry: TimelineEntry {
    let date: Date
    let currentState: Int
    let habitTitle: String
}

struct habit_appEntryView : View {
    var entry: HabitEntry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // 背景色を設定
            Color("WidgetBackground") 
                .ignoresSafeArea()
            
            VStack {
                Text("\(entry.habitTitle)")
                    .font(.system(size: 12))
                    .foregroundColor(Color.green)
                Text("\(entry.currentState)")
                    .font(.system(size: 50))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 0.3))
            }
        }
    }
}

struct habit_app: Widget {
    let kind: String = "habit_app"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                habit_appEntryView(entry: entry)
                    .containerBackground(Color("WidgetBackground"), for: .widget) //ウィジェット全体の背景色を適用
            } else {
                habit_appEntryView(entry: entry)
                    .background(Color("WidgetBackground")) // iOS 16以下は `.background` を使う
            }
        }
    }
}


struct habit_app_Previews: PreviewProvider {
    static var previews: some View {
        habit_appEntryView(entry: HabitEntry(date: Date(), currentState: 0, habitTitle: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}