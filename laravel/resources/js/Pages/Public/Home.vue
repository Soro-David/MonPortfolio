<script setup>
import { Head, useForm } from "@inertiajs/vue3";
import { computed, ref, onMounted, onBeforeUnmount } from 'vue';

const props = defineProps({
    sliders: { type: Array, default: () => [] },
    projects: { type: Array, default: () => [] },
    skills: { type: Array, default: () => [] },
    about: { type: Object, default: null },
});

const loading = ref(true);
const currentSlide = ref(0);
let sliderInterval = null;

const heroSlides = computed(() => {
    return props.sliders.map((slider) => {
        const primaryImage = slider.primary_image || slider.image1 || slider.image2 || slider.image3 || null;

        return {
            id: `slider-${slider.id}`,
            sliderId: slider.id,
            image: primaryImage,
            title: slider.title,
            slogan: slider.slogan,
            subtitle: slider.subtitle,
        };
    });
});

const activeHeroSlide = computed(() => heroSlides.value[currentSlide.value] ?? null);

const clearSliderInterval = () => {
    if (sliderInterval) {
        clearInterval(sliderInterval);
        sliderInterval = null;
    }
};

const startSliderInterval = () => {
    clearSliderInterval();

    if (heroSlides.value.length > 1) {
        sliderInterval = setInterval(() => {
            currentSlide.value = (currentSlide.value + 1) % heroSlides.value.length;
        }, 3000);
    }
};

const contactForm = useForm({
    name: '',
    email: '',
    subject: '',
    message: '',
});

onMounted(() => {
    setTimeout(() => {
        loading.value = false;
    }, 2000);

    startSliderInterval();
});

onBeforeUnmount(() => {
    clearSliderInterval();
});

const goToSlide = (index) => {
    currentSlide.value = index;
    startSliderInterval();
};

const submitContact = () => {
    contactForm.post(route('contact.store'), {
        preserveScroll: true,
        onSuccess: () => {
            contactForm.reset();
            alert('Message envoyé avec succès !');
        }
    });
};
</script>

<template>
    <Head title="Accueil - Mon Portfolio" />

    <!-- Loader -->
    <Transition name="fade">
        <div v-if="loading" class="fixed inset-0 z-[100] bg-blue-900 flex items-center justify-center">
            <div class="text-center">
                <div class="relative mx-auto w-24 h-24">
                    <div class="w-24 h-24 border-8 border-yellow-400/30 border-t-yellow-400 rounded-full animate-spin"></div>
                    <div class="absolute inset-0 flex items-center justify-center">
                        <div class="w-14 h-14 border-8 border-red-500/30 border-b-red-500 rounded-full animate-spin animation-delay-150"></div>
                    </div>
                </div>
                <h2 class="mt-8 text-3xl font-bold text-white animate-pulse">Bienvenue</h2>
                <p class="mt-2 text-yellow-300">Chargement en cours...</p>
            </div>
        </div>
    </Transition>

    <div class="min-h-screen bg-blue-950">
        <!-- NAVBAR -->
        <header class="fixed w-full top-0 z-50 bg-blue-900 shadow-lg border-b-4 border-yellow-400">
            <nav class="container mx-auto px-6 py-0">
                <div class="flex items-center justify-between h-16">
                    <!-- Logo -->
                    <div class="flex items-center gap-2">
                        <div class="w-9 h-9 bg-yellow-400 rounded-lg flex items-center justify-center shadow">
                            <span class="text-blue-900 font-black text-lg leading-none">SDD</span>
                        </div>
                        <span class="text-white font-bold text-lg tracking-wide hidden sm:block">SORO DOGNENIN DAVID</span>
                    </div>
                    <!-- Liens -->
                    <div class="flex items-center gap-1 md:gap-2">
                        <a href="#accueil" class="px-3 py-1.5 text-blue-200 hover:text-yellow-400 hover:bg-blue-800 rounded-lg transition font-medium text-sm">Accueil</a>
                        <a href="#apropos" class="px-3 py-1.5 text-blue-200 hover:text-yellow-400 hover:bg-blue-800 rounded-lg transition font-medium text-sm">À propos</a>
                        <a href="#competences" class="px-3 py-1.5 text-blue-200 hover:text-yellow-400 hover:bg-blue-800 rounded-lg transition font-medium text-sm">Compétences</a>
                        <a href="#projets" class="px-3 py-1.5 text-blue-200 hover:text-yellow-400 hover:bg-blue-800 rounded-lg transition font-medium text-sm">Projets</a>
                        <a href="#contact" class="px-4 py-1.5 bg-red-500 hover:bg-red-600 text-white rounded-lg transition font-semibold text-sm shadow ml-2">Contact</a>
                    </div>
                </div>
            </nav>
        </header>

        <!-- Section Hero / Slider -->
        <section id="accueil" class="relative min-h-screen overflow-hidden bg-blue-950">
            <div v-if="heroSlides.length > 0" class="relative min-h-screen">
                <Transition name="slide-fade" mode="out-in">
                    <div v-if="activeHeroSlide" :key="activeHeroSlide.id" class="absolute inset-0">
                        <img
                            v-if="activeHeroSlide.image"
                            :src="`/storage/${activeHeroSlide.image}`"
                            :alt="activeHeroSlide.title"
                            class="h-full w-full object-cover"
                        />
                        <div v-else class="h-full w-full bg-gradient-to-br from-blue-950 via-blue-900 to-blue-700"></div>
                        <div class="absolute inset-0 bg-gradient-to-r from-blue-950/95 via-blue-900/65 to-blue-950/55"></div>
                        <div class="absolute inset-0 bg-gradient-to-t from-blue-950/90 via-transparent to-blue-950/40"></div>
                    </div>
                </Transition>

                <div class="relative z-10 flex min-h-screen items-center justify-center px-6 pt-24 pb-12 text-center">
                    <div class="container mx-auto">
                        <div class="mx-auto flex max-w-5xl flex-col items-center">
                            <span class="inline-flex items-center rounded-full border border-yellow-300/50 bg-blue-950/55 px-5 py-2 text-sm font-bold uppercase tracking-[0.35em] text-yellow-300 backdrop-blur-sm">
                                Portfolio
                            </span>

                            <h1 class="mt-6 max-w-4xl text-5xl font-black leading-[0.95] text-yellow-300 drop-shadow-[0_6px_20px_rgba(0,0,0,0.45)] md:text-7xl xl:text-8xl">
                                <span class="inline bg-blue-950/55 px-3 py-1 box-decoration-clone text-yellow-300">{{ activeHeroSlide.title }}</span>
                            </h1>

                            <p v-if="activeHeroSlide?.slogan" class="mt-5 inline-block max-w-3xl rounded-2xl bg-yellow-400 px-5 py-3 text-xl font-extrabold text-blue-950 shadow-xl shadow-yellow-400/20 md:text-3xl">
                                {{ activeHeroSlide.slogan }}
                            </p>

                            <p v-if="activeHeroSlide?.subtitle" class="mt-5 max-w-2xl rounded-2xl bg-blue-900/45 px-5 py-4 text-base font-medium text-blue-100 backdrop-blur-sm md:text-xl">
                                {{ activeHeroSlide.subtitle }}
                            </p>

                            <div class="mt-10 flex flex-wrap items-center gap-4">
                                <a href="#projets" class="rounded-2xl bg-yellow-400 px-8 py-4 text-base font-extrabold text-blue-950 shadow-lg shadow-yellow-400/20 transition hover:bg-yellow-300">
                                    Voir mes projets
                                </a>
                                <a href="#contact" class="rounded-2xl border border-blue-200/30 bg-blue-950/45 px-8 py-4 text-base font-bold text-white backdrop-blur-sm transition hover:bg-blue-900/65">
                                    Me contacter
                                </a>
                            </div>

                            <div class="mt-12 flex flex-wrap items-center justify-center gap-3">
                                <button
                                    v-for="(item, dotIndex) in heroSlides"
                                    :key="item.id"
                                    type="button"
                                    @click="goToSlide(dotIndex)"
                                    :class="dotIndex === currentSlide ? 'w-14 bg-yellow-400' : 'w-3 bg-white/45 hover:bg-white/75'"
                                    class="h-3 rounded-full transition-all duration-300"
                                    :aria-label="`Aller au slide ${dotIndex + 1}`"
                                />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div v-else class="relative flex min-h-screen items-center px-6 pt-24 pb-12">
                <div class="absolute inset-0 bg-gradient-to-br from-blue-950 via-blue-900 to-blue-700"></div>
                <div class="relative container mx-auto text-center max-w-4xl">
                    <div class="inline-block mb-6 px-5 py-1.5 bg-yellow-400 text-blue-900 rounded-full text-sm font-bold uppercase tracking-widest shadow">Développeur Web</div>
                    <h1 class="text-6xl md:text-8xl font-black text-white mb-6">
                        Bienvenue sur mon
                        <span class="text-yellow-400"> Portfolio</span>
                    </h1>
                    <p class="text-2xl text-blue-200 mb-10">Développeur Full Stack passionné</p>
                    <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
                        <a href="#projets" class="px-8 py-3 bg-yellow-400 text-blue-900 font-bold rounded-xl hover:bg-yellow-300 transition shadow-lg text-lg">Voir mes projets</a>
                        <a href="#contact" class="px-8 py-3 bg-red-500 text-white font-bold rounded-xl hover:bg-red-600 transition shadow-lg text-lg">Me contacter</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Section À propos -->
        <section id="apropos" class="py-24 px-6 bg-blue-900">
            <div class="container mx-auto max-w-6xl">
                <div class="text-center mb-16">
                    <span class="inline-block px-4 py-1 bg-yellow-400 text-blue-900 rounded-full text-xs font-bold uppercase tracking-widest mb-4">Qui suis-je ?</span>
                    <h2 class="text-5xl font-black text-white">À <span class="text-yellow-400">propos</span></h2>
                    <div class="mt-4 w-16 h-1 bg-red-500 mx-auto rounded-full"></div>
                </div>
                <div v-if="about" class="grid md:grid-cols-2 gap-12 items-center">
                    <div class="space-y-5">
                        <h3 class="text-3xl font-bold text-white">{{ about.title }}</h3>
                        <p v-if="about.subtitle1" class="text-yellow-400 text-xl font-semibold">{{ about.subtitle1 }}</p>
                        <p v-if="about.subtitle2" class="text-blue-200 text-lg">{{ about.subtitle2 }}</p>
                        <p v-if="about.subtitle3" class="text-blue-300">{{ about.subtitle3 }}</p>
                        <a href="#contact" class="inline-block mt-4 px-6 py-2.5 bg-red-500 hover:bg-red-600 text-white font-bold rounded-xl transition shadow-lg">Me contacter</a>
                    </div>
                    <div v-if="about.image" class="relative group">
                        <div class="absolute -inset-2 bg-yellow-400 rounded-2xl opacity-20 group-hover:opacity-40 transition"></div>
                        <img :src="`/storage/${about.image}`" alt="À propos" class="relative rounded-2xl shadow-2xl w-full h-96 object-cover border-4 border-yellow-400/30 group-hover:border-yellow-400 transform group-hover:scale-105 transition duration-500" />
                    </div>
                    <div v-else class="grid grid-cols-2 gap-4">
                        <div class="bg-blue-800 p-6 rounded-xl border-l-4 border-yellow-400">
                            <div class="text-yellow-400 text-3xl mb-2">⚡</div>
                            <h3 class="text-white font-bold">Performance</h3>
                        </div>
                        <div class="bg-blue-800 p-6 rounded-xl border-l-4 border-red-500">
                            <div class="text-red-400 text-3xl mb-2">🎨</div>
                            <h3 class="text-white font-bold">Design</h3>
                        </div>
                        <div class="bg-blue-800 p-6 rounded-xl border-l-4 border-blue-400">
                            <div class="text-blue-300 text-3xl mb-2">🚀</div>
                            <h3 class="text-white font-bold">Innovation</h3>
                        </div>
                        <div class="bg-blue-800 p-6 rounded-xl border-l-4 border-yellow-400">
                            <div class="text-yellow-400 text-3xl mb-2">💡</div>
                            <h3 class="text-white font-bold">Créativité</h3>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Section Compétences -->
        <section id="competences" class="py-24 px-6 bg-blue-950">
            <div class="container mx-auto max-w-6xl">
                <div class="text-center mb-16">
                    <span class="inline-block px-4 py-1 bg-red-500 text-white rounded-full text-xs font-bold uppercase tracking-widest mb-4">Expertise</span>
                    <h2 class="text-5xl font-black text-white">Mes <span class="text-yellow-400">Compétences</span></h2>
                    <div class="mt-4 w-16 h-1 bg-yellow-400 mx-auto rounded-full"></div>
                </div>
                <div v-if="skills && skills.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div
                        v-for="(skill, i) in skills"
                        :key="skill.id"
                        :class="[
                            'group bg-blue-900 p-7 rounded-2xl border-t-4 hover:scale-105 hover:shadow-2xl transition-all duration-300',
                            i % 3 === 0 ? 'border-yellow-400' : i % 3 === 1 ? 'border-red-500' : 'border-blue-400'
                        ]"
                    >
                        <div v-if="skill.image" class="mb-5">
                            <img :src="`/storage/${skill.image}`" :alt="skill.title" class="w-16 h-16 object-contain mx-auto group-hover:scale-110 transition" />
                        </div>
                        <div v-else class="text-5xl mb-5 text-center">⚡</div>
                        <h3 class="text-2xl font-bold text-white mb-1 text-center">{{ skill.title }}</h3>
                        <p v-if="skill.subtitle" class="text-yellow-400 text-center text-sm font-semibold mb-2">{{ skill.subtitle }}</p>
                        <p v-if="skill.description" class="text-blue-300 text-center text-sm">{{ skill.description }}</p>
                    </div>
                </div>
                <div v-else class="text-center text-blue-400">
                    <p>Aucune compétence à afficher pour le moment.</p>
                </div>
            </div>
        </section>

        <!-- Section Projets -->
        <section id="projets" class="py-24 px-6 bg-blue-900">
            <div class="container mx-auto max-w-6xl">
                <div class="text-center mb-16">
                    <span class="inline-block px-4 py-1 bg-yellow-400 text-blue-900 rounded-full text-xs font-bold uppercase tracking-widest mb-4">Réalisations</span>
                    <h2 class="text-5xl font-black text-white">Mes <span class="text-red-400">Projets</span></h2>
                    <div class="mt-4 w-16 h-1 bg-red-500 mx-auto rounded-full"></div>
                </div>
                <div v-if="projects && projects.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div v-for="project in projects" :key="project.id" class="group bg-blue-950 rounded-2xl overflow-hidden border border-blue-700 hover:border-yellow-400 transition-all hover:scale-105 hover:shadow-2xl hover:shadow-yellow-400/10">
                        <div v-if="project.image" class="relative h-48 overflow-hidden">
                            <img :src="`/storage/${project.image}`" :alt="project.name" class="w-full h-full object-cover group-hover:scale-110 transition duration-500" />
                            <div class="absolute inset-0 bg-blue-900/50 group-hover:bg-blue-900/20 transition"></div>
                            <div class="absolute top-3 right-3">
                                <span class="px-2 py-1 bg-yellow-400 text-blue-900 text-xs font-bold rounded-lg">Projet</span>
                            </div>
                        </div>
                        <div class="p-6">
                            <h3 class="text-xl font-bold text-white mb-1">{{ project.name }}</h3>
                            <p v-if="project.public_target" class="text-yellow-400 text-sm font-semibold mb-2">{{ project.public_target }}</p>
                            <p v-if="project.technologies" class="text-blue-400 text-xs mb-3">🛠 {{ project.technologies }}</p>
                            <p class="text-blue-300 text-sm mb-5 line-clamp-3">{{ project.description }}</p>
                            <div class="flex gap-2">
                                <a v-if="project.url" :href="project.url" target="_blank" class="flex-1 px-3 py-2 bg-yellow-400 text-blue-900 font-bold rounded-lg hover:bg-yellow-300 transition text-sm text-center">Voir le site</a>
                                <a v-if="project.github_url" :href="project.github_url" target="_blank" class="flex-1 px-3 py-2 bg-blue-700 text-white font-bold rounded-lg hover:bg-blue-600 transition text-sm text-center">GitHub</a>
                                <button v-if="!project.url && !project.github_url" class="w-full px-3 py-2 bg-red-500 text-white font-bold rounded-lg hover:bg-red-600 transition text-sm">Voir le projet</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-else class="text-center text-blue-400">
                    <p>Aucun projet à afficher pour le moment.</p>
                </div>
            </div>
        </section>

        <!-- Section Contact -->
        <section id="contact" class="py-24 px-6 bg-blue-950">
            <div class="container mx-auto max-w-3xl">
                <div class="text-center mb-12">
                    <span class="inline-block px-4 py-1 bg-red-500 text-white rounded-full text-xs font-bold uppercase tracking-widest mb-4">Travaillons ensemble</span>
                    <h2 class="text-5xl font-black text-white">Contactez-<span class="text-yellow-400">moi</span></h2>
                    <div class="mt-4 w-16 h-1 bg-yellow-400 mx-auto rounded-full"></div>
                </div>
                <div class="bg-blue-900 p-8 rounded-2xl border border-blue-700 shadow-xl">
                    <form @submit.prevent="submitContact" class="space-y-5">
                        <div class="grid md:grid-cols-2 gap-5">
                            <div>
                                <label class="block text-blue-200 mb-2 font-semibold text-sm">Nom <span class="text-red-400">*</span></label>
                                <input v-model="contactForm.name" type="text" required placeholder="Votre nom" class="w-full px-4 py-3 bg-blue-950 border-2 border-blue-700 rounded-xl text-white placeholder-blue-500 focus:outline-none focus:border-yellow-400 transition" />
                            </div>
                            <div>
                                <label class="block text-blue-200 mb-2 font-semibold text-sm">Email <span class="text-red-400">*</span></label>
                                <input v-model="contactForm.email" type="email" required placeholder="votre@email.com" class="w-full px-4 py-3 bg-blue-950 border-2 border-blue-700 rounded-xl text-white placeholder-blue-500 focus:outline-none focus:border-yellow-400 transition" />
                            </div>
                        </div>
                        <div>
                            <label class="block text-blue-200 mb-2 font-semibold text-sm">Sujet</label>
                            <input v-model="contactForm.subject" type="text" placeholder="Objet de votre message" class="w-full px-4 py-3 bg-blue-950 border-2 border-blue-700 rounded-xl text-white placeholder-blue-500 focus:outline-none focus:border-yellow-400 transition" />
                        </div>
                        <div>
                            <label class="block text-blue-200 mb-2 font-semibold text-sm">Message <span class="text-red-400">*</span></label>
                            <textarea v-model="contactForm.message" rows="5" required placeholder="Décrivez votre projet ou votre besoin..." class="w-full px-4 py-3 bg-blue-950 border-2 border-blue-700 rounded-xl text-white placeholder-blue-500 focus:outline-none focus:border-yellow-400 transition resize-y"></textarea>
                        </div>
                        <button type="submit" :disabled="contactForm.processing" class="w-full px-8 py-4 bg-red-500 hover:bg-red-600 disabled:opacity-50 disabled:cursor-not-allowed text-white font-bold rounded-xl transition text-lg shadow-lg hover:shadow-red-500/30">
                            {{ contactForm.processing ? 'Envoi en cours...' : 'Envoyer le message 🚀' }}
                        </button>
                    </form>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="py-10 px-6 bg-blue-900 border-t-4 border-yellow-400">
            <div class="container mx-auto text-center">
                <div class="flex items-center justify-center gap-2 mb-3">
                    <div class="w-8 h-8 bg-yellow-400 rounded-lg flex items-center justify-center shadow">
                        <span class="text-blue-900 font-black text-sm">SDD</span>
                    </div>
                    <span class="text-white font-bold text-lg">SORO DOGNENIN DAVID</span>
                </div>
                <p class="text-blue-300 text-sm">&copy; {{ new Date().getFullYear() }} &mdash; Tous droits réservés.</p>
                <div class="mt-4 flex justify-center gap-4">
                    <a href="#accueil" class="text-blue-400 hover:text-yellow-400 transition text-sm">↑ Retour en haut</a>
                    <span class="text-blue-700">|</span>
                    <a href="#contact" class="text-blue-400 hover:text-red-400 transition text-sm">Contact</a>
                </div>
            </div>
        </footer>
    </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active {
    transition: opacity 0.8s ease;
}
.fade-enter-from, .fade-leave-to {
    opacity: 0;
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.animate-slideUp {
    animation: slideUp 1s ease-out;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

.animate-fadeIn {
    animation: fadeIn 1s ease-in;
}

.slide-fade-enter-active,
.slide-fade-leave-active {
    transition: opacity 0.45s ease, transform 0.45s ease;
}

.slide-fade-enter-from,
.slide-fade-leave-to {
    opacity: 0;
    transform: translateY(24px);
}

.animation-delay-150 {
    animation-delay: 150ms;
}

.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.line-clamp-3 {
    display: -webkit-box;
    -webkit-line-clamp: 3;
    line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

html {
    scroll-behavior: smooth;
}
</style>
