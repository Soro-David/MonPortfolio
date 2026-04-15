<?php

namespace App\Http\Controllers;

use App\Models\Slider;
use App\Models\About;
use App\Models\Skill;
use App\Models\Project;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class HomeController extends Controller
{
	public function index(): Response
	{
		return Inertia::render('Public/Home', [
			'sliders'  => Slider::where('is_active', true)->orderBy('order')->get(),
			'projects' => Project::where('is_active', true)->orderBy('order')->get(),
			'skills'   => Skill::where('is_active', true)->orderBy('order')->get(),
			'about'    => About::first(),
		]);
	}

	public function contact(Request $request): RedirectResponse
	{
		$request->validate([
			'name'    => ['required', 'string', 'max:255'],
			'email'   => ['required', 'email', 'max:255'],
			'subject' => ['nullable', 'string', 'max:255'],
			'message' => ['required', 'string', 'max:5000'],
		]);

		return back()->with('success', 'Message envoyé avec succès.');
	}
}
