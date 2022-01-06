package com.xogns.weather.di

import com.xogns.weather.data.remote.api.ApiService
import com.xogns.weather.data.repository.OneCallRepositoryImpl
import com.xogns.weather.domain.repository.OneCallRepository
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.create

val dataModule = module {
    single<ApiService> { get<Retrofit>().create() }
    single<OneCallRepository> { OneCallRepositoryImpl(get()) }
}