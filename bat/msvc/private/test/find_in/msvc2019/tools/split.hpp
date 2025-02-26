
#pragma once

#include <string>
#include <list>

#include <tools/stringed/tokenizer.hpp>
#include <tools/stringed/trim.hpp>

//==============================================================================
//=== split ====================================================================
namespace tools
{
    using str_t  = ::std::string;
    using list_t = ::std::list<str_t>;

    inline list_t split(const str_t& src, const str_t& sep = ":")
    {
        list_t result;
        const auto word = [&result](const char* text, const size_t len)
        {
            str_t tmp(text, len);
            ::tools::trim(tmp);
            if(!tmp.empty())
                result.emplace_back(::std::move(tmp));
        };

        const auto punct = [](const char){};
        ::tools::tokenize(
            ::std::begin(src), 
            ::std::end(src), 
            ::std::begin(sep), 
            ::std::end(sep), 
            word, 
            punct
        );

        return result;
    }

} // namespace tools

//==============================================================================
//==============================================================================
