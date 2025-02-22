import WidgetKit
import SwiftUI
import Intents

private let appGroupID = "group.habitFlutter";

struct Provider: IntentTimelineProvider {
    // ウィジェットがデータを読み込む前に表示するプレースホルダーエントリを提供するためのメソッド
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), currentState: 0, habitTitle: "")
    }

    // ウィジェットが表示するスナップショットエントリを提供するためのメソッド
    // ウィジェットギャラリーでウィジェットを表示する際や、ウィジェットが初めて表示される際に使用
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults.init(suiteName:appGroupID)
        let currentState = data?.integer(forKey:  "currentState") ?? 0
        let habitTitle = data?.string(forKey: "habitTitle") ?? ""
        let entry = SimpleEntry(date: Date(), configuration: configuration, currentState: currentState, habitTitle: habitTitle)
        completion(entry)
    }
    
    // ウィジェットが表示するタイムラインエントリのシーケンスを提供するためのメソッド
    // ウィジェットが表示するエントリのシーケンスを指定し、それらのエントリがいつ表示されるかを制御する
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let data: UserDefaults? = UserDefaults.init(suiteName: appGroupID)
        let currentState = data?.integer(forKey: "currentState") ?? 0
        let habitTitle = data?.string(forKey: "habitTitle") ?? ""

        let entry = SimpleEntry(
            date: Date(),
            configuration: configuration,
            currentState: currentState,
            habitTitle: habitTitle
        )

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let currentState: Int
    let habitTitle: String
}

// 見た目を定義するためのビュー
struct habit_appEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text("\(entry.habitTitle)")
                .font(.system(size: 12))
                .foregroundColor(Color.green)
            Text("\(entry.currentState)")
                .font(.system(size: 50))
                .foregroundColor(colorScheme == .dark ? Color.white : Color(white: 0.3))
            Text("日")
                .font(.system(size: 14))
                .foregroundColor(Color.green)
        }
    }
}

struct habit_app: Widget {
    //ウィジェットを識別する文字列。ユーザーが選択する識別子であり、ウィジェットが表す内容をわかりやすく説明するもの
    let kind: String = "habit_app"

    var body: some WidgetConfiguration {
        // ユーザーが構成可能なプロパティをウィジェットが含む
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            habit_appEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct habit_app_Previews: PreviewProvider {
    static var previews: some View {
        habit_appEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),currentState: 0, habitTitle: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
