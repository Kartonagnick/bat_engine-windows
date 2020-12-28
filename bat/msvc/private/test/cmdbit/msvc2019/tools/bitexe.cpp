
#include <tools/bitexe.hpp>

#include <stdexcept>
#include <fstream>
#include <cstring>
#include <cassert>

namespace
{
    char Elf32Magic[20] = "\x7f\x45\x4c\x46\01"; //7F 45 4C 46  01 // ELF32 
    char Elf64Magic[20] = "\x7f\x45\x4c\x46\02"; //7F 45 4C 46  02 // ELF64
    char Win32Magic[20] = "\x50\x45\x00\x00\x4C\x01"; // PE32
    char Win64Magic[20] = "\x50\x45\x00\x00\x64\x86"; // PE64

    using str_t = ::std::string;
    using str_w = ::std::wstring;
    using eBIT_MODEL = ::fsystem::eBIT_MODEL;

    inline str_t convert_(const str_w& from)
    {
        str_t dst;
        dst.reserve(from.length());
        for (const auto& w : from)
            dst += static_cast<char>(w);
        return dst;
    }

    inline const str_t& convert_(const str_t& from)
    {
        return from;
    }

    inline const char* convert_(const char* from)
    {
        return from;
    }

    inline str_t convert_(const wchar_t* from)
    {
        str_t dst;
        size_t count = 0;
        while (from[count] != 0)
            ++count;
        dst.reserve(count);
        for (size_t i = 0; i != count; ++i)
            dst += static_cast<char>(from[i]);
        return dst;
    }

    inline eBIT_MODEL check_bit_model_(::std::ifstream& in)
    {
        using x = eBIT_MODEL;

        assert(in);
        char header[0x200] = {};
        in.read(header, 0x200);
        if (!in)
            return x::eBIT_NONE;

        if (::std::memcmp(header, Elf32Magic, 5) == 0)
            return x::eBIT_32_ELF;

        if (::std::memcmp(header, Elf64Magic, 5) == 0)
            return x::eBIT_64_ELF;

        char peheader[20] = {};
        size_t k = 0;
        for (size_t i = 0; i < 0x200; ++i)
            if (header[i] == 0x50 && header[i + 1] == 0x45) // PE     
                for (size_t j = i; j < i + 6; ++j, ++k)
                    peheader[k] = header[j];

        if (::std::memcmp(&peheader, Win32Magic, 6) == 0)
            return x::eBIT_32_WIN;

        if (::std::memcmp(&peheader, Win64Magic, 6) == 0)
            return x::eBIT_64_WIN;

        return x::eBIT_NONE;
    }

    template<class s>
    inline eBIT_MODEL check_bit_model_(const s& path)
    {
        assert(&path[0]);
        const auto& p = ::convert_(path);

        constexpr auto read_binary
            = ::std::fstream::in | ::std::fstream::binary;

        ::std::ifstream in(p, read_binary);
        if (!in)
            throw ::std::runtime_error(
                "can not open: '" + str_t(p) + "'"
            );
        return ::check_bit_model_(in);
    }

} // namespace

namespace fsystem
{
    eBIT_MODEL check_bit_model(const char* path)
    {
        assert(path);
        return ::check_bit_model_(path);
    }
    eBIT_MODEL check_bit_model(const str_t& path)
    {
        return ::check_bit_model_(path);
    }

    eBIT_MODEL check_bit_model(const wchar_t* path)
    {
        assert(path);
        return ::check_bit_model_(path);
    }
    eBIT_MODEL check_bit_model(const str_w& path)
    {
        return ::check_bit_model_(path);
    }

} // namespace fsystem
