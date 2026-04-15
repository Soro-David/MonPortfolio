<script setup>
import { ref, computed } from 'vue';
import { Link, usePage } from '@inertiajs/vue3';

const sidebarOpen = ref(true);
const mobileOpen = ref(false);
const page = usePage();

const user = computed(() => page.props.auth.user);
const flash = computed(() => page.props.flash);

const navItems = [
    {
        label: 'Dashboard',
        route: 'admin.dashboard',
        icon: `<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /></svg>`,
    },
    {
        label: 'Sliders',
        route: 'admin.sliders.index',
        icon: `<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>`,
    },
    {
        label: 'À propos',
        route: 'admin.about.index',
        icon: `<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>`,
    },
    {
        label: 'Compétences',
        route: 'admin.skills.index',
        icon: `<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" /></svg>`,
    },
    {
        label: 'Projets',
        route: 'admin.projects.index',
        icon: `<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" /></svg>`,
    },
];

const isActive = (routeName) => {
    try {
        return route().current(routeName);
    } catch {
        return false;
    }
};
</script>

<template>
    <div class="min-h-screen bg-slate-950 flex text-slate-100">

        <!-- Overlay mobile -->
        <div
            v-if="mobileOpen"
            class="fixed inset-0 z-20 bg-black/40 lg:hidden"
            @click="mobileOpen = false"
        ></div>

        <!-- ===== SIDEBAR ===== -->
        <aside
            :class="[
                'fixed inset-y-0 left-0 z-30 flex flex-col bg-slate-900/95 border-r border-slate-800 shadow-xl shadow-slate-950/40 backdrop-blur transition-all duration-300 ease-in-out',
                sidebarOpen ? 'w-64' : 'w-16',
                mobileOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0',
            ]"
        >
            <!-- Logo / En-tête sidebar -->
            <div class="flex items-center h-16 px-4 bg-blue-700 flex-shrink-0">
                <div class="flex items-center gap-3 overflow-hidden">
                    <div class="w-9 h-9 flex-shrink-0 bg-slate-100 rounded-xl flex items-center justify-center shadow">
                        <svg class="w-5 h-5 text-blue-700" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                        </svg>
                    </div>
                    <Transition name="fade-slide">
                        <div v-if="sidebarOpen" class="overflow-hidden">
                            <p class="text-white font-bold text-base leading-tight whitespace-nowrap">Portfolio</p>
                            <p class="text-blue-200 text-xs whitespace-nowrap">Administration</p>
                        </div>
                    </Transition>
                </div>
            </div>

            <!-- Séparateur label -->
            <Transition name="fade-slide">
                <p v-if="sidebarOpen" class="px-4 pt-5 pb-2 text-xs font-semibold text-slate-500 uppercase tracking-widest">Menu</p>
            </Transition>

            <!-- Navigation -->
            <nav class="flex-1 overflow-y-auto overflow-x-hidden px-2 pb-4" :class="sidebarOpen ? '' : 'pt-5'">
                <ul class="space-y-1">
                    <li v-for="item in navItems" :key="item.route">
                        <Link
                            :href="route(item.route)"
                            :class="[
                                'flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200 group relative',
                                isActive(item.route)
                                    ? 'bg-blue-600 text-white shadow-md shadow-blue-950/40'
                                    : 'text-slate-300 hover:text-white hover:bg-slate-800',
                            ]"
                        >
                            <!-- Indicateur actif -->
                            <span
                                v-if="isActive(item.route)"
                                class="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-6 bg-white rounded-r-full"
                            ></span>
                            <span class="flex-shrink-0" v-html="item.icon"></span>
                            <Transition name="fade-slide">
                                <span v-if="sidebarOpen" class="text-sm font-medium whitespace-nowrap">{{ item.label }}</span>
                            </Transition>
                            <!-- Badge tooltip -->
                            <div
                                v-if="!sidebarOpen"
                                class="absolute left-full ml-3 px-3 py-1.5 bg-blue-700 text-white text-xs rounded-lg whitespace-nowrap opacity-0 group-hover:opacity-100 transition pointer-events-none z-50 shadow-lg"
                            >
                                {{ item.label }}
                            </div>
                        </Link>
                    </li>
                </ul>
            </nav>

            <!-- Bas sidebar : voir le site + infos user -->
            <div class="border-t border-slate-800">
                <!-- Voir le site -->
                <div class="px-2 py-2">
                    <a
                        :href="route('home')"
                        target="_blank"
                        class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-slate-300 hover:text-white hover:bg-slate-800 transition group relative"
                    >
                        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                        </svg>
                        <Transition name="fade-slide">
                            <span v-if="sidebarOpen" class="text-sm font-medium whitespace-nowrap">Voir le site</span>
                        </Transition>
                        <div v-if="!sidebarOpen" class="absolute left-full ml-3 px-3 py-1.5 bg-blue-700 text-white text-xs rounded-lg whitespace-nowrap opacity-0 group-hover:opacity-100 transition pointer-events-none z-50 shadow-lg">
                            Voir le site
                        </div>
                    </a>
                </div>
                <!-- User card -->
                <div v-if="sidebarOpen" class="mx-2 mb-3 px-3 py-3 bg-slate-800 rounded-xl flex items-center gap-3 border border-slate-700">
                    <div class="w-9 h-9 rounded-full bg-blue-700 flex items-center justify-center flex-shrink-0 shadow">
                        <span class="text-white text-sm font-bold">{{ user?.name?.charAt(0)?.toUpperCase() }}</span>
                    </div>
                    <div class="min-w-0">
                        <p class="text-slate-100 text-sm font-semibold truncate">{{ user?.name }}</p>
                        <p class="text-blue-300 text-xs truncate">{{ user?.email }}</p>
                    </div>
                </div>
            </div>
        </aside>

        <!-- ===== MAIN CONTENT ===== -->
        <div
            :class="[
                'flex-1 flex flex-col min-h-screen transition-all duration-300',
                sidebarOpen ? 'lg:ml-64' : 'lg:ml-16',
            ]"
        >
            <!-- ===== TOPBAR / NAVBAR ===== -->
            <header class="sticky top-0 z-10 flex items-center h-16 bg-slate-900/90 border-b border-slate-800 shadow-sm px-4 gap-4 backdrop-blur">

                <!-- Bouton toggle sidebar mobile -->
                <button
                    @click="mobileOpen = !mobileOpen"
                    class="p-2 rounded-lg text-slate-300 hover:text-white hover:bg-slate-800 transition lg:hidden"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                </button>
                <!-- Bouton toggle sidebar desktop -->
                <button
                    @click="sidebarOpen = !sidebarOpen"
                    class="hidden lg:flex p-2 rounded-lg text-slate-300 hover:text-white hover:bg-slate-800 transition"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                </button>

                <!-- Titre page -->
                <div class="flex-1">
                    <slot name="header" />
                </div>

                <!-- Actions droite -->
                <div class="flex items-center gap-2">
                    <!-- Bouton voir site -->
                    <a
                        :href="route('home')"
                        target="_blank"
                        class="hidden sm:flex items-center gap-2 px-3 py-1.5 rounded-lg text-sm text-blue-200 font-medium hover:bg-slate-800 border border-slate-700 transition"
                    >
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                        </svg>
                        Voir le site
                    </a>

                    <!-- Séparateur -->
                    <div class="hidden sm:block w-px h-6 bg-slate-700"></div>

                    <!-- Avatar + nom -->
                    <div class="flex items-center gap-2 pl-1">
                        <div class="w-8 h-8 rounded-full bg-blue-700 flex items-center justify-center shadow">
                            <span class="text-white text-sm font-bold">{{ user?.name?.charAt(0)?.toUpperCase() }}</span>
                        </div>
                        <span class="hidden sm:block text-slate-200 text-sm font-medium">{{ user?.name }}</span>
                    </div>

                    <!-- Logout -->
                    <Link
                        :href="route('logout')"
                        method="post"
                        as="button"
                        class="p-2 rounded-lg text-slate-400 hover:text-red-300 hover:bg-red-500/10 transition"
                        title="Déconnexion"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                    </Link>
                </div>
            </header>

            <!-- Flash messages -->
            <div v-if="flash?.success" class="mx-6 mt-5 px-4 py-3 bg-emerald-500/10 border border-emerald-500/30 text-emerald-200 rounded-xl flex items-center gap-2 shadow-sm">
                <svg class="w-5 h-5 flex-shrink-0 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span class="text-sm font-medium">{{ flash.success }}</span>
            </div>
            <div v-if="flash?.error" class="mx-6 mt-5 px-4 py-3 bg-red-500/10 border border-red-500/30 text-red-200 rounded-xl flex items-center gap-2 shadow-sm">
                <svg class="w-5 h-5 flex-shrink-0 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span class="text-sm font-medium">{{ flash.error }}</span>
            </div>

            <!-- Page Content -->
            <main class="flex-1 p-6 bg-gradient-to-br from-slate-950 via-slate-900 to-blue-950/70">
                <slot />
            </main>

            <!-- Footer admin -->
            <footer class="px-6 py-3 bg-slate-900 border-t border-slate-800 text-center">
                <p class="text-xs text-slate-500">Portfolio Admin &mdash; &copy; {{ new Date().getFullYear() }}</p>
            </footer>
        </div>
    </div>
</template>

<style scoped>
.fade-slide-enter-active,
.fade-slide-leave-active {
    transition: opacity 0.2s ease, transform 0.2s ease;
}
.fade-slide-enter-from,
.fade-slide-leave-to {
    opacity: 0;
    transform: translateX(-8px);
}
</style>
