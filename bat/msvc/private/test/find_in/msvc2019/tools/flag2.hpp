
// --- workspace/scripts/bat/msvc                           [find_in][flag2.hpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick PRE
//   [2023-06m-01][01:54:31] 002 Kartonagnick PRE
//   [2022-08m-05][05:59:37] 001 Kartonagnick PRE

//==============================================================================
//==============================================================================

#pragma once

#ifndef dTOOLS_FLAG_2_USED_ 
#define dTOOLS_FLAG_2_USED_ 1

//==============================================================================
//=== size_t ===================================================================
namespace tools
{
    inline constexpr size_t 
    add_flags(const size_t flag, const size_t flags) noexcept
    {
        // 0 --- none
        // 1 --- enable all
        return
              flag == 0 ? flags
            : flag == 1 ? 1
            : flags | flag;
    }

    inline constexpr size_t 
    del_flags(const size_t flag, const size_t flags) noexcept
    {
        // 0 --- none
        // 1 --- disable all
        return
              flag == 0 ? flags
            : flag == 1 ? 0
            : flags & (~flag);
    }

    inline constexpr bool 
    has_any_flags(const size_t flag, const size_t flags) noexcept
    {
        // 0 --- none
        // 1 --- all
        return
              flag  == 0 ? flags == 0
            : flag  == 1 ? flags != 0
            : flags == 1 ? flag == 0 ? false : true
            : (flag & flags) != 0;
    }

    inline constexpr bool 
    has_flags(const size_t flag, const size_t flags) noexcept
    {
        // 0 --- none
        // 1 --- all
        return
              flag  == 0 ? flags == 0
            : flag  == 1 ? flags == 1
            : flags == 1 ? flag == 0 ? false : true
            : (flag & flags) == flag;
    }

} // namespace tools

//==============================================================================
//=== usage ====================================================================
#if 0
    enum eFLAGS { 
        eNONE = 0, eALL = 1, eONE = 1<<1, eTWO = 1<<2, eTHREE = 1<<3 
    };

    const size_t v = ::tools::del_flags(eTWO|eTHREE, eONE|eTWO|eTHREE);
    EXPECT_EQ(v, eONE);

    const bool has = ::tools::has_flags(eTWO|eTHREE, eONE|eTWO|eTHREE);
    EXPECT_EQ(has, true);
#endif
//==============================================================================
//==============================================================================
    
#endif // dTOOLS_FLAG_2_USED_
