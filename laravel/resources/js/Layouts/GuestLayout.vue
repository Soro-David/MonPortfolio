<script setup>
import ApplicationLogo from '@/Components/ApplicationLogo.vue';
import { Link } from '@inertiajs/vue3';
</script>

<template>
    <div class="relative min-h-screen overflow-hidden bg-slate-950 text-white">
        <div class="absolute inset-0">
            <div class="absolute left-0 top-0 h-72 w-72 rounded-full bg-cyan-500/20 blur-3xl" />
            <div class="absolute bottom-0 right-0 h-96 w-96 rounded-full bg-indigo-500/20 blur-3xl" />
            <div class="absolute inset-0 bg-[radial-gradient(circle_at_top,rgba(56,189,248,0.18),transparent_32%),radial-gradient(circle_at_bottom_right,rgba(129,140,248,0.16),transparent_28%)]" />
        </div>

        <div class="relative mx-auto flex min-h-screen w-full max-w-7xl items-center px-4 py-8 sm:px-6 lg:px-8">
            <div class="grid w-full overflow-hidden rounded-[2rem] border border-white/10 bg-white/5 shadow-2xl shadow-slate-950/40 backdrop-blur-xl lg:grid-cols-[1.1fr_0.9fr]">
                <div class="hidden flex-col justify-between border-b border-white/10 p-10 lg:flex lg:border-b-0 lg:border-r">
                    <div class="space-y-8">
                        <Link href="/" class="inline-flex items-center gap-4 text-white transition hover:text-cyan-200">
                            <span class="flex h-14 w-14 items-center justify-center rounded-2xl bg-white/10 ring-1 ring-white/15">
                                <ApplicationLogo class="h-9 w-9 fill-current text-cyan-300" />
                            </span>
                            <div>
                                <p class="text-sm uppercase tracking-[0.35em] text-cyan-200/80">Portfolio</p>
                                <h1 class="mt-1 text-2xl font-semibold">David Soro</h1>
                            </div>
                        </Link>

                        <div class="max-w-xl space-y-5">
                            <p class="inline-flex rounded-full border border-cyan-400/20 bg-cyan-400/10 px-4 py-1 text-xs font-medium uppercase tracking-[0.3em] text-cyan-200">
                                Espace sécurisé
                            </p>
                            <h2 class="text-4xl font-semibold leading-tight text-white xl:text-5xl">
                                Connectez-vous à votre espace d’administration.
                            </h2>
                            <p class="text-base leading-7 text-slate-300">
                                Gérez votre portfolio, vos contenus et votre présence en ligne depuis une interface élégante, rapide et sécurisée.
                            </p>
                        </div>
                    </div>

                    <div class="grid gap-4 sm:grid-cols-3">
                        <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                            <p class="text-sm text-slate-300">Design</p>
                            <p class="mt-2 text-lg font-semibold text-white">UI moderne</p>
                        </div>
                        <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                            <p class="text-sm text-slate-300">Accès</p>
                            <p class="mt-2 text-lg font-semibold text-white">Authentification</p>
                        </div>
                        <div class="rounded-2xl border border-white/10 bg-white/5 p-4">
                            <p class="text-sm text-slate-300">Performance</p>
                            <p class="mt-2 text-lg font-semibold text-white">Laravel + Vue</p>
                        </div>
                    </div>
                </div>

                <div class="flex min-h-[640px] items-center bg-slate-950/40 p-6 sm:p-10 lg:p-12">
                    <div class="mx-auto w-full max-w-md">
                        <div class="mb-8 lg:hidden">
                            <Link href="/" class="inline-flex items-center gap-3 text-white transition hover:text-cyan-200">
                                <span class="flex h-12 w-12 items-center justify-center rounded-2xl bg-white/10 ring-1 ring-white/15">
                                    <ApplicationLogo class="h-8 w-8 fill-current text-cyan-300" />
                                </span>
                                <div>
                                    <p class="text-xs uppercase tracking-[0.3em] text-cyan-200/80">Portfolio</p>
                                    <p class="text-lg font-semibold">David Soro</p>
                                </div>
                            </Link>
                        </div>

                        <slot />
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
