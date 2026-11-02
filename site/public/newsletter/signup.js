// Sends any <form class="mailform" data-endpoint="/subscribe"> to the Premium worker and shows its answer as-is,
// including "Email sending isn't set up yet" while that's true.
const WORKER = 'https://tanooki-auth-premium.kirbymail.workers.dev';
document.querySelectorAll('form.mailform').forEach((form) => {
  const out = form.querySelector('output');
  const button = form.querySelector('button');
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    button.disabled = true;
    out.dataset.state = '';
    out.textContent = 'Sending…';
    try {
      const r = await fetch(WORKER + form.dataset.endpoint, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ email: form.querySelector('input[type=email]').value }),
      });
      const b = await r.json().catch(() => ({}));
      out.dataset.state = r.ok ? 'ok' : 'error';
      out.textContent = r.ok ? b.message : b.error || `Something went wrong (error ${r.status}). Please try again later.`;
      if (r.ok) form.reset();
    } catch {
      out.dataset.state = 'error';
      out.textContent = "Couldn't reach the server. Check your internet connection and try again.";
    } finally {
      button.disabled = false;
    }
  });
});
