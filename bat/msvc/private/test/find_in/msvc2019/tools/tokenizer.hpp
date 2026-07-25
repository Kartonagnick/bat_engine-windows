
// --- workspace/scripts/bat/msvc                       [find_in][tokenizer.hpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick PRE
//   [2023-06m-01][01:54:31] 002 Kartonagnick PRE
//   [2022-08m-05][05:59:37] 001 Kartonagnick PRE

//==============================================================================
//==============================================================================

#pragma once

#ifndef dTOOLS_TOKENIZER_USED_
#define dTOOLS_TOKENIZER_USED_ ::tools

#ifndef NDEBUG
    // debug 
    #include <type_traits>
    #include <cassert>
#endif

//==============================================================================
//==============================================================================

namespace tools
{
    #ifndef NDEBUG
        // debug 
        template<class s>
        ::std::enable_if_t<
            ::std::is_pointer< ::std::remove_reference_t<s> >::value
        > 
        check_pointer(s&& val) noexcept
        {
            assert(val);
            (void) val;
        }

        template<class s>
        ::std::enable_if_t<
            !::std::is_pointer< ::std::remove_reference_t<s> >::value
        > 
        check_pointer(s&&) noexcept {}
    #endif // !!NDEBUG

    template <class it1, class it2, class predicat>
    it1 find_first_of(it1 b1, const it1& e1, const it2& b2, const it2& e2, predicat&& pred) noexcept(noexcept(pred(*b1, *b2)))
    {
        #ifndef NDEBUG
            ::tools::check_pointer(b1);
            ::tools::check_pointer(e1);
            ::tools::check_pointer(b2);
            ::tools::check_pointer(e2);
        #endif

        for (; b1 != e1; ++b1) 
        {
            for (auto i = b2; i != e2; ++i)
                if(pred(*b1, *i)) 
                    return b1;
        }
        return b1;
    }

    template <class it1, class it2>
    it1 find_first_of(it1 b1, const it1& e1, const it2& b2, const it2& e2) noexcept(noexcept(*b1 == *b2))
    {
        #ifndef NDEBUG
            ::tools::check_pointer(b1);
            ::tools::check_pointer(e1);
            ::tools::check_pointer(b2);
            ::tools::check_pointer(e2);
        #endif

        for (; b1 != e1; ++b1) 
        {
            for (auto i = b2; i != e2; ++i)
                if( *b1 == *i) 
                    return b1;
        }
        return b1;
    }



    template<class iter1, class iter2, class callWord, class callPunct>
    void tokenize(
        const iter1& beg_string    , 
        const iter1& end_string    , 
        const iter2& beg_separators, 
        const iter2& end_separators, 
        callWord&&   callbackWord  , 
        callPunct&&  callbackPunct ,
        const bool   trim_empty = true)
    {
        #ifndef NDEBUG
            ::tools::check_pointer(beg_string);
            ::tools::check_pointer(end_string);
            ::tools::check_pointer(beg_separators);
            ::tools::check_pointer(end_separators);
        #endif

        auto lst_pos = beg_string;
        auto cur_pos = beg_string;

        for(;;)
        {
            cur_pos = ::tools::find_first_of(
                lst_pos, end_string, 
                beg_separators, 
                end_separators
            );


            if(cur_pos == end_string)
            {
                if(cur_pos != lst_pos)
                    callbackWord(
                        &(*lst_pos), 
                        static_cast<size_t>(cur_pos - lst_pos)
                    );
                break;
            }
            else if(cur_pos != lst_pos || !trim_empty)
                callbackWord(
                    &(*lst_pos), 
                    static_cast<size_t>(cur_pos - lst_pos)
                ),
                callbackPunct(*cur_pos);
            else
                callbackPunct(*cur_pos);

            lst_pos = cur_pos + 1;
        }
    }

} // namespace tools

//==============================================================================
//==============================================================================
#endif // dTOOLS_TOKENIZER_USED_