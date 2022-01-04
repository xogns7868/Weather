package com.xogns.weather.data.api

import com.xogns.weather.data.model.OneCallResponse
import retrofit2.http.GET
import retrofit2.http.Query

interface ApiService {
    @GET("onecall")
    fun getOneCall(@Query("lat") lat: Float, @Query("lon") lon: Float, @Query("appid") apiKey: String): OneCallResponse
}