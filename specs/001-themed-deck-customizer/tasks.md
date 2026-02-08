# Tasks: Themed Deck Customizer

**Input**: Design documents from `/specs/001-themed-deck-customizer/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/
**Tests**: Not requested in the feature specification.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Initialize Rails app at repository root (creates `Gemfile`, `config/application.rb`)
- [x] T002 [P] Configure Tailwind CSS integration in `config/tailwind.config.js` and `app/assets/stylesheets/application.tailwind.css`
- [x] T003 [P] Add environment configuration for API keys in `config/credentials.yml.enc` and `config/master.key`
- [x] T004 [P] Add initial routes file with placeholders in `config/routes.rb`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

- [x] T005 Create Deck models and migrations in `app/models/deck.rb` and `db/migrate/XXXXXXXXXXXXXX_create_decks.rb`
- [x] T006 [P] Create DeckCard models and migrations in `app/models/deck_card.rb` and `db/migrate/XXXXXXXXXXXXXX_create_deck_cards.rb`
- [x] T007 [P] Create DeckError models and migrations in `app/models/deck_error.rb` and `db/migrate/XXXXXXXXXXXXXX_create_deck_errors.rb`
- [x] T008 Add validations and associations in `app/models/deck.rb`, `app/models/deck_card.rb`, `app/models/deck_error.rb`
- [x] T009 Create service layer base in `app/services/`
- [x] T010 [P] Add Scryfall client wrapper in `app/services/scryfall_client.rb`
- [x] T011 [P] Add OpenAI client wrapper in `app/services/openai_client.rb`
- [x] T012 Add deck parsing utility in `app/services/deck_list_parser.rb`
- [x] T013 Add generator service orchestration in `app/services/deck_generator.rb`
- [x] T014 Add shared error formatter in `app/services/deck_error_builder.rb`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Generate Themed Commander Deck (Priority: P1) 🎯 MVP

**Goal**: Accept a deck list and theme, generate themed names/art, store results, and expose a public share link.

**Independent Test**: Submit a valid 100-card list with theme and commander; receive themed output for each unique card plus a shareable public link.

### Implementation for User Story 1

- [x] T015 [US1] Implement deck creation controller action in `app/controllers/decks_controller.rb`
- [x] T016 [US1] Implement public deck show action in `app/controllers/decks_controller.rb`
- [x] T017 [US1] Wire POST/GET routes in `config/routes.rb`
- [x] T018 [P] [US1] Build deck submission form view in `app/views/decks/new.html.erb`
- [x] T019 [P] [US1] Build deck results view in `app/views/decks/show.html.erb`
- [x] T020 [US1] Implement share link generation in `app/services/deck_generator.rb`
- [x] T021 [US1] Implement card theming pipeline in `app/services/deck_generator.rb`
- [x] T022 [US1] Persist generated DeckCards in `app/services/deck_generator.rb`
- [x] T023 [US1] Map OpenAPI contract to controller responses in `app/controllers/decks_controller.rb`

**Checkpoint**: User Story 1 should be fully functional and independently testable

---

## Phase 4: User Story 2 - Fix Input Problems (Priority: P2)

**Goal**: Provide clear, line-level feedback for invalid card lines while still returning partial results.

**Independent Test**: Submit a list with invalid lines and confirm results include valid cards plus error list for invalid lines.

### Implementation for User Story 2

- [x] T024 [US2] Implement line-level parse validation in `app/services/deck_list_parser.rb`
- [x] T025 [US2] Populate DeckError records for unmatched lines in `app/services/deck_error_builder.rb`
- [x] T026 [US2] Update generator to mark status `partial` or `failed` in `app/services/deck_generator.rb`
- [x] T027 [US2] Render error list in `app/views/decks/show.html.erb`
- [x] T028 [US2] Return errors in API response payload in `app/controllers/decks_controller.rb`

**Checkpoint**: User Story 2 should be functional and independently testable

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T029 [P] Add basic layout and Tailwind styling in `app/views/layouts/application.html.erb`
- [x] T030 Add performance guardrails for Scryfall rate limit in `app/services/scryfall_client.rb`
- [x] T031 Add OpenAI error handling and retries in `app/services/openai_client.rb`
- [x] T032 Update `specs/001-themed-deck-customizer/quickstart.md` with any final setup details

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
- **Polish (Phase 5)**: Depends on User Stories completion

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational - Builds on US1 data pipeline but remains independently testable

### Parallel Opportunities

- Setup: T002, T003, T004 can run in parallel after T001
- Foundational: T006, T007, T010, T011 can run in parallel after T005
- US1: T018 and T019 can run in parallel after T015
- Polish: T029 can run in parallel with T030 and T031

---

## Parallel Example: User Story 1

```bash
# Views can be built in parallel after controller skeleton exists:
Task: "Build deck submission form view in app/views/decks/new.html.erb"
Task: "Build deck results view in app/views/decks/show.html.erb"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Validate independent test for US1

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. US1 → Test independently → Demo
3. US2 → Test independently → Demo
4. Polish
