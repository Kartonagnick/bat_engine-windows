
#pragma once
#ifndef dTOOLS_TO_LOVER_USED_ 
#define dTOOLS_TO_LOVER_USED_ 1

#include <type_traits>
#include <cassert>
//================================================================================
//================================================================================
namespace tools 
{
    namespace detail_strncmp
    {
        template<class ch>
        int strncmp(const ch* s1, const ch* s2, size_t n) noexcept
        {
            while (n && *s1 && (*s1 == *s2))
            {
                ++s1;
                ++s2;
                --n;
            }
            if (n == 0)
                return 0;
            else
            {
                const auto& r1 = *reinterpret_cast<const unsigned char*>(s1);
                const auto& r2 = *reinterpret_cast<const unsigned char*>(s2);
                return r1 - r2;
            }
        }

        template<class ch> constexpr ch to_lower(const ch& symbol) noexcept
        {
            constexpr auto offset = 'a' - 'A';
            if (symbol >= 'A' && symbol <= 'Z')
                return static_cast<ch>(symbol + offset);
            return symbol;
        }


        template<class ch>
        int strncmp_nocase(const ch* s1, const ch* s2, size_t n) noexcept
        {
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
                const auto& r1 = *reinterpret_cast<const unsigned char*>(s1);
                const auto& r2 = *reinterpret_cast<const unsigned char*>(s2);
                return r1 - r2;
            }
        }


    } // namespace detail

    // 0 - equal
    template<class s1, class s2> 
    int strncmp(const s1& text1, const s2& text2, const size_t n) noexcept
    {
        const auto* t1 = &text1[0];
        const auto* t2 = &text2[0];
        return detail_strncmp::strncmp(t1, t2, n);
    }

    // 0 - equal
    template<class s1, class s2>
    int strncmp_nocase(const s1& text1, const s2& text2, const size_t n) noexcept
    {
        const auto* t1 = &text1[0];
        const auto* t2 = &text2[0];
        return detail_strncmp::strncmp_nocase(t1, t2, n);
    }


} // tools
//================================================================================
//================================================================================

#endif // !dTOOLS_TO_LOVER_USED_
