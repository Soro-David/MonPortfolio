<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const props = defineProps({
    slider: { type: Object, default: null },
});

const isEdit = computed(() => !!props.slider);

const form = useForm({
    title: props.slider?.title ?? '',
    slogan: props.slider?.slogan ?? '',
    subtitle: props.slider?.subtitle ?? '',
    image: null,
    order: props.slider?.order ?? 0,
    is_active: props.slider?.is_active ?? true,
});

const preview = ref(props.slider?.primary_image ? `/storage/${props.slider.primary_image}` : null);

const handleImage = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.image = file;
        preview.value = URL.createObjectURL(file);
    }
};

const submit = () => {
    if (isEdit.value) {
        form
            .transform((data) => ({
                ...data,
                _method: 'put',
            }))
            .post(route('admin.sliders.update', props.slider.id), {
                forceFormData: true,
                onFinish: () => form.transform((data) => data),
            });
    } else {
        form.post(route('admin.sliders.store'), {
            forceFormData: true,
        });
    }
};
</script>

<template>
    <Head :title="isEdit ? 'Modifier Slider' : 'Nouveau Slider'" />

    <AdminLayout>
        <template #header>
            <div class="flex items-center gap-3">
                <Link :href="route('admin.sliders.index')" class="text-gray-400 hover:text-white transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                    </svg>
                </Link>
                <h1 class="text-xl font-semibold text-white">{{ isEdit ? 'Modifier le Slider' : 'Nouveau Slider' }}</h1>
            </div>
        </template>

        <div class="max-w-3xl mx-auto">
            <form @submit.prevent="submit" class="space-y-6">

                <!-- Titre -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-5">
                    <h2 class="text-white font-semibold text-lg mb-1">Informations textuelles</h2>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Titre <span class="text-red-400">*</span></label>
                        <input
                            v-model="form.title"
                            type="text"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Bienvenue sur mon portfolio"
                            required
                        />
                        <p v-if="form.errors.title" class="mt-1 text-red-400 text-sm">{{ form.errors.title }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Slogan</label>
                        <input
                            v-model="form.slogan"
                            type="text"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Développeur Full Stack passionné"
                        />
                        <p v-if="form.errors.slogan" class="mt-1 text-red-400 text-sm">{{ form.errors.slogan }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Sous-titre</label>
                        <input
                            v-model="form.subtitle"
                            type="text"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Laravel • Vue.js • TailwindCSS"
                        />
                        <p v-if="form.errors.subtitle" class="mt-1 text-red-400 text-sm">{{ form.errors.subtitle }}</p>
                    </div>
                </div>

                <!-- Images -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-5">
                    <div class="flex items-start justify-between gap-4">
                        <div>
                            <h2 class="text-white font-semibold text-lg mb-1">Image du slide</h2>
                            <p class="text-sm text-gray-400">Un slide = une seule image. Pour plusieurs images, crée plusieurs slides.</p>
                        </div>
                        <span class="rounded-full bg-blue-500/15 px-3 py-1 text-xs font-semibold text-blue-200">1 image</span>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Image <span class="text-red-400">*</span></label>
                        <label
                            for="slider-image"
                            class="block cursor-pointer rounded-2xl border-2 border-dashed border-purple-500/30 hover:border-purple-400 transition overflow-hidden"
                        >
                            <img
                                v-if="preview"
                                :src="preview"
                                class="w-full h-72 object-cover"
                                alt="Aperçu du slide"
                            />
                            <div v-else class="h-72 flex flex-col items-center justify-center text-gray-500 gap-3 bg-slate-900/40">
                                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                                </svg>
                                <span class="text-sm font-medium">Choisir l'image du slide</span>
                            </div>
                        </label>
                        <input
                            id="slider-image"
                            type="file"
                            accept="image/*"
                            class="hidden"
                            @change="handleImage($event)"
                        />
                        <p v-if="form.errors.image" class="mt-1 text-red-400 text-xs">{{ form.errors.image }}</p>
                    </div>
                </div>

                <!-- Paramètres -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-4">
                    <h2 class="text-white font-semibold text-lg mb-1">Paramètres</h2>

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-gray-300 text-sm font-medium mb-2">Ordre d'affichage</label>
                            <input
                                v-model.number="form.order"
                                type="number"
                                min="0"
                                class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white focus:outline-none focus:border-purple-400 transition"
                            />
                        </div>
                        <div class="flex items-end pb-3">
                            <label class="flex items-center gap-3 cursor-pointer select-none">
                                <div
                                    :class="['relative w-11 h-6 rounded-full transition', form.is_active ? 'bg-purple-500' : 'bg-slate-600']"
                                    @click="form.is_active = !form.is_active"
                                >
                                    <div :class="['absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform', form.is_active ? 'translate-x-5' : 'translate-x-0']"></div>
                                </div>
                                <span class="text-gray-300 text-sm font-medium">Actif</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex items-center justify-end gap-3">
                    <Link
                        :href="route('admin.sliders.index')"
                        class="px-5 py-2.5 rounded-xl border border-white/10 text-gray-300 hover:text-white hover:bg-slate-700 transition text-sm font-medium"
                    >
                        Annuler
                    </Link>
                    <button
                        type="submit"
                        :disabled="form.processing"
                        class="px-6 py-2.5 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-xl font-medium hover:from-purple-600 hover:to-pink-600 disabled:opacity-50 disabled:cursor-not-allowed transition text-sm"
                    >
                        {{ form.processing ? 'Enregistrement...' : (isEdit ? 'Mettre à jour' : 'Créer le slider') }}
                    </button>
                </div>
            </form>
        </div>
    </AdminLayout>
</template>
