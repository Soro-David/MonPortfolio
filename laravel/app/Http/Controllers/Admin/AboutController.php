<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\About;
use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;

class AboutController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Admin/About/Form', [
            'about' => About::first(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'title'     => ['required', 'string', 'max:255'],
            'subtitle1' => ['nullable', 'string', 'max:255'],
            'subtitle2' => ['nullable', 'string', 'max:255'],
            'subtitle3' => ['nullable', 'string'],
            'image'     => ['nullable', 'image', 'max:2048'],
        ]);

        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('about', 'public');
        }

        $about = About::first();
        if ($about) {
            if ($request->hasFile('image') && $about->image) {
                Storage::disk('public')->delete($about->image);
            }
            $about->update($data);
        } else {
            About::create($data);
        }

        return redirect()->route('admin.about.index')->with('success', 'À propos mis à jour.');
    }
}
