# UnicodeMath

[![Build Status](https://github.com/manuelbb-upb/UnicodeMath.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/manuelbb-upb/UnicodeMath.jl/actions/workflows/CI.yml?query=branch%3Amain)

A small Julia package inspired by the great LaTeX package 
[`unicode-math`](https://ctan.org/pkg/unicode-math?lang=en) that is available under 
[the LaTeX Project Public License 1.3c](https://ctan.org/license/lppl1.3c).

This project is not affiliated to `unicode-math`, the authors of `unicode-math` are 
not responsible for this code, and do not offer support.

# Examples

## Basic Formatting
Use `apply_style` to format a `Char` or an `AbstractString` according to some configuration:
```julia-repl
julia> import UnicodeMath as UCM
julia> src = "BX 𝐵𝑋 ∇ 𝛁 𝜕 𝝏 𝜶𝜷 αβ 𝚪𝚵 𝜵 az 𝑎𝑧 𝛤𝛯 𝛻 ∂ 𝛛 ΓΞ 𝛼𝛽 1 𝜞𝜩 𝛂𝛃"
julia> cfg_tex = UCM.UCMConfig(; math_style_spec=:tex)
julia> UCM.apply_style(src, cfg_tex)
"𝐵𝑋 𝐵𝑋 ∇ 𝛁 𝜕 𝝏 𝜶𝜷 𝛼𝛽 𝚪𝚵 𝛁 𝑎𝑧 𝑎𝑧 ΓΞ ∇ 𝜕 𝝏 ΓΞ 𝛼𝛽 1 𝚪𝚵 𝜶𝜷"
```

The same keyword argument that define `UCMConfig` can be given to apply style directly:
```julia-repl
julia> UCM.apply_style(src; math_style_spec=:iso)
"𝐵𝑋 𝐵𝑋 ∇ 𝛁 𝜕 𝝏 𝜶𝜷 𝛼𝛽 𝜞𝜩 𝛁 𝑎𝑧 𝑎𝑧 𝛤𝛯 ∇ 𝜕 𝝏 𝛤𝛯 𝛼𝛽 1 𝜞𝜩 𝜶𝜷
julia> UCM.apply_style(src; math_style_spec=:upright)
"BX BX ∇ 𝛁 ∂ 𝛛 𝛂𝛃 αβ 𝚪𝚵 𝛁 az az ΓΞ ∇ ∂ 𝛛 ΓΞ αβ 1 𝚪𝚵 𝛂𝛃"
julia> UCM.apply_style(src; math_style_spec=:french)
"BX BX ∇ 𝛁 ∂ 𝛛 𝛂𝛃 αβ 𝚪𝚵 𝛁 𝑎𝑧 𝑎𝑧 ΓΞ ∇ ∂ 𝛛 ΓΞ αβ 1 𝚪𝚵 𝛂𝛃"
```

## Target Style

A target style can be forced. 
```julia-repl
julia> UCM.apply_style(src, :bfup; math_style_spec=:iso)
"𝐁𝐗 𝐁𝐗 𝛁 𝛁 𝛛 𝛛 𝛂𝛃 𝛂𝛃 𝚪𝚵 𝛁 𝐚𝐳 𝐚𝐳 𝚪𝚵 𝛁 𝛛 𝛛 𝚪𝚵 𝛂𝛃 𝟏 𝚪𝚵 𝛂𝛃"
```

The styles `:bf`, `:sf` and `:bfsf` still depend on the configuration:
```julia-repl
julia> UCM.apply_style(src, :bf; math_style_spec=:iso)
"𝑩𝑿 𝑩𝑿 𝛁 𝛁 𝝏 𝝏 𝜶𝜷 𝜶𝜷 𝚪𝚵 𝜵 𝒂𝒛 𝒂𝒛 𝜞𝜩 𝛁 𝝏 𝛛 𝜞𝜩 𝜶𝜷 𝟏 𝜞𝜩 𝛂𝛃"
```
In this example, bold glyphs have not been changed, otherwise bold italic glyphs for latin and greek letters are used.

## Global Commands

The module keeps a reference to a global configuration object.
The function `_sym` works like `apply_style` and uses the global configuration.
By default, `:tex` style is set.
To change the global style, use `global_config!(; kwargs...)`.
For all styles there are also explicit shorthand commands like `symup`, `symit` etc.