
//================================================================================
//=== to_upper ===================================================================
#ifndef dTOOLS_TO_UPPER_USED_ 
#define dTOOLS_TO_UPPER_USED_ 1
namespace tools
{
    namespace detail
    {
        template<class ch> void to_upper(ch* text) noexcept
        {
            constexpr auto offset = 'A' - 'a';
            assert(text);
            while (*text != 0)
            {
                auto& sym = *text;
                if (sym >= 'a' && sym <= 'z')
                    sym = sym + offset;
                ++text;
            }
        }

        template<class ch>
        bool is_upper(const ch* const text) noexcept
        {
            assert(text);
            for (const auto* p = text; p != 0; ++p)
            {
                auto& sym = *p;
                if (sym >= 'a' && sym <= 'z')
                    return false;
            }
            return true;
        }

    } // namespace detail

    
    template<class ch>
    constexpr ch to_upper_symbol(const ch& symbol) noexcept
    {
        constexpr auto offset = 'A' - 'a';
        if (symbol >= 'a' && symbol <= 'z')
            return static_cast<ch>(symbol + offset);
        return symbol;
    }

    template<class s> void to_upper(s& text)
    {
        using x = ::std::remove_pointer_t<
            ::std::remove_reference_t<s>
        >;
        enum { valid = !::std::is_const<x>::value };
        static_assert(valid, "must be non-const");
        auto* ptr = &text[0];
        ::tools::detail::to_upper(ptr);
    }

    template<class s> bool is_upper(const s& text) noexcept
    {
        const auto* const ptr = &text[0];
        return ::tools::detail::to_upper(ptr);
    }

} // tools
#endif // !dTOOLS_TO_UPPER_USED_

//================================================================================
//================================================================================




#pragma once
#ifndef dTOOLS_TO_LOVER_USED_ 
#define dTOOLS_TO_LOVER_USED_ 1

#include <type_traits>
#include <cassert>
//================================================================================
//================================================================================
namespace tools 
{
    namespace detail
    {
        template<class ch> void to_lower(ch* text) noexcept
        { 
            constexpr auto offset = 'a' - 'A';
            assert(text);
            while(*text != 0)
            {
                auto& sym = *text;
                if(sym >= 'A' && sym <= 'Z')
                    sym = sym + offset; 
                ++text;
            }
        }

    } // namespace detail

    template<class ch> 
    constexpr ch to_lower_symbol(const ch& symbol) noexcept
    {
        constexpr auto offset = 'a' - 'A';
        if (symbol >= 'A' && symbol <= 'Z')
            return static_cast<ch>(symbol + offset);
        return symbol;
    }

    template<class s> void to_lower(s& text)
    {
        using x = ::std::remove_pointer_t< 
            ::std::remove_reference_t<s> 
        >;
        enum { valid = ! ::std::is_const<x>::value };
        static_assert(valid, "must be non-const");
        auto* ptr = &text[0];
        ::tools::detail::to_lower(ptr);
    }

} // tools 
//================================================================================
//================================================================================

#endif // !dTOOLS_TO_LOVER_USED_
