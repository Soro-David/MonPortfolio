<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Project;
use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;

class ProjectController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Admin/Projects/Index', [
            'projects' => Project::orderBy('order')->get(),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Admin/Projects/Form', [
            'project' => null,
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'name'          => ['required', 'string', 'max:255'],
            'public_target' => ['nullable', 'string', 'max:255'],
            'description'   => ['nullable', 'string'],
            'image'         => ['nullable', 'image', 'max:2048'],
            'url'           => ['nullable', 'url', 'max:255'],
            'github_url'    => ['nullable', 'url', 'max:255'],
            'technologies'  => ['nullable', 'string', 'max:255'],
            'order'         => ['nullable', 'integer'],
            'is_active'     => ['boolean'],
        ]);

        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('projects', 'public');
        }

        Project::create($data);

        return redirect()->route('admin.projects.index')->with('success', 'Projet créé.');
    }

    public function edit(Project $project): Response
    {
        return Inertia::render('Admin/Projects/Form', [
            'project' => $project,
        ]);
    }

    public function update(Request $request, Project $project): RedirectResponse
    {
        $data = $request->validate([
            'name'          => ['required', 'string', 'max:255'],
            'public_target' => ['nullable', 'string', 'max:255'],
            'description'   => ['nullable', 'string'],
            'image'         => ['nullable', 'image', 'max:2048'],
            'url'           => ['nullable', 'url', 'max:255'],
            'github_url'    => ['nullable', 'url', 'max:255'],
            'technologies'  => ['nullable', 'string', 'max:255'],
            'order'         => ['nullable', 'integer'],
            'is_active'     => ['boolean'],
        ]);

        if ($request->hasFile('image')) {
            if ($project->image) {
                Storage::disk('public')->delete($project->image);
            }
            $data['image'] = $request->file('image')->store('projects', 'public');
        } else {
            unset($data['image']);
        }

        $project->update($data);

        return redirect()->route('admin.projects.index')->with('success', 'Projet mis à jour.');
    }

    public function destroy(Project $project): RedirectResponse
    {
        if ($project->image) {
            Storage::disk('public')->delete($project->image);
        }
        $project->delete();

        return redirect()->route('admin.projects.index')->with('success', 'Projet supprimé.');
    }
}
