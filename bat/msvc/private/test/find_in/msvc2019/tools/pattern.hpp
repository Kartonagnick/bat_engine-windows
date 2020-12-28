
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
//==============================================================================




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

        template<class ch>
        bool match_pattern(const ch* s, const ch* p) noexcept
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

} // namespace tools

//==============================================================================

#endif // !dTOOLS_MATCH_PATTERN_USED_



