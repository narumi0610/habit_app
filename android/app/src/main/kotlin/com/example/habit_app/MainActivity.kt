package com.flutter.habit_app
import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import HomeWidgetGlanceWidgetReceiver
import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.currentState
import androidx.glance.text.Text
import io.flutter.embedding.android.FlutterActivity
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.*
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider

class MainActivity: FlutterActivity() {
}
class HomeWidgetGlanceReceiver : HomeWidgetGlanceWidgetReceiver<HomeWidgetGlanceAppWidget>() {
    override val glanceAppWidget = HomeWidgetGlanceAppWidget()
}

class HomeWidgetGlanceAppWidget : GlanceAppWidget(){
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState())
        }
    }

}


@Composable
private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
    val streak = currentState.preferences.getInt("currentState", 0) // デフォルト値は 0

    Column(
        modifier = GlanceModifier.run {
            fillMaxSize()
                .background(ColorProvider(Color.White)) // 背景を白に設定
                .padding(8.dp)
        },
        horizontalAlignment = Alignment.CenterHorizontally,  // 中央揃え
        verticalAlignment = Alignment.CenterVertically
    ) {
        // "継続"のテキスト
        Text(
            text = "継続",
            style = TextStyle(
                color = ColorProvider(Color.Green),  // テキストカラーを緑に設定
                fontSize = 14.sp                   // フォントサイズ14sp
            )
        )

        // 継続日数
        Text(
            text = "$streak",
            style = TextStyle(
                color = ColorProvider(Color.Black), // フォントカラーを黒に設定
                fontSize = 30.sp                   // フォントサイズ50sp
            ),
            
        )

        // "日"のテキスト
        Text(
            text = "日",
            style = TextStyle(
                color = ColorProvider(Color.Green),  // テキストカラーを緑に設定
                fontSize = 14.sp                   // フォントサイズ14sp
            )
        )
    }
}
