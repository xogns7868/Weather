package com.xogns.weather.data

import com.xogns.weather.data.repository.OneCallRepositoryImpl
import com.xogns.weather.domain.repository.OneCallRepository
import org.koin.dsl.module
import retrofit2.Retrofit

fun dataModule() = module {
    single<OneCallRepository> { OneCallRepositoryImpl(get()) }
}