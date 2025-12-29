# lang-generator

A Rust procedural macro crate for generating language-related code in poly-translator.

## Overview

`lang-generator` is a procedural macro that automatically generates:
- A comprehensive `Language` enum from ISO 639 language data
- Conversion functions between language codes and enum variants
- Helper methods for language handling

## Features

- **Automatic Enum Generation**: Generates a `Language` enum containing all ISO 639 languages
- **Code Mapping**: Provides conversion functions between language codes and enum variants
- **Bidirectional Conversion**: Supports converting from language codes to enum and from enum back to codes
- **Static Data**: Reads from built-in CSV data for reliable language information

## Usage

Add this to your `Cargo.toml`:

```toml
[dependencies]
lang-generator = "1.0.3"
```

Use the procedural macro in your code:

```rust
use lang_generator::generate_language;

#[generate_language]
pub struct LanguageSupport;

fn main() {
    // Use the generated Language enum
    let lang = Language::English;
    
    // Convert from language code
    let result = Language::from_en("en");
    println!("{:?}", result);
    
    // Convert to language code
    let code = Language::English.to_en();
    println!("{}", code);
}
```

## Generated API

The macro generates the following:

```rust
pub enum Language {
    Chinese,
    English,
    Japanese,
    // ... all ISO 639 languages
}

impl Language {
    pub fn all() -> Vec<Self> { ... }
    
    pub fn from_zh(s: &str) -> Option<Self> { ... }
    pub fn to_zh(&self) -> Option<&'static str> { ... }
    
    pub fn from_en(s: &str) -> Option<Self> { ... }
    pub fn to_en(&self) -> Option<&'static str> { ... }
    
    // ... similar methods for all supported languages
}
```

## Supported Languages

The crate supports all major languages defined in the ISO 639 standard, including:

- Chinese (zh)
- English (en)
- Japanese (ja)
- Korean (ko)
- French (fr)
- German (de)
- Spanish (es)
- Russian (ru)
- And many more...

## License

MIT
