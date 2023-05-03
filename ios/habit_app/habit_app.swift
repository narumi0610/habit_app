//
//  habit_app.swift
//  habit_app
//
//  Created by mac on 2023/04/27.
//

import WidgetKit
import SwiftUI
import Intents

private let appGroupID = "group.habitFlutter";

struct Provider: IntentTimelineProvider {
    // ウィジェットがデータを読み込む前に表示するプレースホルダーエントリを提供するためのメソッド
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), currentState: 0)
    }

    // ウィジェットが表示するスナップショットエントリを提供するためのメソッド
    // ウィジェットギャラリーでウィジェットを表示する際や、ウィジェットが初めて表示される際に使用
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults.init(suiteName:appGroupID)
        let currentState = data?.integer(forKey:  "currentState") ?? 0
        let entry = SimpleEntry(date: Date(), configuration: configuration, currentState: currentState)
        completion(entry)
    }
    
    // ウィジェットが表示するタイムラインエントリのシーケンスを提供するためのメソッド
    // ウィジェットが表示するエントリのシーケンスを指定し、それらのエントリがいつ表示されるかを制御する
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let data: UserDefaults? = UserDefaults.init(suiteName: appGroupID)
        let currentState = data?.integer(forKey: "currentState") ?? 0
        // 現在の日時とUserDefaultsから取得した現在の状態を使用してエントリを作成
        let entry = SimpleEntry(date: Date(), configuration: configuration, currentState: currentState)

        // アプリのデータに従って更新されるタイムラインを作成
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let currentState: Int
}

struct habit_appEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("\(entry.currentState)")
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
        habit_appEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),currentState: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
