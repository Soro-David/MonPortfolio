<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link, router } from '@inertiajs/vue3';

defineProps({
    projects: { type: Array, default: () => [] },
});

const destroy = (id) => {
    if (confirm('Supprimer ce projet ?')) {
        router.delete(route('admin.projects.destroy', id));
    }
};
</script>

<template>
    <Head title="Projets" />

    <AdminLayout>
        <template #header>
            <h1 class="text-xl font-semibold text-white">Projets</h1>
        </template>

        <div class="flex justify-between items-center mb-6">
            <p class="text-gray-400 text-sm">{{ projects.length }} projet(s)</p>
            <Link
                :href="route('admin.projects.create')"
                class="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-emerald-500 to-teal-500 text-white rounded-lg font-medium hover:from-emerald-600 hover:to-teal-600 transition text-sm"
            >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
                Nouveau Projet
            </Link>
        </div>

        <div class="grid gap-4">
            <div
                v-for="project in projects"
                :key="project.id"
                class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-5 flex items-center justify-between gap-4"
            >
                <div class="flex items-center gap-4 min-w-0">
                    <div class="w-16 h-16 rounded-xl overflow-hidden flex-shrink-0 bg-slate-700">
                        <img v-if="project.image" :src="`/storage/${project.image}`" :alt="project.name" class="w-full h-full object-cover" />
                        <div v-else class="w-full h-full flex items-center justify-center text-gray-500">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                            </svg>
                        </div>
                    </div>
                    <div class="min-w-0 flex-1">
                        <h3 class="text-white font-semibold truncate">{{ project.name }}</h3>
                        <p v-if="project.public_target" class="text-purple-300 text-sm truncate">{{ project.public_target }}</p>
                        <div class="flex flex-wrap items-center gap-2 mt-1">
                            <span v-if="project.technologies" class="text-xs text-gray-400 bg-slate-700 px-2 py-0.5 rounded-full truncate max-w-[200px]">{{ project.technologies }}</span>
                            <span :class="['text-xs px-2 py-0.5 rounded-full', project.is_active ? 'bg-green-500/20 text-green-400' : 'bg-red-500/20 text-red-400']">
                                {{ project.is_active ? 'Actif' : 'Inactif' }}
                            </span>
                        </div>
                    </div>
                </div>

                <div class="flex items-center gap-2 flex-shrink-0">
                    <a v-if="project.url" :href="project.url" target="_blank" class="p-2 rounded-lg text-gray-400 hover:text-white hover:bg-slate-700 transition" title="Voir le site">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                        </svg>
                    </a>
                    <Link :href="route('admin.projects.edit', project.id)" class="p-2 rounded-lg text-indigo-400 hover:bg-indigo-500/20 transition" title="Modifier">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                        </svg>
                    </Link>
                    <button @click="destroy(project.id)" class="p-2 rounded-lg text-red-400 hover:bg-red-500/20 transition" title="Supprimer">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                    </button>
                </div>
            </div>

            <div v-if="projects.length === 0" class="text-center py-16 text-gray-500">
                <p>Aucun projet. Créez-en un !</p>
            </div>
        </div>
    </AdminLayout>
</template>
