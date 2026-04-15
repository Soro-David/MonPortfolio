<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Slider;
use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;

class SliderController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Admin/Sliders/Index', [
            'sliders' => Slider::orderBy('order')->get(),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Admin/Sliders/Form', [
            'slider' => null,
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'title'     => ['required', 'string', 'max:255'],
            'slogan'    => ['nullable', 'string', 'max:255'],
            'subtitle'  => ['nullable', 'string', 'max:255'],
            'image'     => ['required', 'image', 'max:2048'],
            'order'     => ['nullable', 'integer'],
            'is_active' => ['boolean'],
        ]);

        $data['image1'] = $request->file('image')->store('sliders', 'public');
        $data['image2'] = null;
        $data['image3'] = null;
        unset($data['image']);

        Slider::create($data);

        return redirect()->route('admin.sliders.index')->with('success', 'Slider créé avec succès.');
    }

    public function edit(Slider $slider): Response
    {
        return Inertia::render('Admin/Sliders/Form', [
            'slider' => $slider,
        ]);
    }

    public function update(Request $request, Slider $slider): RedirectResponse
    {
        $data = $request->validate([
            'title'     => ['required', 'string', 'max:255'],
            'slogan'    => ['nullable', 'string', 'max:255'],
            'subtitle'  => ['nullable', 'string', 'max:255'],
            'image'     => ['nullable', 'image', 'max:2048'],
            'order'     => ['nullable', 'integer'],
            'is_active' => ['boolean'],
        ]);

        if ($request->hasFile('image')) {
            foreach (['image1', 'image2', 'image3'] as $field) {
                if ($slider->$field) {
                    Storage::disk('public')->delete($slider->$field);
                }
            }

            $data['image1'] = $request->file('image')->store('sliders', 'public');
            $data['image2'] = null;
            $data['image3'] = null;
        }

        unset($data['image']);

        $slider->update($data);

        return redirect()->route('admin.sliders.index')->with('success', 'Slider mis à jour.');
    }

    public function destroy(Slider $slider): RedirectResponse
    {
        foreach (['image1', 'image2', 'image3'] as $field) {
            if ($slider->$field) {
                Storage::disk('public')->delete($slider->$field);
            }
        }
        $slider->delete();

        return redirect()->route('admin.sliders.index')->with('success', 'Slider supprimé.');
    }
}
