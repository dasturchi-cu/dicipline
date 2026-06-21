package uz.rejabon.rejabon_ai

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class RejabonWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val streak = widgetData.getInt("streak", 0)
        val tasks = widgetData.getInt("tasks_today", 0)
        val goal = widgetData.getString("main_goal", "Maqsad") ?: "Maqsad"
        val goalEmoji = widgetData.getString("goal_emoji", "🎯") ?: "🎯"
        val progress = widgetData.getInt("daily_progress", 0)

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.rejabon_widget).apply {
                setTextViewText(R.id.widget_streak, "🔥 $streak")
                setTextViewText(R.id.widget_tasks, "📋 $tasks")
                setTextViewText(R.id.widget_goal, "$goalEmoji $goal")
                setTextViewText(R.id.widget_progress, "📈 $progress% kunlik progress")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
