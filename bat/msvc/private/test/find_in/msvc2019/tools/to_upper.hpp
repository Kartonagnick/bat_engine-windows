
// --- workspace/scripts/bat/msvc                        [find_in][to_upper.hpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick    
//   [2023-06m-01][01:54:31] 002 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//=== to_upper =================================================================

#ifndef dTOOLS_TO_UPPER_USED_ 
#define dTOOLS_TO_UPPER_USED_ 1

namespace tools
{
    namespace detail
    {
        template<class ch> void to_upper(ch* text) noexcept
        {
            constexpr auto offset_eng = 'a' - 'A';
            constexpr auto offset_rus = 'ÿ' - 'ß';
            assert(text);
            while (*text != 0)
            {
                auto& sym = *text;
                if (sym >= 'a' && sym <= 'z')
                    sym = sym - offset_eng;
                else if(sym >= 'à' && sym <= 'ÿ')
                    sym = sym - offset_rus;
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
                if (sym >= 'à' && sym <= 'ÿ')
                    return false;
            }
            return true;
        }

    } // namespace detail

    template<class ch>
    constexpr ch to_upper_symbol(const ch& symbol) noexcept
    {
        constexpr auto offset_eng = 'a' - 'A';
        constexpr auto offset_rus = 'ÿ' - 'ß';
        if (symbol >= 'a' && symbol <= 'z')
            return static_cast<ch>(symbol - offset_eng);
        if (symbol >= 'à' && symbol <= 'ÿ')
            return static_cast<ch>(symbol - offset_rus);
        return symbol;
    }

    template<class s> void to_upper(s& text)
    {
        using x = std::remove_pointer_t<
            std::remove_reference_t<s>
        >;
        enum { valid = !std::is_const<x>::value };
        static_assert(valid, "must be non-const");
        auto* ptr = &text[0];
        tools::detail::to_upper(ptr);
    }

    template<class collect> void to_upper_collection(collect& coll)
    {
        for (auto& text : coll)
            tools::to_upper(text);
    }

    template<class s> bool is_upper(const s& text) noexcept
    {
        const auto* const ptr = &text[0];
        return tools::detail::to_upper(ptr);
    }

} // tools
//================================================================================
//================================================================================
#endif // dTOOLS_TO_UPPER_USED_
