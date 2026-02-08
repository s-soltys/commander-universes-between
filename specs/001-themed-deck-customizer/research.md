# Research: Themed Deck Customizer

## Decision 1: Text generation API choice

**Decision**: Use OpenAI Responses API for themed card names and art descriptions.

**Rationale**: OpenAI positions the Responses API as the recommended direction, with improved capabilities over Chat Completions and a migration path. This supports future-proofing for text generation workloads. citeturn0search6turn0search7

**Alternatives considered**:
- Chat Completions API (supported but not the recommended default for new builds). citeturn0search6turn0search7

## Decision 2: Image generation API choice

**Decision**: Use the OpenAI Image API with `gpt-image-1` for generating card art concepts from the generated art descriptions.

**Rationale**: The Image API supports direct text-to-image generation and explicitly supports `gpt-image-1` as the latest model for image generation. This is a clean fit for single‑prompt image generation per card. citeturn0search2turn0search3

**Alternatives considered**:
- DALL·E 3 via Image API (higher image quality but less flexible for multi‑step editing needs). citeturn0search0
- Image generation via the Responses API tool (good for conversational flows, but not required for single‑prompt generation). citeturn0search2turn0search3

## Decision 3: Scryfall API usage guidelines

**Decision**: Respect Scryfall’s published rate limit guidance and required headers.

**Rationale**: Scryfall asks clients to keep traffic under 10 requests per second and to set explicit `User-Agent` and `Accept` headers to avoid being blocked. citeturn1search0

**Alternatives considered**:
- Bulk data downloads (useful for large‑scale sync, but outside current scope). citeturn1search0
