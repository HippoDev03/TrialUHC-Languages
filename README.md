# TrialUHC Languages

This repository stores TrialUHC translation files.

## Files
- `messages.yml`
  - Default language file.
  - This is the source of truth for translation keys.
- `messages_<locale>.yml`
  - Additional language files.
  - Example: `messages_zh_TW.yml`

## Required Metadata
Every language file must start with:

```yml
language-name: "English (US)"
language-code: "en_us"
language-translator: "Your Name"
```

## Naming Rules
- Use `messages_<locale>.yml`
- Keep locale codes consistent, for example:
  - `en_us`
  - `zh_tw`
  - `ja_jp`

## Translation Rules
- Do not remove keys from `messages.yml`
- Keep the YAML structure the same as `messages.yml`
- Keep placeholders unchanged
  - Examples: `<player>`, `<world>`, `<page>`, `<max_page>`
- Keep MiniMessage tags valid
  - Examples: `<red>`, `<bold>`, `<#f4d35e>`
- If a value is intentionally not translated yet, leave the key present and copy the English value for now

## How To Add A New Language
1. Copy `messages.yml`
2. Rename it to `messages_<locale>.yml`
3. Update:
   - `language-name`
   - `language-code`
   - `language-translator`
4. Translate values without changing keys

## How To Update Existing Translations
1. Pull the latest changes from this repository
2. Compare your language file with `messages.yml`
3. Add any missing keys
4. Translate changed English text where needed

## Missing Key Reports
This language repository includes its own GitHub Actions workflow that compares `messages.yml` against all other language files on push and pull request.

It generates markdown reports in:

```text
src/main/resources/languages/missing/
```

Main report:

- [missing/SUMMARY.md](/Users/danielchen0322/Projects/TrialUHC/src/main/resources/languages/missing/SUMMARY.md)

These reports show which keys are missing or blank for each language.

## How To Send A Translation PR
1. Fork the language repository
2. Create a branch
3. Edit or add your `messages_<locale>.yml`
4. Let the `Translation Missing Check` GitHub Action run on your PR
5. Open a pull request

Include in the PR:
- The locale you updated
- Whether it is a new translation or an update
- Anything still untranslated on purpose

## PR Checklist
- File name follows `messages_<locale>.yml`
- Metadata is present
- YAML is valid
- No placeholders were changed or removed
- No keys were deleted
- Missing-key report is clean, or intentionally documented in the PR
