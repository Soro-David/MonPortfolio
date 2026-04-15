<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link } from '@inertiajs/vue3';

defineProps({
    stats: {
        type: Object,
        default: () => ({ sliders: 0, abouts: 0, skills: 0, projects: 0 }),
    },
});

const cards = [
    {
        label: 'Sliders',
        key: 'sliders',
        route: 'admin.sliders.index',
        bg: 'bg-blue-700',
        light: 'bg-blue-50 text-blue-700',
        icon: `<svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>`,
    },
    {
        label: 'À propos',
        key: 'abouts',
        route: 'admin.about.index',
        bg: 'bg-blue-500',
        light: 'bg-blue-50 text-blue-500',
        icon: `<svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>`,
    },
    {
        label: 'Compétences',
        key: 'skills',
        route: 'admin.skills.index',
        bg: 'bg-sky-600',
        light: 'bg-sky-50 text-sky-600',
        icon: `<svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" /></svg>`,
    },
    {
        label: 'Projets',
        key: 'projects',
        route: 'admin.projects.index',
        bg: 'bg-blue-800',
        light: 'bg-blue-50 text-blue-800',
        icon: `<svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" /></svg>`,
    },
];

const quickLinks = [
    { label: '+ Nouveau Slider', route: 'admin.sliders.create' },
    { label: '+ Nouvelle Compétence', route: 'admin.skills.create' },
    { label: '+ Nouveau Projet', route: 'admin.projects.create' },
    { label: '✎  Modifier À propos', route: 'admin.about.index' },
];
</script>

<template>
    <Head title="Dashboard Admin" />

    <AdminLayout>
        <template #header>
            <h1 class="text-xl font-semibold text-white">Dashboard</h1>
        </template>

        <!-- Statistiques -->
        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 mb-8">
            <Link
                v-for="card in cards"
                :key="card.key"
                :href="route(card.route)"
                class="block bg-slate-900/80 rounded-2xl p-5 shadow-sm border border-slate-800 hover:shadow-lg hover:shadow-blue-950/20 hover:-translate-y-0.5 transition-all"
            >
                <div class="flex items-start justify-between">
                    <div :class="['w-12 h-12 rounded-xl flex items-center justify-center text-white shadow-sm', card.bg]">
                        <span v-html="card.icon"></span>
                    </div>
                    <span class="text-3xl font-bold text-white">{{ stats[card.key] }}</span>
                </div>
                <p class="mt-4 text-slate-300 text-sm font-medium">{{ card.label }}</p>
                <div :class="['mt-2 text-xs font-semibold px-2 py-0.5 rounded-full inline-block', card.light]">Gérer →</div>
            </Link>
        </div>

        <!-- Accès rapides -->
        <div class="bg-slate-900/80 rounded-2xl border border-slate-800 shadow-sm p-6">
            <h2 class="text-base font-semibold text-slate-100 mb-4">Actions rapides</h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
                <Link
                    v-for="link in quickLinks"
                    :key="link.route"
                    :href="route(link.route)"
                    class="flex items-center justify-center px-4 py-3 rounded-xl border border-slate-700 bg-slate-800/80 text-blue-200 font-medium text-sm hover:bg-blue-600 hover:text-white hover:border-blue-600 transition"
                >
                    {{ link.label }}
                </Link>
            </div>
        </div>
    </AdminLayout>
</template>
