<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::updateOrCreate(
            [ 'email' => 'admin@sddavid.com' ],
            [
                'name' => 'Admin',
                'email' => 'admin@sddavid.com',
                'password' => Hash::make('Password1234'),
                'email_verified_at' => now(),
            ]
        );
    }
}
