package com.xogns.weather.data.repository

import com.xogns.weather.BuildConfig
import com.xogns.weather.data.remote.api.ApiService
import com.xogns.weather.domain.repository.OneCallRepository

class OneCallRepositoryImpl(
    private val apiService: ApiService
): OneCallRepository {
    override suspend fun getOneCall(lat: Float, lng: Float) = apiService.getOneCall(lat, lng, BuildConfig.WEATHER_API_KEY)
}