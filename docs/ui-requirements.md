# UI Requirements - Knowledge Base Frontend

## Scope & Roles

**Roles:**
- Owner (full access)
- Member (read, comment - Phase 2)
- Viewer (public read - Phase 3)

**MVP:** Owner only; email/password auth

---

## Information Architecture (IA)

### (auth)
- `/login`
- `/signup`
- `/logout`

### (dashboard)
- `/search` (default landing after login)
- `/knowledge/[id]` (detail)
- `/graph` (Phase 4)

### (settings) - Phase 2
- Profile
- Team
- API keys

### System pages
- 404
- 500

---

## Navigation & Layout

### Global Shell
- **Top AppBar:** logo, search input shortcut, theme toggle, user menu
- **Left Sidebar:** filters (collapsed on mobile)

### Breadcrumbs
On knowledge detail: `Search ▸ {collection} ▸ {title}`

### Responsive Breakpoints
- **≥1280px:** 3-column (filters | results | preview panel optional)
- **768–1279px:** 2-column (filters collapsible drawer)
- **<768px:** stacked (floating FAB for filters)

---

## Core Flows (MVP)

1. Log in → land on Search with persisted filters
2. Type query → semantic results list with confidence + badges
3. Refine with filters → live update
4. Open Result → Knowledge Detail (metadata, related, source)
5. (Optional) Open Graph from detail to see relationships (Phase 4)

---

## Search Page (MVP)

### Components

#### SearchBar
**Behaviors:**
- Debounced 250ms
- Enter submits
- Esc clears
- `cmd/ctrl+K` focuses

**Tokens:**
- Supports quoted phrases `"..."`
- Tag syntax: `tag:foo project:bar`

**States:**
- idle
- loading
- results
- empty
- error

#### FilterPanel
**Controls:**
- Project (multi-select, search within list)
- Type (fact | metric | insight)
- Confidence (min slider 0–1 in 0.1 steps)
- Date range (created/updated)
- Has relations (bool)

**Persistence:**
- Per-user via local storage
- Server-sync later

#### ResultList / ResultCard
**Shows:**
- Title
- 2-line snippet (with matched highlights)
- Project chip
- Type badge
- Confidence meter (0–1)
- Last updated
- Relation count

**Actions:**
- Open
- Quick preview (hover/card expand on desktop)
- Copy link

**Performance:**
- Virtualization for lists >50 items

---

## Interactions & UX

### Keyboard Shortcuts
**Global:**
- `cmd/ctrl+k` - focus search

**List:**
- `↑/↓` - navigate
- `Enter` - open
- `p` - quick preview

### Empty State
"No results for 'q'."

**Suggestions:**
- Remove filters
- Broaden date
- Show recent items

### Error State
- Inline alert with retry
- Error ID for support

### Loading State
- Skeleton rows (title line + 2 text lines + chips)

---

## Acceptance Criteria

- Query round trip <400ms p75 (excl. net latency)
- Visible spinner if >200ms
- Typing does not jank (60fps while inputting)
- At least 5k results handled with virtualization without dropped frames on mid laptop

---

## Knowledge Detail Page

### Layout

**Main:**
- Title
- Project chip
- Type
- Last updated
- Confidence

**Content:**
- Markdown rendered (headings, code, tables, links)

**Side Panel:**
- Metadata (ids, tags, created by)
- Numerical facts table
- CRAAP score
- Relations list (depends_on, supports, blocks, conflicts_with)

**Bottom:**
- Related items (semantic "more like this")
- Source links

### States
- Loading skeleton for title/meta/content
- Missing sections hidden with placeholder ("No numerical facts yet")

### Actions
- Copy id / deep link
- Open in Graph (Phase 4)
- Share (Phase 3: public link toggle)

### Acceptance
- Renders 10k-char markdown under 50ms on client (precompute TOC server-side if needed)
- Links open in new tab
- External marked with icon and `rel="noopener"`

---

## Graph Page (Phase 4)

### Graph View

**Library:** react-force-graph (WebGL)

**Node:**
- Title
- Type color
- Confidence ring
- Tooltip with snippet

**Edges:**
- Relationship type label
- Directional arrows

**Interactions:**
- Zoom/pan
- Click to focus
- Right panel with node details
- Search within graph

**Filters:**
- Type
- Confidence
- Depth from selected node

### Acceptance
- Up to 2k nodes / 6k edges p95 stable on modern laptop
- Downsample beyond

---

## Auth (MVP)

- Email/password with inline validation
- Password rules hint
- Show/hide toggle
- Error copy for:
  - "user not found"
  - "wrong password"
  - "rate limited"
- Success → redirect to `/search` and show one-time welcome toast

---

## Components (shadcn/ui)

### SearchBar.tsx
- Input
- Leading icon
- Clear button
- Loading indicator

### FilterPanel.tsx
- Accordions per group
- "Reset all" button

### ResultCard.tsx

```typescript
type ResultCardProps = {
  id: string;
  title: string;
  snippetHtml: string; // pre-highlighted
  project: string;
  type: 'fact'|'metric'|'insight';
  confidence: number; // 0..1
  updatedAt: string; // ISO
  relationCount: number;
  onOpen: (id:string)=>void;
}
```

### GraphView.tsx (Phase 4)

### Base Components
- Badge
- Chip
- Meter
- Skeleton
- Alert
- Drawer
- Tooltip

---

## Design System

**Theme:** light/dark, system default. WCAG AA contrast

**Typography scale:**
- 14/16 base
- h1–h4
- mono for code

**Spacing:** 8px grid

**Iconography:** lucide

**Density:** comfortable (MVP), compact toggle later

---

## Accessibility

- **Keyboard reachable:** all interactive elements tabbable; focus ring visible
- **ARIA:** roles for lists, meters (`aria-valuenow` 0–1), alerts
- **Semantic HTML** for headings in markdown
- **Motion:** reduce motion respects OS; skeletons prefer opacity over transforms

---

## Performance & Reliability

- List virtualization (windowing) after 50 items
- Image/graph lazy loading
- API retries (exponential backoff) for idempotent GETs only
- Error boundaries per route

---

## Telemetry (MVP)

### Events

```javascript
search_submitted {query, filters, resultsCount, durationMs}
result_opened {id, rank, from: 'click'|'keyboard'|'preview'}
filter_changed {name, value}
graph_opened {id} // Phase 4
error_shown {code, surface}
auth_login {method}
```

---

## Content & Copy

**Tone:** neutral, precise, system-like

**Microcopy examples:**
- Empty search: "No results for '{q}'. Try removing filters or broadening your query."
- Filter reset: "Filters cleared."
- Confidence meter label: "Confidence {pct}%"

---

## States Catalogue (Checklist)

**Loading:**
- input
- filters
- list
- detail

**Empty:**
- no query
- no results
- no relations

**Error:**
- network
- server
- auth
- rate limit

**Partial:**
- some blocks missing (numerical facts, CRAAP)

---

## Data Contracts (Frontend ↔ API)

### GET /api/search

**Query params:**
- `q`
- `project[]`
- `type[]`
- `minConfidence`
- `dateFrom`
- `dateTo`
- `limit`
- `cursor`

**Response:**

```json
{
  "results": [
    {
      "id": "uuid",
      "title": "string",
      "snippetHtml": "<mark>...</mark>",
      "project": "string",
      "type": "fact|metric|insight",
      "confidence": 0.82,
      "updatedAt": "2025-10-01T12:34:56Z",
      "relationCount": 3
    }
  ],
  "nextCursor": "string|null",
  "tookMs": 123
}
```

### GET /api/knowledge/:id

```json
{
  "id": "uuid",
  "title": "string",
  "project": "string",
  "type": "fact",
  "contentMd": "string",
  "confidence": 0.82,
  "craap": {
    "currency": 0.9,
    "relevance": 0.8,
    "authority": 0.7,
    "accuracy": 0.85,
    "purpose": 0.6
  },
  "numericalFacts": [
    {"label": "CO2e", "value": 123, "unit": "kg"}
  ],
  "relations": [
    {"type": "depends_on", "id": "uuid", "title": "..."}
  ],
  "updatedAt": "ISO",
  "createdAt": "ISO",
  "tags": ["a", "b"]
}
```

---

## Keyboard Shortcuts (MVP)

**Global:**
- `cmd/ctrl+k` - focus search
- `?` - open shortcuts help

**List:**
- `↑/↓` - navigate
- `Enter` - open
- `Esc` - clear

**Detail:**
- `[` / `]` - previous/next result (if opened from search)

---

## Security/Privacy UI

- Session timeout toast with "Re-login"
- PII safe: no email in URLs; ids only
- Copy-to-clipboard success/fail toasts

---

## i18n (Phase 2)

- Locale switch (EN/ES)
- All strings from a dictionary
- Date/time uses user locale
- Relative time ("Updated 3d ago") with title tooltip absolute

---

## QA Acceptance Checklist (MVP)

- ✅ Search latency p75 < 400ms with warm cache
- ✅ No CLS > 0.1 on route changes
- ✅ Keyboard-only user can execute core flow end-to-end
- ✅ Color contrast AA across themes
- ✅ Virtualized list maintains correct aria semantics
- ✅ Deep links to `/knowledge/[id]` render without prior search

---

## Backlog & Priorities

### Must (MVP)
- Auth (email/pw)
- Search page (query, filters, results)
- Knowledge detail (markdown, metadata, relations list)
- Basic telemetry
- Dark/light theme

### Should (next)
- Related items on detail
- Result quick preview
- Settings: profile
- Team read-only
- Shareable links (internal)

### Could (later)
- Graph view
- Public read mode
- Commenting/annotations
- Saved searches & alerts
- Compact density
