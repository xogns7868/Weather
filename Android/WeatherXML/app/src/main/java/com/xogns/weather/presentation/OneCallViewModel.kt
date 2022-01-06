package com.xogns.weather.presentation

import com.xogns.weather.domain.repository.OneCallRepository

class OneCallViewModel(private val oneCallRepository: OneCallRepository) {
    suspend fun getOneCall() {
        oneCallRepository.getOneCall(49.118866f, 6.180961f)
    }
}