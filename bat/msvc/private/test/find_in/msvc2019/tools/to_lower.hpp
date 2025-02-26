
// --- workspace/scripts/bat/msvc                        [find_in][to_lower.hpp]
// encode of this source file must be 1251
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick PRE
//   [2023-06m-01][01:54:31] 002 Kartonagnick PRE
//   [2022-08m-05][05:59:37] 001 Kartonagnick PRE

//==============================================================================
//==============================================================================

#pragma once
#ifndef dTOOLS_TO_LOVER_USED_ 
#define dTOOLS_TO_LOVER_USED_ 1

#include <type_traits>
#include <cassert>

//==============================================================================
//==============================================================================
namespace tools 
{
    namespace detail
    {
        #if 0
        static inline int to_lower_symbol_1251(char& r) noexcept
        {
            // encode of this source file must be 1251
            switch (r)
            {
                case 'À': r = 'à'; break;
                case 'Á': r = 'á'; break;
                case 'Â': r = 'â'; break;
                case 'Ã': r = 'ã'; break;
                case 'Ä': r = 'ä'; break;
                case 'Å': r = 'å'; break;
                case 'Æ': r = 'æ'; break;
                case 'Ç': r = 'ç'; break;
                case 'È': r = 'è'; break;
                case 'É': r = 'é'; break;
                case 'Ê': r = 'ê'; break;
                case 'Ë': r = 'ë'; break;
                case 'Ì': r = 'ì'; break;
                case 'Í': r = 'í'; break;
                case 'Î': r = 'î'; break;
                case 'Ï': r = 'ï'; break;
                case 'Ð': r = 'ð'; break;
                case 'Ñ': r = 'ñ'; break;
                case 'Ò': r = 'ò'; break;
                case 'Ó': r = 'ó'; break;
                case 'Ô': r = 'ô'; break;
                case 'Õ': r = 'õ'; break;
                case 'Ö': r = 'ö'; break;
                case '×': r = '÷'; break;
                case 'Ø': r = 'ø'; break;
                case 'Ù': r = 'ù'; break;
                case 'Ú': r = 'ú'; break;
                case 'Û': r = 'û'; break;
                case 'Ü': r = 'ü'; break;
                case 'Ý': r = 'ý'; break;
                case 'Þ': r = 'þ'; break;
                case 'ß': r = 'ÿ'; break;
            }
            return r;
        }
        #endif

        template<class ch> void to_lower(ch* text) noexcept
        { 
            constexpr auto offset_eng = 'a' - 'A';
            constexpr auto offset_rus = 'ÿ' - 'ß';
            assert(text);
            while(*text != 0)
            {
                auto& sym = *text;
                if (sym >= 'A' && sym <= 'Z')
                    sym = sym + offset_eng;
                else if (sym >= 'À' && sym <= 'ß')
                    sym = sym + offset_rus;
                ++text;
            }
        }

        template<class ch>
        bool is_lower(const ch* const text) noexcept
        {
            assert(text);
            for (const auto* p = text; p != 0; ++p)
            {
                auto& symbol = *p;
                if (symbol >= 'A' && symbol <= 'Z')
                    return false;
                if (symbol >= 'À' && symbol <= 'ß')
                    return false;
            }
            return true;
        }

    } // namespace detail

    template<class ch> 
    constexpr ch to_lower_symbol(const ch& symbol) noexcept
    {
        constexpr auto offset_eng = 'a' - 'A';
        constexpr auto offset_rus = 'ÿ' - 'ß';
        if (symbol >= 'A' && symbol <= 'Z')
            return static_cast<ch>(symbol + offset_eng);
        if (symbol >= 'À' && symbol <= 'ß')
            return static_cast<ch>(symbol + offset_rus);
        return symbol;
    }

    template<class s> void to_lower(s& text)
    {
        using x = std::remove_pointer_t<std::remove_reference_t<s>>;
        enum { valid = ! std::is_const<x>::value };
        static_assert(valid, "must be non-const");
        auto* ptr = &text[0];
        tools::detail::to_lower(ptr);
    }

    template<class collect> void to_lower_collection(collect& coll)
    {
        for (auto& text : coll)
            tools::to_lower(text);
    }

    template<class s> bool is_lower(const s& text) noexcept
    {
        const auto* const ptr = &text[0];
        return tools::detail::is_lower(ptr);
    }

} // tools 
//==============================================================================
//==============================================================================
#endif // dTOOLS_TO_LOVER_USED_
