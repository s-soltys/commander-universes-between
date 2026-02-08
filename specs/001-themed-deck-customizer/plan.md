# Implementation Plan: Themed Deck Customizer

**Branch**: `001-themed-deck-customizer` | **Date**: February 8, 2026 | **Spec**: /Users/szymon/commander-universes-between/specs/001-themed-deck-customizer/spec.md
**Input**: Feature specification from `/specs/001-themed-deck-customizer/spec.md`

## Summary

Build a Rails 8+ web app that accepts a commander deck list, a world description, and a commander name, then returns themed card names, art descriptions, and a public share link for the generated deck. Generation uses Scryfall for card metadata and OpenAI APIs for name/description and optional image creation, while respecting Scryfall’s rate limits and required headers.

## Technical Context

**Language/Version**: Ruby (Rails 8+)
**Primary Dependencies**: Rails 8+, Tailwind CSS 4+, OpenAI API, Scryfall API
**Storage**: SQLite
**Testing**: Minitest (Rails default)
**Target Platform**: Web (Linux server)
**Project Type**: web
**Performance Goals**: Generate results for a 100‑card commander deck within 3 minutes end‑to‑end
**Constraints**: No user accounts; all outputs are public; adhere to Scryfall rate limits and header requirements
**Scale/Scope**: MVP for single‑instance deployment; hundreds to low thousands of decks per day

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No enforceable constitution rules are defined in `/Users/szymon/commander-universes-between/.specify/memory/constitution.md` (template placeholders only). Gate passes by default.

## Project Structure

### Documentation (this feature)

```text
specs/001-themed-deck-customizer/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
app/
├── controllers/
├── models/
├── services/
├── views/
└── javascript/

config/

db/

test/
├── models/
├── controllers/
└── integration/
```

**Structure Decision**: Single Rails web application with server‑rendered views and optional JS enhancements.

## Phase 0: Outline & Research

Completed and recorded in:
- `/Users/szymon/commander-universes-between/specs/001-themed-deck-customizer/research.md`

## Phase 1: Design & Contracts

Completed and recorded in:
- `/Users/szymon/commander-universes-between/specs/001-themed-deck-customizer/data-model.md`
- `/Users/szymon/commander-universes-between/specs/001-themed-deck-customizer/contracts/openapi.yaml`
- `/Users/szymon/commander-universes-between/specs/001-themed-deck-customizer/quickstart.md`

## Phase 2: Planning

Ready for `/speckit.tasks` after confirmation.

## Re-check Constitution After Phase 1

No constitution rules to re‑evaluate; no violations.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations.
