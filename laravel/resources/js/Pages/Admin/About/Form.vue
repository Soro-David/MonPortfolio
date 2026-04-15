<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    about: { type: Object, default: null },
});

const form = useForm({
    title: props.about?.title ?? '',
    subtitle1: props.about?.subtitle1 ?? '',
    subtitle2: props.about?.subtitle2 ?? '',
    subtitle3: props.about?.subtitle3 ?? '',
    image: null,
});

const preview = ref(props.about?.image ? `/storage/${props.about.image}` : null);

const handleImage = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.image = file;
        preview.value = URL.createObjectURL(file);
    }
};

const submit = () => {
    form.post(route('admin.about.store'));
};
</script>

<template>
    <Head title="À propos" />

    <AdminLayout>
        <template #header>
            <h1 class="text-xl font-semibold text-white">À propos</h1>
        </template>

        <div class="max-w-3xl mx-auto">
            <form @submit.prevent="submit" class="space-y-6">

                <!-- Textes -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-5">
                    <h2 class="text-white font-semibold text-lg">Informations</h2>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Titre <span class="text-red-400">*</span></label>
                        <input
                            v-model="form.title"
                            type="text"
                            required
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: David Soro"
                        />
                        <p v-if="form.errors.title" class="mt-1 text-red-400 text-sm">{{ form.errors.title }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Sous-titre 1 <span class="text-gray-500">(accroche)</span></label>
                        <input
                            v-model="form.subtitle1"
                            type="text"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Développeur Full Stack"
                        />
                        <p v-if="form.errors.subtitle1" class="mt-1 text-red-400 text-sm">{{ form.errors.subtitle1 }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Sous-titre 2 <span class="text-gray-500">(description courte)</span></label>
                        <input
                            v-model="form.subtitle2"
                            type="text"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Passionné par le web et les nouvelles technologies"
                        />
                        <p v-if="form.errors.subtitle2" class="mt-1 text-red-400 text-sm">{{ form.errors.subtitle2 }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Texte long <span class="text-gray-500">(bio détaillée)</span></label>
                        <textarea
                            v-model="form.subtitle3"
                            rows="5"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition resize-y"
                            placeholder="Décrivez votre parcours, vos valeurs..."
                        ></textarea>
                        <p v-if="form.errors.subtitle3" class="mt-1 text-red-400 text-sm">{{ form.errors.subtitle3 }}</p>
                    </div>
                </div>

                <!-- Photo -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6">
                    <h2 class="text-white font-semibold text-lg mb-4">Photo de profil</h2>

                    <div class="flex items-start gap-6">
                        <div class="w-32 h-32 rounded-2xl overflow-hidden flex-shrink-0 bg-slate-700 border-2 border-dashed border-purple-500/30">
                            <img v-if="preview" :src="preview" alt="preview" class="w-full h-full object-cover" />
                            <div v-else class="w-full h-full flex items-center justify-center text-gray-500">
                                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                </svg>
                            </div>
                        </div>

                        <div class="flex-1">
                            <label
                                for="about-image"
                                class="inline-flex items-center gap-2 px-4 py-2.5 bg-slate-700 hover:bg-slate-600 text-white rounded-xl cursor-pointer transition text-sm font-medium border border-white/10"
                            >
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                                </svg>
                                Choisir une image
                            </label>
                            <input id="about-image" type="file" accept="image/*" class="hidden" @change="handleImage" />
                            <p class="mt-2 text-gray-500 text-xs">PNG, JPG, WEBP — max 2 Mo</p>
                            <p v-if="form.errors.image" class="mt-1 text-red-400 text-sm">{{ form.errors.image }}</p>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex justify-end">
                    <button
                        type="submit"
                        :disabled="form.processing"
                        class="px-6 py-2.5 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-xl font-medium hover:from-purple-600 hover:to-pink-600 disabled:opacity-50 disabled:cursor-not-allowed transition text-sm"
                    >
                        {{ form.processing ? 'Enregistrement...' : 'Enregistrer' }}
                    </button>
                </div>
            </form>
        </div>
    </AdminLayout>
</template>
