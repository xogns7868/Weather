package com.xogns.weather.di

import com.google.gson.GsonBuilder
import com.xogns.weather.BuildConfig
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

val networkModule = module {
    single {
        Interceptor { chain ->
            chain.proceed(chain.request().newBuilder().apply {
                header("Accept", "application/vnd.github.mercy-preview+json") }.build())
        }
    }

    single {
        OkHttpClient.Builder().apply {
            addInterceptor(HttpLoggingInterceptor().apply {
                if (BuildConfig.DEBUG) {
                    level = HttpLoggingInterceptor.Level.BODY
                } }
            )
        }.build()
    }

    single { GsonBuilder().create() }

    single { Retrofit.Builder()
        .baseUrl(BuildConfig.WEATHER_API_URL)
        .addConverterFactory(GsonConverterFactory.create(get()))
        .client(get())
        .build()
    }
}