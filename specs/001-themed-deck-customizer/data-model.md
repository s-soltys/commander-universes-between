# Data Model: Themed Deck Customizer

## Entities

### Deck
- **Purpose**: Represents a generated themed commander deck.
- **Fields**:
  - `id` (unique identifier)
  - `title` (optional display title)
  - `commander_name` (user‑provided commander within the theme)
  - `theme_description` (world description)
  - `input_text` (raw deck list input)
  - `share_slug` (public link identifier, unique)
  - `status` (e.g., `complete`, `partial`, `failed`)
  - `created_at`
- **Relationships**:
  - One‑to‑many with `DeckCard`
  - One‑to‑many with `DeckError`

### DeckCard
- **Purpose**: A themed output for a unique original card.
- **Fields**:
  - `id`
  - `deck_id` (FK)
  - `original_name`
  - `quantity`
  - `card_type` (from reference data)
  - `themed_name`
  - `art_description`
  - `image_url` (optional)
- **Relationships**:
  - Many‑to‑one with `Deck`

### DeckError
- **Purpose**: Captures unmatched or invalid input lines.
- **Fields**:
  - `id`
  - `deck_id` (FK)
  - `line_number`
  - `line_text`
  - `error_code` (e.g., `unmatched_card`, `invalid_format`)
  - `message`

### CardReference (derived, not owned)
- **Purpose**: Public reference data used for validation and card type lookup.
- **Fields**:
  - `name`
  - `type_line`
  - `scryfall_id`

## Validation Rules

- `Deck.input_text` must be in “quantity + card name” format, one per line.
- `DeckCard.quantity` must be a positive integer.
- `Deck.share_slug` must be globally unique.
- `DeckCard.original_name` must map to a known card name in reference data to be eligible for theming.

## State Transitions

- `Deck.status`: `pending` → `complete` (all cards matched) or `partial` (some unmatched) or `failed` (no valid matches).
