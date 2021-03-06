package com.xogns.weather.domain.repository

import com.xogns.weather.data.model.OneCallResponse

interface OneCallRepository {
    suspend fun getOneCall(lat: Float, lng: Float): OneCallResponse
}