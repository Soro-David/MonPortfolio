<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const props = defineProps({
    project: { type: Object, default: null },
});

const isEdit = computed(() => !!props.project);

const form = useForm({
    name: props.project?.name ?? '',
    public_target: props.project?.public_target ?? '',
    description: props.project?.description ?? '',
    image: null,
    url: props.project?.url ?? '',
    github_url: props.project?.github_url ?? '',
    technologies: props.project?.technologies ?? '',
    order: props.project?.order ?? 0,
    is_active: props.project?.is_active ?? true,
});

const preview = ref(props.project?.image ? `/storage/${props.project.image}` : null);

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
            .post(route('admin.projects.update', props.project.id), {
                forceFormData: true,
                onFinish: () => form.transform((data) => data),
            });
    } else {
        form.post(route('admin.projects.store'));
    }
};
</script>

<template>
    <Head :title="isEdit ? 'Modifier Projet' : 'Nouveau Projet'" />

    <AdminLayout>
        <template #header>
            <div class="flex items-center gap-3">
                <Link :href="route('admin.projects.index')" class="text-gray-400 hover:text-white transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                    </svg>
                </Link>
                <h1 class="text-xl font-semibold text-white">{{ isEdit ? 'Modifier le Projet' : 'Nouveau Projet' }}</h1>
            </div>
        </template>

        <div class="max-w-3xl mx-auto">
            <form @submit.prevent="submit" class="space-y-6">

                <!-- Informations -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-5">
                    <h2 class="text-white font-semibold text-lg">Informations</h2>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Nom du projet <span class="text-red-400">*</span></label>
                        <input
                            v-model="form.name"
                            type="text"
                            required
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Portfolio Personnel"
                        />
                        <p v-if="form.errors.name" class="mt-1 text-red-400 text-sm">{{ form.errors.name }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Cible / Public visé</label>
                        <input
                            v-model="form.public_target"
                            type="text"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Développeurs, Entreprises..."
                        />
                        <p v-if="form.errors.public_target" class="mt-1 text-red-400 text-sm">{{ form.errors.public_target }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Description</label>
                        <textarea
                            v-model="form.description"
                            rows="4"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition resize-y"
                            placeholder="Décrivez le projet, ses fonctionnalités..."
                        ></textarea>
                        <p v-if="form.errors.description" class="mt-1 text-red-400 text-sm">{{ form.errors.description }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">Technologies utilisées</label>
                        <input
                            v-model="form.technologies"
                            type="text"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="Ex: Laravel, Vue.js, TailwindCSS, MySQL"
                        />
                        <p v-if="form.errors.technologies" class="mt-1 text-red-400 text-sm">{{ form.errors.technologies }}</p>
                    </div>
                </div>

                <!-- Liens -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-5">
                    <h2 class="text-white font-semibold text-lg">Liens</h2>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">URL du projet</label>
                        <input
                            v-model="form.url"
                            type="url"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="https://monprojet.com"
                        />
                        <p v-if="form.errors.url" class="mt-1 text-red-400 text-sm">{{ form.errors.url }}</p>
                    </div>

                    <div>
                        <label class="block text-gray-300 text-sm font-medium mb-2">URL GitHub</label>
                        <input
                            v-model="form.github_url"
                            type="url"
                            class="w-full px-4 py-3 bg-slate-900/60 border border-purple-500/30 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-purple-400 transition"
                            placeholder="https://github.com/user/repo"
                        />
                        <p v-if="form.errors.github_url" class="mt-1 text-red-400 text-sm">{{ form.errors.github_url }}</p>
                    </div>
                </div>

                <!-- Image -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6">
                    <h2 class="text-white font-semibold text-lg mb-4">Image du projet</h2>
                    <div class="flex items-start gap-5">
                        <div class="w-32 h-24 rounded-xl overflow-hidden flex-shrink-0 bg-slate-700 border border-dashed border-purple-500/30 flex items-center justify-center">
                            <img v-if="preview" :src="preview" alt="preview" class="w-full h-full object-cover" />
                            <svg v-else class="w-8 h-8 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01" />
                            </svg>
                        </div>
                        <div>
                            <label for="project-image" class="inline-flex items-center gap-2 px-4 py-2.5 bg-slate-700 hover:bg-slate-600 text-white rounded-xl cursor-pointer transition text-sm font-medium border border-white/10">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                                </svg>
                                Choisir une image
                            </label>
                            <input id="project-image" type="file" accept="image/*" class="hidden" @change="handleImage" />
                            <p v-if="form.errors.image" class="mt-1 text-red-400 text-sm">{{ form.errors.image }}</p>
                        </div>
                    </div>
                </div>

                <!-- Paramètres -->
                <div class="bg-slate-800/50 rounded-2xl border border-purple-500/20 p-6 space-y-4">
                    <h2 class="text-white font-semibold text-lg">Paramètres</h2>
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

                <div class="flex items-center justify-end gap-3">
                    <Link :href="route('admin.projects.index')" class="px-5 py-2.5 rounded-xl border border-white/10 text-gray-300 hover:text-white hover:bg-slate-700 transition text-sm font-medium">
                        Annuler
                    </Link>
                    <button type="submit" :disabled="form.processing" class="px-6 py-2.5 bg-gradient-to-r from-emerald-500 to-teal-500 text-white rounded-xl font-medium hover:from-emerald-600 hover:to-teal-600 disabled:opacity-50 transition text-sm">
                        {{ form.processing ? 'Enregistrement...' : (isEdit ? 'Mettre à jour' : 'Créer le projet') }}
                    </button>
                </div>
            </form>
        </div>
    </AdminLayout>
</template>
