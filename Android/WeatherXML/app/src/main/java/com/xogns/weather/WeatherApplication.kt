package com.xogns.weather

import android.app.Application
import com.xogns.weather.di.dataModule
import com.xogns.weather.di.networkModule
import com.xogns.weather.di.viewModelModule
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin

class WeatherApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        startKoin {
            androidLogger()
            androidContext(this@WeatherApplication)
            modules(dataModule)
            modules(networkModule)
            modules(viewModelModule)
        }
    }
}