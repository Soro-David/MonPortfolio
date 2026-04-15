<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Skill;
use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;

class SkillController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Admin/Skills/Index', [
            'skills' => Skill::orderBy('order')->get(),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Admin/Skills/Form', [
            'skill' => null,
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'title'       => ['required', 'string', 'max:255'],
            'subtitle'    => ['nullable', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'image'       => ['nullable', 'image', 'max:2048'],
            'order'       => ['nullable', 'integer'],
            'is_active'   => ['boolean'],
        ]);

        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('skills', 'public');
        }

        Skill::create($data);

        return redirect()->route('admin.skills.index')->with('success', 'Compétence créée.');
    }

    public function edit(Skill $skill): Response
    {
        return Inertia::render('Admin/Skills/Form', [
            'skill' => $skill,
        ]);
    }

    public function update(Request $request, Skill $skill): RedirectResponse
    {
        $data = $request->validate([
            'title'       => ['required', 'string', 'max:255'],
            'subtitle'    => ['nullable', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'image'       => ['nullable', 'image', 'max:2048'],
            'order'       => ['nullable', 'integer'],
            'is_active'   => ['boolean'],
        ]);

        if ($request->hasFile('image')) {
            if ($skill->image) {
                Storage::disk('public')->delete($skill->image);
            }
            $data['image'] = $request->file('image')->store('skills', 'public');
        } else {
            unset($data['image']);
        }

        $skill->update($data);

        return redirect()->route('admin.skills.index')->with('success', 'Compétence mise à jour.');
    }

    public function destroy(Skill $skill): RedirectResponse
    {
        if ($skill->image) {
            Storage::disk('public')->delete($skill->image);
        }
        $skill->delete();

        return redirect()->route('admin.skills.index')->with('success', 'Compétence supprimée.');
    }
}
