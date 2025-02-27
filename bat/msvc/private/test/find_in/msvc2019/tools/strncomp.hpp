
// --- workspace/scripts/bat/msvc                        [find_in][strncomp.hpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick    
//
//   <-- preliminary/external/protocol                      [util][strncomp.hpp]
//   [2024-01m-25][19:00:00] 001 Idrisov D. R.    
//     --- tools_pain                                             [strncomp.hpp]
//     [2020-12m-30][01:35:01] 001 Idrisov D. R.    
//
//   [2023-06m-01][01:54:31] 002 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//==============================================================================

#pragma once
#ifndef dTOOLS_STRNCOMP_USED_ 
#define dTOOLS_STRNCOMP_USED_ 1

#include <type_traits>
#include <cassert>

namespace tools 
{
    namespace detail_strncmp
    {
        template<class ch>
        int strncmp(const ch* s1, const ch* s2, size_t n) noexcept
        {
            assert(s1);
            assert(s2);

            while (n != 0 && *s1 && (*s1 == *s2))
            {
                ++s1;
                ++s2;
                --n;
            }
            if (n == 0)
                return 0;
            else
            {
                return *s1 - *s2;
                //const auto& r1 = *reinterpret_cast<const unsigned char*>(s1);
                //const auto& r2 = *reinterpret_cast<const unsigned char*>(s2);
                //return r1 - r2;
            }
        }

        constexpr auto offset = 'a' - 'A';

        template<class ch> constexpr ch to_lower(const ch& symbol) noexcept
        {
            return (symbol >= 'A' && symbol <= 'Z') ? 
                static_cast<ch>(symbol + offset) : 
                symbol;
        }

        template<class ch>
        int strncmp_nocase(const ch* s1, const ch* s2, size_t n) noexcept
        {
            assert(s1);
            assert(s2);

            while (n != 0)
            {
                const auto a1 = to_lower(*s1);
                if (a1 == 0)
                    break;

                const auto a2 = to_lower(*s2);
                if (a1 != a2)
                    break;

                ++s1;
                ++s2;
                --n;
            }
            if (n == 0)
                return 0;
            else
            {
                return *s1 - *s2;
                //const auto& r1 = *reinterpret_cast<const unsigned char*>(s1);
                //const auto& r2 = *reinterpret_cast<const unsigned char*>(s2);
                //return r1 - r2;
            }
        }

    } // namespace detail

    // 0 - equal
    template<class s1, class s2> 
    int strncmp(const s1& text1, const s2& text2, const size_t n) noexcept
    {
        const auto* t1 = &text1[0];
        const auto* t2 = &text2[0];
        assert(t1);
        assert(t2);
        return detail_strncmp::strncmp(t1, t2, n);
    }
   
    template<class s1, class s2> 
    int strncmp(const s1& text1, const s2& text2) noexcept
    {
        assert(&text1[0]);
        assert(&text2[0]);
        size_t len = 0;
        while (text2[len] != 0)
            ++len;
        return strncmp(text1, text2, len);
    }

    // 0 - equal
    template<class s1, class s2>
    int strncmp_nocase(const s1& text1, const s2& text2, const size_t n) noexcept
    {
        const auto* t1 = &text1[0];
        const auto* t2 = &text2[0];
        assert(t1);
        assert(t2);
        return detail_strncmp::strncmp_nocase(t1, t2, n);
    }

    template<class s1, class s2>
    int strncmp_nocase(const s1& text1, const s2& text2) noexcept
    {
        assert(&text1[0]);
        assert(&text2[0]);
        size_t len = 0;
        while (text2[len] != 0)
            ++len;
        return strncmp_nocase(text1, text2, len);
    }

} // namespace tools

//==============================================================================
//==============================================================================
#endif // dTOOLS_STRNCOMP_USED_
