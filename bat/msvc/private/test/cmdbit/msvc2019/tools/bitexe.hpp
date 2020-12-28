
#pragma once
#ifndef dFSYSTEM_BITEXE_USED_
#define dFSYSTEM_BITEXE_USED_ 1

#include <fstream>
#include <string>

namespace fsystem
{
    using str_t = ::std::string;
    using str_w = ::std::wstring;

    enum eBIT_MODEL
    {
        eBIT_NONE,
        eBIT_32_ELF,
        eBIT_64_ELF,
        eBIT_32_WIN,
        eBIT_64_WIN
    };

    eBIT_MODEL check_bit_model(const str_t& path);
    eBIT_MODEL check_bit_model(const str_w& path);

    eBIT_MODEL check_bit_model(const char*    path);
    eBIT_MODEL check_bit_model(const wchar_t* path);

    template<class s>
    eBIT_MODEL check_bit_model(const s& path)
    {
        const auto* ptr = &path[0];
        return ::fsystem::check_bit_model(ptr);
    }

    template<class s> bool is32bit(const s& path)
    {
        const auto re = ::fsystem::check_bit_model(path);
        return re == eBIT_32_ELF || re == eBIT_32_WIN;
    }

    template<class s> bool is64bit(const s& path)
    {
        const auto re = ::fsystem::check_bit_model(path);
        return re == eBIT_64_ELF || re == eBIT_64_WIN;
    }

} // namespace fsystem

//==============================================================================
//=== namespace fsystem ========================================================
namespace tools
{
    namespace fsystem = ::fsystem;

} // namespace tools

//==============================================================================
//==============================================================================

#endif // !dFSYSTEM_BITEXE_USED_

