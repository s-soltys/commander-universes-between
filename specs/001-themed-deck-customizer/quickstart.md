# Quickstart: Themed Deck Customizer

## Prerequisites

- Ruby on Rails 8+
- Node.js (for asset pipeline)
- SQLite (default local database)

## Setup

```bash
bundle install
rails db:setup
```

Set API credentials (either environment variables or Rails credentials):

```bash
export OPENAI_API_KEY="..."
export SCRYFALL_USER_AGENT="commander-universes-between/1.0"
```

## Run

```bash
rails server
```

## Basic Usage

1. Open the app in a browser.
2. Paste a deck list in the required format (quantity + card name per line).
3. Enter the theme description and commander name.
4. Submit to generate themed results and receive a public share link.
