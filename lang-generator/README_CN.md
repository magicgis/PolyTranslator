# lang-generator

用于 poly-translator 的 Rust 过程宏 crate，用于生成语言相关代码。

## 概述

`lang-generator` 是一个过程宏，可自动生成：

- 包含所有 ISO 639 语言的完整 `Language` 枚举
- 语言代码与枚举变体之间的转换函数
- 语言处理的辅助方法

## 功能特点

- **自动枚举生成**：从 ISO 639 语言数据生成包含所有语言的 `Language` 枚举
- **代码映射**：提供语言代码与枚举之间的转换函数
- **双向转换**：支持从语言代码转换为枚举，以及从枚举转回代码
- **静态数据**：使用内置 CSV 数据获取可靠的语言信息

## 使用方法

在 `Cargo.toml` 中添加：

```toml
[dependencies]
lang-generator = "1.0.3"
```

在代码中使用过程宏：

```rust
use lang_generator::generate_language;

#[generate_language]
pub struct LanguageSupport;

fn main() {
    // 使用生成的 Language 枚举
    let lang = Language::Chinese;
    
    // 从语言代码转换
    let result = Language::from_zh("zh");
    println!("{:?}", result);
    
    // 转换为语言代码
    let code = Language::Chinese.to_zh();
    println!("{}", code);
}
```

## 生成的 API

宏会生成以下内容：

```rust
pub enum Language {
    Chinese,
    English,
    Japanese,
    // ... 所有 ISO 639 语言
}

impl Language {
    pub fn all() -> Vec<Self> { ... }
    
    pub fn from_zh(s: &str) -> Option<Self> { ... }
    pub fn to_zh(&self) -> Option<&'static str> { ... }
    
    pub fn from_en(s: &str) => Option<Self> { ... }
    pub fn to_en(&self) -> Option<&'static str> { ... }
    
    // ... 所有支持语言的类似方法
}
```

## 支持的语言

该 crate 支持 ISO 639 标准中定义的所有主要语言，包括：

- 中文 (zh)
- 英文 (en)
- 日文 (ja)
- 韩文 (ko)
- 法文 (fr)
- 德文 (de)
- 西班牙文 (es)
- 俄文 (ru)
- 以及更多...

## 许可证

MIT
