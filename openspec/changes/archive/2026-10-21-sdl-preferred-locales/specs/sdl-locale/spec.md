## ADDED Requirements

### Requirement: Preferred locales
`sdl.Sdl.getPreferredLocales()` SHALL return the locales SDL reports as the user's preferred ones (`SDL_GetPreferredLocales`), in the user's order of preference, as an `Array<String>`. Each element SHALL be the language code alone (`language`) when SDL gives no country, and `language-COUNTRY` otherwise (BCP 47 form, joined with `-`). When SDL reports no locale or fails, the array SHALL be empty. The list SDL allocates SHALL be released with `SDL_free`.

#### Scenario: Linux with a Russian LANG
- **WHEN** a program on Linux run with `LANG=ru_RU.UTF-8` calls `getPreferredLocales()`
- **THEN** the first element is `ru-RU`

#### Scenario: Language without country
- **WHEN** SDL reports a locale with a language and no country, such as `en`
- **THEN** the element is `en`, with no trailing `-`

#### Scenario: Nothing reported
- **WHEN** SDL reports no preferred locale
- **THEN** `getPreferredLocales()` returns an empty array, not `null`
