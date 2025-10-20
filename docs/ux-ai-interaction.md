# UX & AI Interaction Design - Knowledge Base Frontend

This document defines the user experience (UX) and AI interaction design (AIX) for the knowledge base app. It bridges the UI layer and the product's real differentiator: **intelligent, conversational, insight-driven knowledge access**.

---

## 1. Overall UX Strategy

Your users aren't just "searching"; they're **exploring, validating, and connecting** knowledge. The UX should make those three modes seamless.

### Core Mental Model

**"This tool helps me find, trust, and connect facts."**

Interface flows are shaped around:

1. **Find** — fast, intuitive semantic search
2. **Trust** — visible context, CRAAP metrics, confidence, and provenance
3. **Connect** — show relationships (dependencies, conflicts, supports) when relevant

---

## 2. UX Pillars

| Pillar | Goal | Key UX Principles |
|--------|------|-------------------|
| **Clarity** | User knows what each element means | Minimal chrome, plain language, tooltips on metrics |
| **Momentum** | Search → browse → detail feels fluid | Instant feedback, keyboard shortcuts, inline previews |
| **Trust** | User believes results are credible | CRAAP scores visible, data source transparency, versioning |
| **Cognition** | Help users synthesize | Summaries, compare view, related insights |
| **Explorability** | Support "what if?" reasoning | Graph navigation, semantic expansions ("show related facts") |

---

## 3. Search UX

### Flow

1. User types → instant fuzzy preview (2–3 top results)
2. Press enter → full results + filters visible
3. Results show both **semantic relevance** and **confidence of fact** (two separate concepts)
4. Hover/keyboard navigate → preview panel (markdown snippet + CRAAP mini-summary)
5. Open → full detail view

### Microinteractions

- **Debounced live search** (200–300 ms)
- **Highlighted phrases** where embeddings matched (soft-marked, not bright yellow)
- **Query suggestions:** "Did you mean: X?" or "Similar concepts: Y, Z."
- **Empty state:** "No results — try rephrasing or broaden filters."

### AI Assist Hook

Beneath the search bar, a subtle hint:

> 💡 "Ask a question instead of keywords — I'll interpret it semantically."

---

## 4. Knowledge Detail UX

### Layout

**Header:**
- Title + project chip + type + confidence bar

**Summary Zone (AI-generated):**
- 1–2 sentences: "This fact summarizes …"
- "Based on X sources (link)"

**Content Zone:**
- Rendered markdown

**CRAAP Accordion:**
- Show breakdown
- Hover tooltips explain each metric

**Relations Panel:**
- Linked facts grouped by relationship type

**AI Sidebar (Phase 2):**
- "Explain this"
- "Summarize for me"
- "Compare with related"

### Navigation Aids

- **Previous/next arrows** (keyboard: `[` and `]`)
- **"Back to results"** preserves filters & scroll position
- **Persistent context:** query shown in header to remind why the user is here

---

## 5. AI Interaction Design (AIX)

### Principle

The AI is not a chatbot stuck in a corner — it's an **ambient layer** that enhances search, validation, and reasoning.

Design every interaction so AI feels **assistive, not intrusive**.

---

## 6. Modes of AI Interaction

| Mode | Description | UI Surface | Example |
|------|-------------|------------|---------|
| **Semantic search** | Core embedding-based retrieval | Search bar | "show me data about soil nitrogen variance" |
| **Query reformulation** | AI refines user input | Inline hint below search | "interpreting as: nitrogen variability across crops" |
| **Summarization** | Turns fact content into short plain summary | Top of knowledge detail | "This finding suggests…" |
| **Comparison / synthesis** | Combine multiple facts | Multi-select toolbar | "Compare selected" → AI creates contrast summary |
| **Relationship reasoning** | Graph queries turned into natural answers | Graph view | "What supports this?" → highlights connected nodes |
| **Explanation / validation** | Explain CRAAP or confidence | Tooltip or modal | "Confidence 0.78 because 3 of 4 sources agree" |
| **Conversational layer** (Phase 3) | Ask follow-up in natural language | Floating "Ask" composer | "What else affects this metric?" |

---

## 7. Conversational Microflow (Phase 3 Concept)

**User types:** "Why does project X have lower yield confidence?"

**AI responds inline:**

> "Because 2 supporting studies conflict on fertilizer dosage. Want to see them?" [View Facts]
>
> (click → opens detail with both sources side by side)

### UI Shape

- **Input bar pinned bottom-right** ("Ask about current context")
- When user is on `/knowledge/[id]`, AI has context of that fact
- Messages appear as stacked bubbles or collapsible drawer; **no full-screen chat** (preserve context)

---

## 8. Tone & Personality

| Trait | Guideline |
|-------|-----------|
| **Neutral-expert** | Speaks like a research assistant, not a cheerleader |
| **Transparent** | Always shows where answers come from |
| **Concise** | ≤ 3 sentences per reply |
| **Explains confidence** | "I'm 80% sure based on 4 of 5 matching facts." |
| **Adaptive** | Reuses user terminology (project names, domains) |

### Sample Prompt Tone

> "Based on our validated data, the likely reason is … (Confidence 0.78). Here are related insights →"

---

## 9. Trust & Transparency

UX patterns to reinforce reliability:

- **Source chips** under AI responses (click → open fact)
- **Confidence meter** per AI statement (visually echoes CRAAP bar)
- **Toggle raw reasoning** (show SQL/embedding query or citations)
- **Version timestamps** ("Answer generated 2 min ago")

---

## 10. Keyboard and Power-User UX

| Shortcut | Action |
|----------|--------|
| `/` | Focus search |
| `↑` / `↓` | Navigate results |
| `Enter` | Open |
| `Cmd/Ctrl + K` | **AI command palette:** |
| | - "Summarize current view" |
| | - "Show related facts" |
| | - "Explain CRAAP score" |
| `Cmd/Ctrl + Shift + G` | Open graph view |

---

## 11. Feedback & Learning Loop

- **Thumbs up/down** on AI responses (stores in Supabase feedback table)
- **Hover hint:** "Was this answer useful?"
- AI learns preferred phrasing / domains
- Periodic **"Insights you might like"** card powered by usage embeddings

---

## 12. Implementation Notes

- Keep AI interactions **stateless** initially (each query = one API call)
- Later introduce context window using Supabase session memory
- Maintain all AI events (query, response, rating) in an `ai_interactions` table
- **Architecture:** `/api/ai/query` → orchestrates OpenAI + Supabase search

---

## 13. Onboarding UX (First Use)

1. **Empty state** explains the three modes: Search – Trust – Connect
2. **Guided demo:** overlay walks user through typing a natural question
3. **Demo data:** include 3–4 curated facts for safe exploration
4. **Hint cards** rotate suggestions ("Try: What supports fact X?")

---

## 14. Key UX Metrics

| Metric | Target |
|--------|--------|
| Search → open detail conversion | > 50% |
| Avg time to first insight | < 10s |
| AI helpfulness rating | > 4/5 |
| Session depth | ≥ 3 views per session |
| User trust (survey) | > 70% report "confident in results" |

---

## 15. Summary Cheat-Sheet

- ✅ **UX theme:** calm, credible, exploratory
- ✅ **AI role:** research copilot (transparent, contextual, concise)
- ✅ **Design pattern:** ambient AI + semantic navigation
- ✅ **Interaction flow:** Search → Preview → Detail → Ask → Connect
- ✅ **Outcome:** user feels like they're discovering verified insight, not chatting with a bot

---

## Appendix: User Journey Storyboard

### Journey 1: New User Explores

1. **Login** → lands on `/search` with hint: "Try asking a question"
2. **Types:** "What affects crop yield in project X?"
3. **See:** 5 results, confidence bars, project chips
4. **Clicks:** top result
5. **Detail view:** markdown content, CRAAP accordion, relations panel
6. **Clicks:** "depends_on: soil_nitrogen_variance"
7. **New detail:** reads related fact, sees connection
8. **Clicks:** "Open in Graph" (Phase 4)
9. **Graph view:** visualizes dependency chain
10. **Insight:** "Ah, yield depends on nitrogen, which depends on fertilizer timing"

### Journey 2: Power User Validates Data

1. **Lands on search** with persisted filters (project: kicker, confidence: >0.8)
2. **Types:** "revenue projections"
3. **Quick preview** (hover) shows snippet + CRAAP mini-summary
4. **Opens detail**
5. **Expands CRAAP accordion** to see source breakdown
6. **Clicks source link** to verify primary source
7. **Returns to search** (preserves scroll position)
8. **Compares** with related fact using multi-select (Phase 2)
9. **AI synthesis:** "Both facts agree on X, but differ on Y"

### Journey 3: AI-Assisted Research (Phase 3)

1. **On knowledge detail page**
2. **Clicks floating "Ask" button**
3. **Types:** "What else supports this conclusion?"
4. **AI responds:** "3 facts support this: [fact A], [fact B], [fact C]. Confidence 0.85."
5. **Clicks** [fact A] chip → opens in new detail view
6. **Navigates** between related facts using keyboard `[` / `]`
7. **Finds** validation for research question
