import UnicodeMath as UCM
import UnPack: @unpack
using Test

function test_parse_cfg(cfg::UCM.UCMConfig)
    @unpack math_style_spec, normal_style_spec, bold_style_spec, sans_style, partial, nabla = cfg
    return UCM.parse_config(;
        math_style_spec, normal_style_spec, bold_style_spec, sans_style, partial, nabla
    )
end

@testset "Defaults" begin
    @test UCM.UCMConfig() == UCM.UCMConfig(; 
        math_style_spec=:tex, 
        normal_style_spec=nothing,
        bold_style_spec=nothing,
        sans_style=nothing,
        partial=nothing,
        nabla=nothing,
    )

    for normal_style_spec in (nothing, :tex, :iso, :french, :upright, :literal)
    for bold_style_spec in (nothing, :tex, :iso, :upright, :literal)
    for sans_style in (nothing, :upright, :italic, :literal)
    for partial in (nothing, :upright, :italic, :literal)
    for nabla in (nothing, :upright, :italic, :literal)
        overrides = (;normal_style_spec, bold_style_spec, sans_style, partial, nabla)
        cfg_tex = UCM.UCMConfig(; math_style_spec=:tex, overrides...)
        cfg_iso = UCM.UCMConfig(; math_style_spec=:iso, overrides...)
        cfg_french = UCM.UCMConfig(; math_style_spec=:french, overrides...)
        cfg_upright = UCM.UCMConfig(; math_style_spec=:upright, overrides...)
        cfg_literal = UCM.UCMConfig(; math_style_spec=:literal, overrides...)

        ntup_tex = test_parse_cfg(cfg_tex)
        ntup_iso = test_parse_cfg(cfg_iso)
        ntup_french = test_parse_cfg(cfg_french)
        ntup_upright = test_parse_cfg(cfg_upright)
        ntup_literal = test_parse_cfg(cfg_literal)

        ns = if isnothing(normal_style_spec)
            identity
        else
            symb -> normal_style_spec
        end
        bs = if isnothing(bold_style_spec)
            identity
        else
            symb -> bold_style_spec
        end
        ss = if isnothing(sans_style)
            identity
        else
            symb -> sans_style
        end
        p = if isnothing(partial)
            identity
        else
            symb -> partial
        end
        n = if isnothing(nabla)
            identity
        else
            symb -> nabla
        end
        @test ntup_tex == (;
            nabla = n(:upright),
            partial = p(:italic),
            normal_style_spec = ns(:tex),
            bold_style_spec = bs(:tex),
            sans_style = ss(:upright)
        )

        @test ntup_iso == (;
            nabla = n(:upright),
            partial = p(:italic),
            normal_style_spec = ns(:iso),
            bold_style_spec = bs(:iso),
            sans_style = ss(:italic)
        )

        @test ntup_french == (;
            nabla = n(:upright),
            partial = p(:upright),
            normal_style_spec = ns(:french),
            bold_style_spec = bs(:upright),
            sans_style = ss(:upright)
        )

        @test ntup_upright == (;
            nabla = n(:upright),
            partial = p(:upright),
            normal_style_spec = ns(:upright),
            bold_style_spec = bs(:upright),
            sans_style = ss(:upright)
        )

        @test ntup_literal == (;
            nabla = n(:literal),
            partial = p(:literal),
            normal_style_spec = ns(:literal),
            bold_style_spec = bs(:literal),
            sans_style = ss(:literal)
        )
    end
    end
    end
    end
    end

    @test UCM.parse_normal_style_spec(:iso) == (;
        Greek = :italic,
        greek = :italic,
        Latin = :italic,
        latin = :italic
    )
    @test UCM.parse_normal_style_spec(:tex) == (;
        Greek = :upright,
        greek = :italic,
        Latin = :italic,
        latin = :italic
    )
    @test UCM.parse_normal_style_spec(:french) == (;
        Greek = :upright,
        greek = :upright,
        Latin = :upright,
        latin = :italic
    )
    @test UCM.parse_normal_style_spec(:upright) == (;
        Greek = :upright,
        greek = :upright,
        Latin = :upright,
        latin = :upright,
    )
    @test UCM.parse_normal_style_spec(:literal) == (;
        Greek = :literal,
        greek = :literal,
        Latin = :literal,
        latin = :literal,
    )

    @test UCM.parse_bold_style_spec(:iso) == (;
        Greek = :italic,
        greek = :italic,
        Latin = :italic,
        latin = :italic
    )
    @test UCM.parse_bold_style_spec(:tex) == (;
        Greek = :upright,
        greek = :italic,
        Latin = :upright,
        latin = :upright
    )
    @test UCM.parse_bold_style_spec(:upright) == (;
        Greek = :upright,
        greek = :upright,
        Latin = :upright,
        latin = :upright,
    )
    @test UCM.parse_bold_style_spec(:literal) == (;
        Greek = :literal,
        greek = :literal,
        Latin = :literal,
        latin = :literal,
    )
end

#@testset "String Styling with `math_style_spec`" begin
begin
    test_strings = Dict(
        :num_up => "1",
        :latin_up => "az",
        :Latin_up => "BX",
        :latin_it => "𝑎𝑧",
        :Latin_it => "𝐵𝑋",
        :greek_up => "αβ",
        :Greek_up => "ΓΞ",
        :greek_it => "𝛼𝛽",
        :Greek_it => "𝛤𝛯",
        :greek_bfit => "𝜶𝜷",
        :Greek_bfit => "𝜞𝜩",
        :greek_bfup => "𝛂𝛃",
        :Greek_bfup => "𝚪𝚵",
        :Nabla_up => "∇",
        :Nabla_it => "𝛻",
        :Nabla_bfup => "𝛁",
        :Nabla_bfit => "𝜵",
        :partial_up => "∂",
        :partial_it => "𝜕",
        :partial_bfup => "𝛛",
        :partial_bfit => "𝝏",
    )

    results_tex = Dict(
        :num_up => :num_up,
        :latin_up => :latin_it,
        :Latin_up => :Latin_it,
        :latin_it => :latin_it,
        :Latin_it => :Latin_it,
        :greek_up => :greek_it,
        :Greek_up => :Greek_up,
        :greek_it => :greek_it,
        :Greek_it => :Greek_up,
        :greek_bfit => :greek_bfit,
        :Greek_bfit => :Greek_bfup,
        :greek_bfup => :greek_bfit,
        :Greek_bfup => :Greek_bfup,
        :Nabla_up => :Nabla_up,
        :Nabla_it => :Nabla_up,
        :Nabla_bfup => :Nabla_bfup,
        :Nabla_bfit => :Nabla_bfup,
        :partial_up => :partial_it,
        :partial_it => :partial_it,
        :partial_bfup => :partial_bfit,
        :partial_bfit => :partial_bfit,
    )

    results_iso = Dict(
        :num_up => :num_up,
        :latin_up => :latin_it,
        :Latin_up => :Latin_it,
        :latin_it => :latin_it,
        :Latin_it => :Latin_it,
        :greek_up => :greek_it,
        :Greek_up => :Greek_it,
        :greek_it => :greek_it,
        :Greek_it => :Greek_it,
        :greek_bfit => :greek_bfit,
        :Greek_bfit => :Greek_bfit,
        :greek_bfup => :greek_bfit,
        :Greek_bfup => :Greek_bfit,
        :Nabla_up => :Nabla_up,
        :Nabla_it => :Nabla_up,
        :Nabla_bfup => :Nabla_bfup,
        :Nabla_bfit => :Nabla_bfup,
        :partial_up => :partial_it,
        :partial_it => :partial_it,
        :partial_bfup => :partial_bfit,
        :partial_bfit => :partial_bfit,
    )

    results_upright = Dict(
        :num_up => :num_up,
        :latin_up => :latin_up,
        :Latin_up => :Latin_up,
        :latin_it => :latin_up,
        :Latin_it => :Latin_up,
        :greek_up => :greek_up,
        :Greek_up => :Greek_up,
        :greek_it => :greek_up,
        :Greek_it => :Greek_up,
        :greek_bfit => :greek_bfup,
        :Greek_bfit => :Greek_bfup,
        :greek_bfup => :greek_bfup,
        :Greek_bfup => :Greek_bfup,
        :Nabla_up => :Nabla_up,
        :Nabla_it => :Nabla_up,
        :Nabla_bfup => :Nabla_bfup,
        :Nabla_bfit => :Nabla_bfup,
        :partial_up => :partial_up,
        :partial_it => :partial_up,
        :partial_bfup => :partial_bfup,
        :partial_bfit => :partial_bfup,
    )

    results_french = Dict(
        :num_up => :num_up,
        :latin_up => :latin_it,
        :Latin_up => :Latin_up,
        :latin_it => :latin_it,
        :Latin_it => :Latin_up,
        :greek_up => :greek_up,
        :Greek_up => :Greek_up,
        :greek_it => :greek_up,
        :Greek_it => :Greek_up,
        :greek_bfit => :greek_bfup,
        :Greek_bfit => :Greek_bfup,
        :greek_bfup => :greek_bfup,
        :Greek_bfup => :Greek_bfup,
        :Nabla_up => :Nabla_up,
        :Nabla_it => :Nabla_up,
        :Nabla_bfup => :Nabla_bfup,
        :Nabla_bfit => :Nabla_bfup,
        :partial_up => :partial_up,
        :partial_it => :partial_up,
        :partial_bfup => :partial_bfup,
        :partial_bfit => :partial_bfup,
    )

    results_literal = Dict(k => k for k = keys(test_strings))
    cfg_tex = UCM.UCMConfig(; math_style_spec=:tex)
    cfg_iso = UCM.UCMConfig(; math_style_spec=:iso)
    cfg_upright = UCM.UCMConfig(; math_style_spec=:iso)
    cfg_french = UCM.UCMConfig(; math_style_spec=:french)
    cfg_literal = UCM.UCMConfig(; math_style_spec=:literal)
    for (cfg, res) = (
        (cfg_iso, results_iso), 
        (cfg_tex, results_tex), 
        (cfg_upright, results_upright),
        (cfg_french, results_french),
        (cfg_literal, results_literal)
    )
        for (k, _str) = pairs(test_strings)
            _styled = test_strings[results_iso[k]]
            @test UCM.apply_style(_str, cfg_iso) == _styled
        end
    end

end