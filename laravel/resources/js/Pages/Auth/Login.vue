<script setup>
import Checkbox from '@/Components/Checkbox.vue';
import GuestLayout from '@/Layouts/GuestLayout.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

defineProps({
    canResetPassword: {
        type: Boolean,
    },
    status: {
        type: String,
    },
});

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
    });
};
</script>

<template>
    <GuestLayout>
        <Head title="Connexion" />

        <div class="rounded-[2rem] border border-white/10 bg-white/10 p-7 shadow-2xl shadow-slate-950/20 backdrop-blur-md sm:p-8">
            <div class="mb-8 space-y-3">
                <p class="text-sm font-medium uppercase tracking-[0.35em] text-cyan-200/80">
                    Bon retour
                </p>
                <div>
                    <h2 class="text-3xl font-semibold text-white">Connexion</h2>
                    <p class="mt-2 text-sm leading-6 text-slate-300">
                        Accédez à votre tableau de bord pour gérer votre portfolio et vos contenus.
                    </p>
                </div>
            </div>

            <div
                v-if="status"
                class="mb-6 rounded-2xl border border-emerald-400/30 bg-emerald-400/10 px-4 py-3 text-sm font-medium text-emerald-200"
            >
                {{ status }}
            </div>

            <form class="space-y-6" @submit.prevent="submit">
                <div>
                    <InputLabel
                        for="email"
                        value="Adresse email"
                        class="mb-2 block text-sm font-medium text-slate-200"
                    />

                    <TextInput
                        id="email"
                        v-model="form.email"
                        type="email"
                        class="block w-full rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-3 text-white placeholder:text-slate-500 focus:border-cyan-400 focus:ring-cyan-400"
                        required
                        autofocus
                        autocomplete="username"
                        placeholder="admin@sddavid.com"
                    />

                    <InputError
                        class="mt-2 text-sm text-rose-300"
                        :message="form.errors.email"
                    />
                </div>

                <div>
                    <div class="mb-2 flex items-center justify-between gap-3">
                        <InputLabel
                            for="password"
                            value="Mot de passe"
                            class="block text-sm font-medium text-slate-200"
                        />
                        <Link
                            v-if="canResetPassword"
                            :href="route('password.request')"
                            class="text-sm font-medium text-cyan-200 transition hover:text-cyan-100 focus:outline-none focus:ring-2 focus:ring-cyan-400 focus:ring-offset-0"
                        >
                            Mot de passe oublié ?
                        </Link>
                    </div>

                    <TextInput
                        id="password"
                        v-model="form.password"
                        type="password"
                        class="block w-full rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-3 text-white placeholder:text-slate-500 focus:border-cyan-400 focus:ring-cyan-400"
                        required
                        autocomplete="current-password"
                        placeholder="••••••••••••"
                    />

                    <InputError
                        class="mt-2 text-sm text-rose-300"
                        :message="form.errors.password"
                    />
                </div>

                <label
                    class="flex items-center justify-between gap-4 rounded-2xl border border-white/10 bg-slate-900/40 px-4 py-3"
                >
                    <div class="flex items-center gap-3">
                        <Checkbox
                            name="remember"
                            v-model:checked="form.remember"
                            class="rounded border-white/20 bg-slate-950/30 text-cyan-400 focus:ring-cyan-400"
                        />
                        <span class="text-sm text-slate-300">Se souvenir de moi</span>
                    </div>
                    <span class="text-xs uppercase tracking-[0.25em] text-slate-500">Sécurisé</span>
                </label>

                <PrimaryButton
                    class="flex w-full items-center justify-center rounded-2xl bg-gradient-to-r from-cyan-400 via-sky-500 to-indigo-500 px-5 py-4 text-sm font-semibold uppercase tracking-[0.3em] text-slate-950 shadow-lg shadow-cyan-900/30 transition hover:scale-[1.01] hover:from-cyan-300 hover:to-indigo-400 focus:bg-none focus:ring-cyan-300 active:scale-[0.99]"
                    :class="{ 'cursor-not-allowed opacity-60': form.processing }"
                    :disabled="form.processing"
                >
                    {{ form.processing ? 'Connexion...' : 'Se connecter' }}
                </PrimaryButton>
            </form>
        </div>
    </GuestLayout>
</template>
