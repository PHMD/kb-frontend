# Design System - Knowledge Base Frontend

## Design Language (At a Glance)

- **Vibe:** calm, system-y, low-chroma; content > chrome
- **Density:** comfortable (MVP) with a "compact" toggle later
- **Contrast:** WCAG AA; clear focus states; low motion by default
- **Color semantics:** status-first (info/success/warn/danger) + confidence meter

---

## Tokens (CSS Variables)

Drop this into `app/globals.css`. Uses HSL so you can theme easily; pairs cleanly with shadcn/ui + Tailwind.

```css
:root {
  /* base */
  --radius-xs: 6px;
  --radius-sm: 10px;
  --radius-md: 14px;

  --shadow-1: 0 1px 2px rgba(0,0,0,.05);
  --shadow-2: 0 2px 8px rgba(0,0,0,.06);
  --shadow-3: 0 8px 24px rgba(0,0,0,.08);

  /* typography */
  --font-sans: ui-sans-serif, Inter, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", "Apple Color Emoji","Segoe UI Emoji";
  --font-mono: ui-monospace, "IBM Plex Mono", SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;

  /* light theme */
  --bg: 0 0% 100%;
  --bg-elev: 0 0% 98%;
  --surface: 220 14% 96%;
  --border: 220 10% 86%;
  --muted: 220 8% 43%;
  --text: 220 13% 15%;

  --primary: 221 83% 53%;   /* blue */
  --primary-fg: 0 0% 100%;

  --info: 206 92% 50%;       /* azure */
  --success: 160 84% 34%;    /* green */
  --warning: 38 92% 50%;     /* amber */
  --danger: 0 72% 51%;       /* red */

  /* components */
  --chip-bg: 220 16% 95%;
  --chip-fg: 220 16% 25%;
  --kbd-bg: 220 14% 94%;
  --kbd-fg: 220 10% 30%;
  --focus: 221 83% 53%;
}

.dark {
  --bg: 220 14% 8%;
  --bg-elev: 220 14% 12%;
  --surface: 220 14% 16%;
  --border: 220 10% 26%;
  --muted: 220 8% 66%;
  --text: 0 0% 98%;

  --primary: 221 83% 60%;
  --primary-fg: 0 0% 100%;

  --chip-bg: 220 14% 20%;
  --chip-fg: 0 0% 96%;
  --kbd-bg: 220 14% 22%;
  --kbd-fg: 0 0% 92%;
}

/* utilities */
body {
  color: hsl(var(--text));
  background: hsl(var(--bg));
  font-family: var(--font-sans);
}

.card {
  background: hsl(var(--bg-elev));
  border: 1px solid hsl(var(--border));
  border-radius: var(--radius-sm);
  box-shadow: var(--shadow-1);
}

.input, .select, .textarea {
  background: hsl(var(--bg));
  border: 1px solid hsl(var(--border));
  border-radius: var(--radius-xs);
}

.input:focus, .select:focus, .textarea:focus, .btn:focus {
  outline: 2px solid hsl(var(--focus));
  outline-offset: 2px;
}

.badge {
  border-radius: 999px;
  padding: 2px 8px;
  font-size: 12px;
  line-height: 18px;
  background: hsl(var(--chip-bg));
  color: hsl(var(--chip-fg));
}

.kbd {
  font-family: var(--font-mono);
  font-size: 11px;
  padding: 2px 6px;
  border-radius: 6px;
  background: hsl(var(--kbd-bg));
  color: hsl(var(--kbd-fg));
  border: 1px solid hsl(var(--border));
}
```

---

## Tailwind Setup

Map Tailwind colors to your CSS variables so shadcn components inherit your theme.

```typescript
// tailwind.config.ts
import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ['class'],
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        bg: "hsl(var(--bg))",
        surface: "hsl(var(--surface))",
        text: "hsl(var(--text))",
        border: "hsl(var(--border))",
        primary: "hsl(var(--primary))",
        "primary-fg": "hsl(var(--primary-fg))",
        info: "hsl(var(--info))",
        success: "hsl(var(--success))",
        warning: "hsl(var(--warning))",
        danger: "hsl(var(--danger))",
      },
      borderRadius: {
        xs: "var(--radius-xs)",
        sm: "var(--radius-sm)",
        md: "var(--radius-md)",
      },
      boxShadow: {
        1: "var(--shadow-1)",
        2: "var(--shadow-2)",
        3: "var(--shadow-3)",
      },
      fontFamily: {
        sans: ["var(--font-sans)"],
        mono: ["var(--font-mono)"],
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
};

export default config;
```

---

## Typography

- **Base:** 15–16px; line-height 1.45 body, 1.25 headings
- **Stack:** Inter (sans), IBM Plex Mono (code/snippets)
- **Scale:**
  - h1: 28/34
  - h2: 22/28
  - h3: 18/24
  - body: 15/22
  - small: 13/18
- **Usage:** keep titles 1 line; truncate with ellipsis in lists; highlight matches with `<mark>` (custom style below)

```css
mark {
  background: color-mix(in oklab, hsl(var(--primary)) 18%, transparent);
  padding: 0 .15em;
  border-radius: 4px;
}
```

---

## Buttons

- **Primary:** filled, blue
- **Secondary:** outline
- **Tertiary:** ghost

```jsx
{/* Primary */}
<button className="btn inline-flex items-center gap-2 rounded-xs px-3.5 py-2
  bg-primary text-primary-fg hover:opacity-90 active:opacity-100 transition">
  Search
</button>

{/* Secondary */}
<button className="btn inline-flex items-center gap-2 rounded-xs px-3.5 py-2
  border border-[color:var(--border)] text-text bg-bg hover:bg-surface transition">
  Reset filters
</button>
```

---

## Inputs (Search & Filters)

Search field: large hit area, subtle shadow, embedded spinner; esc clears.

```jsx
<input
  className="input w-full rounded-sm px-3.5 py-2.5 shadow-1
    placeholder:text-[color:oklch(0.6_0.02_240)]
    focus-visible:outline-none focus:ring-2 focus:ring-[color:hsl(var(--focus))]"
  placeholder="Search knowledge…"
/>
```

---

## Result Card Style

Calm, two-line snippet, metadata chips, confidence meter.

```jsx
<div className="card p-3 hover:shadow-2 transition group cursor-pointer">
  <div className="flex items-start justify-between gap-3">
    <h3 className="text-[15px] font-medium text-text line-clamp-1">
      Fact title with key phrase
    </h3>
    <span className="badge">project-x</span>
  </div>

  <p className="mt-1 text-[13px] text-[color:oklch(0.55_0.03_240)] line-clamp-2"
     dangerouslySetInnerHTML={{__html: snippetHtml}} />

  <div className="mt-2 flex items-center gap-2 text-[12px] text-[color:oklch(0.55_0.03_240)]">
    <span className="badge">fact</span>
    <span>Updated 3d ago</span>
    <span aria-label="relations">• 3 links</span>

    <div className="ml-auto flex items-center gap-1">
      <span className="sr-only">Confidence 82%</span>
      <div className="h-1.5 w-24 rounded-full bg-[hsl(var(--surface))]">
        <div className="h-1.5 rounded-full"
             style={{
               width: "82%",
               background: "linear-gradient(90deg,#22c55e,#f59e0b,#ef4444)"
             }} />
      </div>
    </div>
  </div>
</div>
```

**Note:** The confidence bar goes green→amber→red if showing "risk". If you prefer "trust", flip to red→amber→green.

---

## Chips, Badges, Meters

- **Type badge:** neutral chip (low chroma)
- **Status badge:** colored (info/success/warn/danger) with tinted bg
- **Confidence meter:** use gradient or stepped segments (5)

```css
.badge--success {
  background: color-mix(in oklab, hsl(var(--success)) 15%, transparent);
  color: hsl(var(--success));
}

.badge--warning {
  background: color-mix(in oklab, hsl(var(--warning)) 15%, transparent);
  color: hsl(var(--warning));
}

.badge--danger {
  background: color-mix(in oklab, hsl(var(--danger)) 18%, transparent);
  color: hsl(var(--danger));
}
```

---

## Elevation & Surfaces

- **0:** page bg
- **1:** cards, inputs (--bg-elev, shadow-1)
- **2:** drawers, popovers (shadow-2)
- **3:** modals, toasts (shadow-3, border stronger)

Keep borders visible in dark mode (raise --border lightness).

---

## Motion

- **Durations:** 120ms (buttons), 180ms (lists), 240ms (drawers)
- **Easing:**
  - `cubic-bezier(.2,.8,.2,1)` (standard)
  - `cubic-bezier(.05,.7,.1,1)` (enter)
- **Reduce-motion:** turn scale/slide → opacity/fade

```css
* {
  transition: color .18s, background-color .18s, border-color .18s, box-shadow .18s;
}

@media (prefers-reduced-motion: reduce) {
  * { transition: none !important; }
}
```

---

## Focus & Accessibility

- **Focus ring:** 2px blue ring + 2px offset (already defined)
- **Hit areas:** min 40×40px
- **ARIA:** use `role="meter"` on confidence with `aria-valuenow`, `-min="0"`, `-max="100"`
- **Contrast:** ensure badges meet AA on both themes (tint backgrounds lightly)

---

## Graph Styling (Phase 4)

- **Nodes:** low-chroma fill by type; confidence ring stroke width 2px; label shadow for readability
- **Edges:** neutral 30–40% opacity; on hover active edge to 80%, show arrowheads; relationship labels with tucked pill background
- **Background:** very dark slate in dark, very light in light; avoid pure black/white

---

## Markdown Rendering

- **Headings:** h2 top margin 20px, underline rule subtle
- **Code blocks:** mono, 13px, rounded, subtle border, bg-surface
- **Tables:** zebra strip using surface tint, sticky first column if wide

```css
.prose pre {
  background: hsl(var(--surface));
  border: 1px solid hsl(var(--border));
  border-radius: var(--radius-sm);
  padding: 12px;
}

.prose table tr:nth-child(even) {
  background: color-mix(in oklab, hsl(var(--surface)) 40%, transparent);
}
```

---

## Dark Mode Notes

- Boost text brightness a bit (--text ~98% lightness)
- Keep brand blue slightly brighter (--primary +7% L)
- Avoid fully saturated greens/reds; use tints for backgrounds

---

## Empty, Loading, Error

- **Skeletons:** use bg-surface bars with shimmer at 8% opacity
- **Empty:** icon + one-line guidance + "clear filters" button
- **Error:** bordered alert using status tint

```css
.skeleton {
  background: linear-gradient(90deg, transparent, rgba(255,255,255,.08), transparent);
  animation: shimmer 1.3s infinite;
}

@keyframes shimmer {
  0% { background-position: -200% 0 }
  100% { background-position: 200% 0 }
}
```

---

## Quick Theming Knobs (Brand Switch)

You can rebrand by changing only these five values in `:root`:

```css
/* brand tweak */
--primary: 271 80% 57%; /* purple */
--info:    202 100% 44%;
--success: 156 72% 36%;
--warning: 36 100% 50%;
--danger:  0 82% 55%;
```

---

## Optional: Compact Density Toggle (Later)

Add a class on `<body class="density-compact">` and override paddings/radii by ~20%.

```css
.density-compact .card { border-radius: 8px; }
.density-compact .btn { padding: 6px 10px; }
.density-compact .input { padding: 6px 8px; }
```
