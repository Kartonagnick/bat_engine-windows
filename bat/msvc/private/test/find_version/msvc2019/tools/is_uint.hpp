
#pragma once
#ifndef dTOOLS_IS_UINT_USED_
#define dTOOLS_IS_UINT_USED_ 1

#include <cassert>
#include <string>

//==============================================================================
//==============================================================================

namespace tools
{
    template<class ch>
    constexpr bool is_uint_symbol(const ch& symbol) noexcept
    {
        constexpr const ch null('0');
        constexpr const ch nine('9');
        return symbol >= null && symbol <= nine;
    }

    namespace detail
    {
        template<class ch> bool is_uint(const ch* s) noexcept
        {
            assert(s);
            while (*s != 0)
            {
                if (!::tools::is_uint_symbol(*s))
                    return false;
                ++s;
            }
            return true;
        }

    } // namespace detail

    template<class s> bool is_uint(const s& text) noexcept
    {
        const auto* ptr = &text[0];
        assert(ptr);
        if (ptr[0] == 0)
            return false;
        return detail::is_uint(ptr);
    }

} // namespace tools

//==============================================================================
//==============================================================================

#endif // !dTOOLS_IS_UINT_USED_

