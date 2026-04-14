<script setup>
import { Head } from "@inertiajs/vue3";
</script>

<template>
    <Head title="Accueil - Mon Portfolio" />
    
    <div class="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
        <header class="fixed w-full top-0 z-50 bg-slate-900/80 backdrop-blur-sm border-b border-purple-500/20">
            <nav class="container mx-auto px-6 py-4">
                <div class="flex items-center justify-between">
                    <div class="text-2xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                        Portfolio
                    </div>
                    <div class="hidden md:flex space-x-8">
                        <a href="#accueil" class="text-gray-300 hover:text-purple-400 transition">Accueil</a>
                        <a href="#apropos" class="text-gray-300 hover:text-purple-400 transition">À propos</a>
                        <a href="#projets" class="text-gray-300 hover:text-purple-400 transition">Projets</a>
                        <a href="#contact" class="text-gray-300 hover:text-purple-400 transition">Contact</a>
                    </div>
                </div>
            </nav>
        </header>

        <section id="accueil" class="pt-32 pb-20 px-6">
            <div class="container mx-auto text-center">
                <div class="max-w-4xl mx-auto">
                    <h1 class="text-5xl md:text-7xl font-bold text-white mb-6">
                        Bienvenue sur mon
                        <span class="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                            Portfolio
                        </span>
                    </h1>
                    <p class="text-xl md:text-2xl text-gray-300 mb-8">
                        Développeur Full Stack passionné
                    </p>
                    <div class="flex justify-center gap-4">
                        <a href="#projets" 
                           class="px-8 py-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-full font-semibold hover:scale-105 transition transform">
                            Voir mes projets
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <section id="apropos" class="py-20 px-6">
            <div class="container mx-auto max-w-6xl">
                <h2 class="text-4xl font-bold text-white mb-12 text-center">
                    À propos de moi
                </h2>
                <div class="grid md:grid-cols-2 gap-12 items-center">
                    <div class="space-y-6">
                        <p class="text-gray-300 text-lg leading-relaxed">
                            Développeur passionné avec expertise en développement web moderne.
                            Je crée des applications élégantes et performantes.
                        </p>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-slate-800/50 backdrop-blur p-6 rounded-lg border border-purple-500/20">
                            <div class="text-purple-400 text-4xl mb-2">⚡</div>
                            <h3 class="text-white font-semibold mb-2">Performance</h3>
                        </div>
                        <div class="bg-slate-800/50 backdrop-blur p-6 rounded-lg border border-purple-500/20">
                            <div class="text-purple-400 text-4xl mb-2">🎨</div>
                            <h3 class="text-white font-semibold mb-2">Design</h3>
                        </div>
                        <div class="bg-slate-800/50 backdrop-blur p-6 rounded-lg border border-purple-500/20">
                            <div class="text-purple-400 text-4xl mb-2">🚀</div>
                            <h3 class="text-white font-semibold mb-2">Innovation</h3>
                        </div>
                        <div class="bg-slate-800/50 backdrop-blur p-6 rounded-lg border border-purple-500/20">
                            <div class="text-purple-400 text-4xl mb-2">💡</div>
                            <h3 class="text-white font-semibold mb-2">Créativité</h3>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-20 px-6 bg-slate-900/50">
            <div class="container mx-auto max-w-6xl">
                <h2 class="text-4xl font-bold text-white mb-12 text-center">
                    Technologies
                </h2>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
                    <div class="bg-slate-800/50 backdrop-blur p-6 rounded-lg border border-purple-500/20 text-center hover:border-purple-400 transition">
                        <div class="text-4xl mb-3">🐘</div>
                        <h3 class="text-white font-semibold">Laravel</h3>
                    </div>
                    <div class="bg-slate-800/50 backdrop-blur p-6 rounded-lg border border-purple-500/20 text-center hover:border-purple-400 transition">
                        <div class="text-4xl mb-3">💚</div>
                        <h3 class="text-white font-semibold">Vue.js</h3>
                    </div>
                    <div class="bg-slate-800/50 backdrop-blur p-6 rounded-lg border border-purple-500/20 text-center hover:border-purple-400 transition">
                        <div class="text-4xl mb-3">⚛️</div>
                        <h3 class="text-white font-semibold">Inertia.js</h3>
                    </div>
                    <div class="bg-slate-800/50 backdrop-blur p-6 rounded-lg border border-purple-500/20 text-center hover:border-purple-400 transition">
                        <div class="text-4xl mb-3">🎨</div>
                        <h3 class="text-white font-semibold">Tailwind</h3>
                    </div>
                </div>
            </div>
        </section>

        <section id="projets" class="py-20 px-6">
            <div class="container mx-auto max-w-6xl">
                <h2 class="text-4xl font-bold text-white mb-12 text-center">
                    Mes Projets
                </h2>
                <div class="grid md:grid-cols-3 gap-8">
                    <div class="bg-slate-800/50 backdrop-blur rounded-lg overflow-hidden border border-purple-500/20 hover:border-purple-400 transition">
                        <div class="h-48 bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center">
                            <div class="text-white text-6xl">🚀</div>
                        </div>
                        <div class="p-6">
                            <h3 class="text-xl font-semibold text-white mb-2">Projet 1</h3>
                            <p class="text-gray-400 mb-4">Application web innovante</p>
                        </div>
                    </div>
                    <div class="bg-slate-800/50 backdrop-blur rounded-lg overflow-hidden border border-purple-500/20 hover:border-purple-400 transition">
                        <div class="h-48 bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center">
                            <div class="text-white text-6xl">💼</div>
                        </div>
                        <div class="p-6">
                            <h3 class="text-xl font-semibold text-white mb-2">Projet 2</h3>
                            <p class="text-gray-400 mb-4">Plateforme e-commerce</p>
                        </div>
                    </div>
                    <div class="bg-slate-800/50 backdrop-blur rounded-lg overflow-hidden border border-purple-500/20 hover:border-purple-400 transition">
                        <div class="h-48 bg-gradient-to-br from-green-500 to-emerald-500 flex items-center justify-center">
                            <div class="text-white text-6xl">📱</div>
                        </div>
                        <div class="p-6">
                            <h3 class="text-xl font-semibold text-white mb-2">Projet 3</h3>
                            <p class="text-gray-400 mb-4">Application mobile</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="contact" class="py-20 px-6 bg-slate-900/50">
            <div class="container mx-auto max-w-4xl text-center">
                <h2 class="text-4xl font-bold text-white mb-6">
                    Travaillons ensemble
                </h2>
                <p class="text-xl text-gray-300 mb-12">
                    Vous avez un projet ? Contactez-moi !
                </p>
                <div class="flex justify-center gap-6">
                    <a href="mailto:contact@example.com" 
                       class="px-8 py-4 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-full font-semibold hover:scale-105 transition transform">
                        📧 Email
                    </a>
                </div>
            </div>
        </section>

        <footer class="py-8 px-6 border-t border-purple-500/20">
            <div class="container mx-auto text-center text-gray-400">
                <p>© 2026 Mon Portfolio. Fait avec Laravel & Vue.js</p>
            </div>
        </footer>
    </div>
</template>
