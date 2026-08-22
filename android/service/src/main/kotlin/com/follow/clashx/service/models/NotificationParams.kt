package com.follow.clashx.service.models

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class NotificationParams(
    val title: String = "FlClashY",
    val stopText: String = "Stop",
) : Parcelable
