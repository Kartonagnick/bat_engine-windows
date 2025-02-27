
// --- workspace/scripts/bat/msvc                         [find_in][pattern.hpp]
// encode of this source file must be 1251
// reconstruct:
//   [2024-02m-09][02:58:33] 004 Kartonagnick    
//   [2023-06m-01][01:54:31] 003 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//==============================================================================

#pragma once

#ifndef dTOOLS_MATCH_PATTERN_USED_ 
#define dTOOLS_MATCH_PATTERN_USED_ 1

#include <type_traits>
#include <cassert>

//==============================================================================
//=== declaration ==============================================================
namespace tools
{
    template<class s1, class s2>
        bool match_pattern(const s1& text, const s2& pattern) noexcept;

} // namespace tools

//==============================================================================
//=== match_pattern(text, pattern) =============================================
namespace tools
{
    namespace match_detail
    {
        #define dMP_POINTER   \
            std::enable_if_t< \
                ::std::is_pointer< ::std::remove_reference_t<s> >::value \
            >* = nullptr

        #define dMP_OTHER     \
            std::enable_if_t< \
                !::std::is_pointer< ::std::remove_reference_t<s> >::value \
            >* = nullptr

        template<class s, dMP_POINTER>
        constexpr auto* c_str(const s& p) noexcept
        {
            assert(p);
            return p;
        }

        template<class s, dMP_OTHER>
        constexpr auto* c_str(const s& v) noexcept
            { return &v[0]; }

        #undef dMP_POINTER
        #undef dMP_OTHER

        template<class ch> bool match_pattern(const ch* s, const ch* p) noexcept
        {
            assert(s);
            assert(p);

            const ch* rs = nullptr;
            const ch* rp = nullptr;

            while (true)
                if (*p == '*')
                    rs = s,
                    rp = ++p;
                else if (!*s)
                    return !*p;
                else if (*s == *p || *p == '?')
                    ++s, 
                    ++p;
                else if (rs)
                    s = ++rs, 
                    p = rp;
                else
                    return false;
        }

        template<class ch>
        constexpr ch up(const ch& symbol) noexcept
        {
            constexpr auto offset_eng = 'a' - 'A';
            constexpr auto offset_rus = 'ÿ' - 'ß';

            if (symbol >= 'a' && symbol <= 'z')
                return static_cast<ch>(symbol - offset_eng);
            if (symbol >= 'à' && symbol <= 'ÿ')
                return static_cast<ch>(symbol - offset_rus);
            return symbol;
        }

        template<class ch> bool match_pattern_insensitive(const ch* s, const ch* p) noexcept
        {
            assert(s);
            assert(p);
            const ch* rs = nullptr;
            const ch* rp = nullptr;
            while (true)
                if (*p == '*')
                    rs = s,
                    rp = ++p;
                else if (!*s)
                    return !*p;
                else if (up(*s) == up(*p) || *p == '?')
                    ++s, 
                    ++p;
                else if (rs)
                    s = ++rs, 
                    p = rp;
                else
                    return false;
        }


    } // namespace match_detail

    template<class s1, class s2>
    bool match_pattern(const s1& text, const s2& pattern) noexcept
    {
        namespace detail = ::tools::match_detail;
        return detail::match_pattern(
            detail::c_str(text), 
            detail::c_str(pattern)
        );
    }

    template<class s1, class s2>
    bool match_pattern_insensitive(const s1& text, const s2& pattern) noexcept
    {
        namespace detail = ::tools::match_detail;
        return detail::match_pattern_insensitive(
            detail::c_str(text), 
            detail::c_str(pattern)
        );
    }

} // namespace tools

//==============================================================================
//==============================================================================

#endif // dTOOLS_MATCH_PATTERN_USED_



