package com.xogns.weather.di

import com.xogns.weather.presentation.OneCallViewModel
import org.koin.dsl.module

val viewModelModule = module {
    single { OneCallViewModel(get()) }
}