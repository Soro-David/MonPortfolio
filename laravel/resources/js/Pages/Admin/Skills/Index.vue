<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link, router } from '@inertiajs/vue3';

defineProps({
    skills: { type: Array, default: () => [] },
});

const destroy = (id) => {
    if (confirm('Supprimer cette compétence ?')) {
        router.delete(route('admin.skills.destroy', id));
    }
};
</script>

<template>
    <Head title="Compétences" />

    <AdminLayout>
        <template #header>
            <h1 class="text-xl font-semibold text-white">Compétences</h1>
        </template>

        <div class="flex justify-between items-center mb-6">
            <p class="text-gray-400 text-sm">{{ skills.length }} compétence(s)</p>
            <Link
                :href="route('admin.skills.create')"
                class="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-indigo-500 to-purple-500 text-white rounded-lg font-medium hover:from-indigo-600 hover:to-purple-600 transition text-sm"
            >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
                Nouvelle Compétence
            </Link>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            <div
                v-for="skill in skills"
                :key="skill.id"
                class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-5 flex flex-col gap-3"
            >
                <div class="flex items-center gap-3">
                    <div class="w-12 h-12 rounded-xl overflow-hidden flex-shrink-0 bg-slate-700">
                        <img v-if="skill.image" :src="`/storage/${skill.image}`" :alt="skill.title" class="w-full h-full object-contain p-1" />
                        <div v-else class="w-full h-full flex items-center justify-center text-2xl">⚡</div>
                    </div>
                    <div class="min-w-0 flex-1">
                        <h3 class="text-white font-semibold truncate">{{ skill.title }}</h3>
                        <p v-if="skill.subtitle" class="text-purple-300 text-sm truncate">{{ skill.subtitle }}</p>
                    </div>
                </div>

                <p v-if="skill.description" class="text-gray-400 text-sm line-clamp-2">{{ skill.description }}</p>

                <div class="flex items-center justify-between">
                    <span :class="['text-xs px-2 py-0.5 rounded-full', skill.is_active ? 'bg-green-500/20 text-green-400' : 'bg-red-500/20 text-red-400']">
                        {{ skill.is_active ? 'Actif' : 'Inactif' }}
                    </span>
                    <div class="flex gap-1">
                        <Link
                            :href="route('admin.skills.edit', skill.id)"
                            class="p-2 rounded-lg text-indigo-400 hover:bg-indigo-500/20 transition"
                        >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                            </svg>
                        </Link>
                        <button @click="destroy(skill.id)" class="p-2 rounded-lg text-red-400 hover:bg-red-500/20 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                            </svg>
                        </button>
                    </div>
                </div>
            </div>

            <div v-if="skills.length === 0" class="col-span-full text-center py-16 text-gray-500">
                <p>Aucune compétence. Créez-en une !</p>
            </div>
        </div>
    </AdminLayout>
</template>
