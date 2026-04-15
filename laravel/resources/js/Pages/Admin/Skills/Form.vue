<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const props = defineProps({
    skill: { type: Object, default: null },
});

const isEdit = computed(() => !!props.skill);

const form = useForm({
    title: props.skill?.title ?? '',
    subtitle: props.skill?.subtitle ?? '',
    description: props.skill?.description ?? '',
    image: null,
    order: props.skill?.order ?? 0,
    is_active: props.skill?.is_active ?? true,
});

const preview = ref(props.skill?.image ? `/storage/${props.skill.image}` : null);

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
            .post(route('admin.skills.update', props.skill.id), {
                forceFormData: true,
                onFinish: () => form.transform((data) => data),
            });
    } else {
        form.post(route('admin.skills.store'));
    }
};
</script>

<template>
    <Head :title="isEdit ? 'Modifier Compétence' : 'Nouvelle Compétence'" />

    <AdminLayout>
        <template #header>
            <div class="flex items-center gap-3">
                <Link :href="route('admin.skills.index')" class="text-gray-400 hover:text-white transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                    </svg>
                </Link>
                <h1 class="text-xl font-semibold text-white">{{ isEdit ? 'Modifier la Compétence' : 'Nouvelle Compétence' }}</h1>
            </div>
        </template>

        <div class="max-w-2xl mx-auto">
            <form @submit.prevent="submit" class="space-y-6">

                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-5">
                    <h2 class="text-white font-semibold text-lg">Informations</h2>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Titre <span class="text-red-400">*</span></label>
                        <input
                            v-model="form.title"
                            type="text"
                            required
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Laravel, Vue.js, Docker..."
                        />
                        <p v-if="form.errors.title" class="mt-1 text-red-400 text-sm">{{ form.errors.title }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Sous-titre</label>
                        <input
                            v-model="form.subtitle"
                            type="text"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Framework PHP"
                        />
                        <p v-if="form.errors.subtitle" class="mt-1 text-red-400 text-sm">{{ form.errors.subtitle }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Description</label>
                        <textarea
                            v-model="form.description"
                            rows="3"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition resize-y"
                            placeholder="Description de la compétence..."
                        ></textarea>
                        <p v-if="form.errors.description" class="mt-1 text-red-400 text-sm">{{ form.errors.description }}</p>
                    </div>
                </div>

                <!-- Logo / icône -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6">
                    <h2 class="text-white font-semibold text-lg mb-4">Logo / Icône</h2>
                    <div class="flex items-center gap-5">
                        <div class="w-20 h-20 rounded-xl overflow-hidden flex-shrink-0 bg-slate-700 border border-purple-500/20 flex items-center justify-center">
                            <img v-if="preview" :src="preview" alt="preview" class="w-full h-full object-contain p-2" />
                            <span v-else class="text-3xl">⚡</span>
                        </div>
                        <div>
                            <label for="skill-image" class="inline-flex items-center gap-2 px-4 py-2.5 bg-slate-700 hover:bg-slate-600 text-white rounded-xl cursor-pointer transition text-sm font-medium border border-white/10">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                                </svg>
                                Choisir une image
                            </label>
                            <input id="skill-image" type="file" accept="image/*" class="hidden" @change="handleImage" />
                            <p v-if="form.errors.image" class="mt-1 text-red-400 text-sm">{{ form.errors.image }}</p>
                        </div>
                    </div>
                </div>

                <!-- Paramètres -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-4">
                    <h2 class="text-white font-semibold text-lg">Paramètres</h2>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-gray-300 text-sm font-medium mb-2">Ordre</label>
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

                <div class="flex items-center justify-end gap-3">
                    <Link :href="route('admin.skills.index')" class="px-5 py-2.5 rounded-xl border border-white/10 text-gray-300 hover:text-white hover:bg-slate-700 transition text-sm font-medium">
                        Annuler
                    </Link>
                    <button type="submit" :disabled="form.processing" class="px-6 py-2.5 bg-gradient-to-r from-indigo-500 to-purple-500 text-white rounded-xl font-medium hover:from-indigo-600 hover:to-purple-600 disabled:opacity-50 transition text-sm">
                        {{ form.processing ? 'Enregistrement...' : (isEdit ? 'Mettre à jour' : 'Créer') }}
                    </button>
                </div>
            </form>
        </div>
    </AdminLayout>
</template>
