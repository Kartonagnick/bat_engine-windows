
// --- workspace/scripts/bat/msvc                             [find_in][env.hpp]
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick    
//   [2023-06m-01][01:54:31] 002 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//==============================================================================

#pragma once

#ifndef dTOOLS_ENV_USED_
#define dTOOLS_ENV_USED_ ::tools::env

#include <type_traits>
#include <cassert>
#include <string>

//================================================================================
//=== [declarations] =============================================================
namespace tools
{
    namespace env
    {
        // return length of environment variable 
        // without null-terminator 
        // 0 if non exist or empty
        template<class s>
        size_t length(const s& variable) noexcept;

        size_t length(const char*    variable) noexcept;
        size_t length(const wchar_t* variable) noexcept;



        template<class s> 
        bool exist(const s& variable) noexcept;

        bool exist(const char*    variable) noexcept;
        bool exist(const wchar_t* variable) noexcept;



        // if success ---> true
        template<class s1, class s2>
        bool set(const s1& variable, const s2& value) noexcept;

        bool set(const char*    variable, const char*    value) noexcept;
        bool set(const wchar_t* variable, const wchar_t* value) noexcept;



        // if success ---> true
        template<class s>
        bool unset(const s& variable) noexcept;

        bool unset(const char*    variable) noexcept;
        bool unset(const wchar_t* variable) noexcept;



        // if success ---> true
        template<class s1, class s2>
        bool add(const s1& variable, const s2& value, const char delim = ';') noexcept;

        bool add(const char*    variable, const char*    value, const char delim = ';') noexcept;
        bool add(const wchar_t* variable, const wchar_t* value, const char delim = ';') noexcept;



        // return basic_string<char_type>
        template<class s1>
        auto get(const s1& variable);

        bool get(const char*    variable, char*    dst, const size_t length) noexcept;
        bool get(const wchar_t* variable, wchar_t* dst, const size_t length) noexcept;



        template<class s>
        auto expand(const s& variable);

        ::std::string expand(const ::std::string& variable);
        ::std::string expand(const char* variable);

        ::std::wstring expand(const ::std::wstring& variable);
        ::std::wstring expand(const wchar_t* variable);



        template<class s>
        auto expand_format(const s& variable, const char prefix = 'e');

        ::std::string expand_format(const ::std::string& variable, const char prefix = 'e');
        ::std::string expand_format(const char* variable, const char prefix = 'e');

        ::std::wstring expand_format(const ::std::wstring& variable, const char prefix = 'e');
        ::std::wstring expand_format(const wchar_t* variable, const char prefix = 'e');

    } // namespace env
} // namespace tools

//================================================================================
//=== [implementation] ===========================================================
namespace tools
{
    namespace env
    {
        template<class s>
        size_t length(const s& variable) noexcept
        {
            const auto* var = &variable[0];
            return env::length(var);
        }

        template<class s>
        bool exist(const s& variable) noexcept
        {
            const auto* var = &variable[0];
            return env::exist(var);
        }

        template<class s1, class s2>
        bool set(const s1& variable, const s2& value) noexcept
        {
            const auto* var = &variable[0];
            const auto* val = &value[0];
            return env::set(var, val);
        }

        template<class s>
        bool unset(const s& variable) noexcept
        {
            const auto* var = &variable[0];
            return env::unset(var);
        }

        template<class s1, class s2>
        bool add(const s1& variable, const s2& value, const char delim) noexcept
        {
            const auto* var = &variable[0];
            const auto* val = &value[0];
            return env::add(var, val, delim);
        }

        // return basic_string<char_type>
        template<class s> auto get(const s& variable)
        {
            using ref   = decltype(variable[0]);
            using x     = ::std::remove_reference_t<ref>;
            using ch    = ::std::remove_cv_t<x>;

            const size_t len = env::length(variable) + 1;
            ::std::basic_string<ch> dst(len, 0);

                  ch* d = &dst[0];
            const ch* v = &variable[0];

            const bool found = env::get(v, d, len);
            if(found)
            {
                assert(dst.back() == 0);
                dst.pop_back();
            }
            else
                dst.clear();

            return dst;
        }

        template<class s>
        auto expand(const s& variable)
        {
            const auto* var = &variable[0];
            return env::expand(var);
        }

        template<class s>
        auto expand_format(const s& variable, const char prefix)
        {
            const auto* var = &variable[0];
            return env::expand_format(var, prefix);
        }

    } // namespace env
} // namespace tools

//================================================================================
//================================================================================

#endif // dTOOLS_ENV_USED_

