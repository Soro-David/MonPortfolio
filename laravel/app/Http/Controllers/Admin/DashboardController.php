<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Slider;
use App\Models\About;
use App\Models\Skill;
use App\Models\Project;
use Inertia\Inertia;
use Inertia\Response;

class DashboardController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Admin/Dashboard', [
            'stats' => [
                'sliders' => Slider::count(),
                'abouts'  => About::count(),
                'skills'  => Skill::count(),
                'projects'=> Project::count(),
            ],
        ]);
    }
}
