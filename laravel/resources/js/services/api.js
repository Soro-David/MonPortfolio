const API_BASE = import.meta.env.VITE_API_BASE_URL || '/api/v1';

export async function getHealth() {
  const res = await fetch(`${API_BASE}/health`, {
    headers: { Accept: 'application/json' },
  });
  if (!res.ok) throw new Error('API health failed');
  return res.json();
}

export async function getProjects() {
  const res = await fetch(`${API_BASE}/projects`, {
    headers: { Accept: 'application/json' },
  });
  if (!res.ok) throw new Error('Projects fetch failed');
  return res.json();
}
