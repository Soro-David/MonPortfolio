<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link, router } from '@inertiajs/vue3';

defineProps({
    sliders: { type: Array, default: () => [] },
});

const destroy = (id) => {
    if (confirm('Supprimer ce slider ?')) {
        router.delete(route('admin.sliders.destroy', id));
    }
};
</script>

<template>
    <Head title="Sliders" />

    <AdminLayout>
        <template #header>
            <h1 class="text-xl font-semibold text-white">Sliders</h1>
        </template>

        <div class="flex justify-between items-center mb-6">
            <p class="text-gray-400 text-sm">{{ sliders.length }} slider(s)</p>
            <Link
                :href="route('admin.sliders.create')"
                class="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-lg font-medium hover:from-purple-600 hover:to-pink-600 transition text-sm"
            >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
                Nouveau Slider
            </Link>
        </div>

        <div class="grid gap-4">
            <div
                v-for="slider in sliders"
                :key="slider.id"
                class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-5 flex items-center justify-between gap-4"
            >
                <div class="flex items-center gap-4 min-w-0">
                    <!-- Miniature image1 -->
                    <div class="w-16 h-16 rounded-xl overflow-hidden flex-shrink-0 bg-slate-700">
                        <img
                            v-if="slider.primary_image"
                            :src="`/storage/${slider.primary_image}`"
                            :alt="slider.title"
                            class="w-full h-full object-cover"
                        />
                        <div v-else class="w-full h-full flex items-center justify-center text-gray-500">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01" />
                            </svg>
                        </div>
                    </div>

                    <div class="min-w-0">
                        <h3 class="text-white font-semibold truncate">{{ slider.title }}</h3>
                        <p v-if="slider.slogan" class="text-purple-300 text-sm truncate">{{ slider.slogan }}</p>
                        <div class="flex items-center gap-2 mt-1">
                            <span :class="['text-xs px-2 py-0.5 rounded-full', slider.is_active ? 'bg-green-500/20 text-green-400' : 'bg-red-500/20 text-red-400']">
                                {{ slider.is_active ? 'Actif' : 'Inactif' }}
                            </span>
                            <span class="text-xs text-gray-500">Ordre : {{ slider.order }}</span>
                        </div>
                    </div>
                </div>

                <div class="flex items-center gap-2 flex-shrink-0">
                    <Link
                        :href="route('admin.sliders.edit', slider.id)"
                        class="p-2 rounded-lg text-indigo-400 hover:bg-indigo-500/20 transition"
                        title="Modifier"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                        </svg>
                    </Link>
                    <button
                        @click="destroy(slider.id)"
                        class="p-2 rounded-lg text-red-400 hover:bg-red-500/20 transition"
                        title="Supprimer"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                    </button>
                </div>
            </div>

            <div v-if="sliders.length === 0" class="text-center py-16 text-gray-500">
                <svg class="w-12 h-12 mx-auto mb-4 opacity-40" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                <p>Aucun slider. Créez-en un !</p>
            </div>
        </div>
    </AdminLayout>
</template>
