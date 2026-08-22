package com.follow.clashx.common

import android.app.Application
import android.util.Log
import com.google.firebase.FirebaseApp
import com.google.firebase.crashlytics.FirebaseCrashlytics
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

object GlobalState {
    private const val TAG = "FlClashY"

    const val NOTIFICATION_CHANNEL = "FlClashY"
    const val NOTIFICATION_ID = 1

    lateinit var application: Application
        private set

    private val exceptionHandler = CoroutineExceptionHandler { _, e ->
        log("uncaught coroutine exception: ${e.message}")
    }

    val scope: CoroutineScope =
        CoroutineScope(SupervisorJob() + Dispatchers.Default + exceptionHandler)

    fun init(app: Application) {
        application = app
    }

    fun launch(block: suspend CoroutineScope.() -> Unit): Job = scope.launch(block = block)

    fun log(message: String) {
        Log.d(TAG, message)
    }

    fun setCrashlytics(enable: Boolean) {
        runCatching {
            // initializeApp returns null when the APK carries no Firebase config
            // (built without google-services.json) — degrade to a no-op then.
            FirebaseApp.initializeApp(application) ?: return
            FirebaseCrashlytics.getInstance().isCrashlyticsCollectionEnabled = enable
            log("crashlytics collection enabled=$enable")
        }.onFailure { log("setCrashlytics($enable) error: ${it.message}") }
    }
}
