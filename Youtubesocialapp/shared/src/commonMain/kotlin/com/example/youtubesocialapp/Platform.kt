package com.example.youtubesocialapp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform