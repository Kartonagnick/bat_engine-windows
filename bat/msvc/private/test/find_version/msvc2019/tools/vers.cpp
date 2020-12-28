
#pragma once

#include <tools/vers.hpp>
#include <tools/is_uint.hpp>

#include <cassert>

//==============================================================================
//==============================================================================

namespace tools
{
    namespace
    {
        struct version_ex
        {
            version_ex(const str_t& a) 
                : text(a), pos() 
            {
                if (text.empty())
                    pos = str_t::npos;
            }

            str_t next()
            {
                const auto find = text.find('.', pos);
                if (find == str_t::npos)
                {
                    const str_t sub = text.substr(pos);
                    pos = str_t::npos;
                    return sub;
                }
                const str_t sub = text.substr(pos, find - pos);
                pos = find + 1;
                return sub;
            }

            bool operator !() const noexcept
            {
                return pos == str_t::npos;
            }

            explicit operator bool() const noexcept
            {
                return pos != str_t::npos;
            }

            str_t text;
            size_t pos;
        };

    } // namespace

    eCOMPARE_VERSION compare_versions(const str_t& a, const str_t& b) noexcept
    {
        version_ex ver_a(a);
        version_ex ver_b(b);

        while (ver_a && ver_b)
        {
            const auto sa = ver_a.next();
            const auto sb = ver_b.next();

            const bool is_uint_a = tools::is_uint(sa);
            const bool is_uint_b = tools::is_uint(sb);

            //std::cout << sa << " VS " << sb << '\n';

            if (is_uint_a && is_uint_b)
            {
                const size_t na = ::std::stoul(sa);
                const size_t nb = ::std::stoul(sb);
                if (na == nb)
                    continue;
                if(na < nb)
                    return eCOMPARE_VERSION::eCV_LESS;

                assert(na > nb);
                return eCOMPARE_VERSION::eCV_GREATER;
            }
            else if (!is_uint_a && !is_uint_b)
            {
                if(sa == sb)
                    continue;
                if (sa < sb)
                    return eCOMPARE_VERSION::eCV_LESS;

                assert(sa > sb);
                return eCOMPARE_VERSION::eCV_GREATER;
            }
            else if (is_uint_a && !is_uint_b)
                return eCOMPARE_VERSION::eCV_LESS;
            else 
            {
                assert(!is_uint_a && is_uint_b);
                return eCOMPARE_VERSION::eCV_GREATER;
            }
        }

        if(!ver_a && !ver_b)
            return eCOMPARE_VERSION::eCV_SAME;
        if(!ver_a)
            return eCOMPARE_VERSION::eCV_LESS;

        return eCOMPARE_VERSION::eCV_GREATER;
    }

    const char* compare_versions_str(const str_t& a, const str_t& b) noexcept
    {
        eCOMPARE_VERSION v = ::tools::compare_versions(a, b);
        switch (v)
        {
        case tools::eCV_SAME:    return "SAME"   ;
        case tools::eCV_GREATER: return "GREATER";
        case tools::eCV_LESS:    return "LESS"   ;
        }
        assert(false);
        return "eCOMPARE_VERSION_ERROR";
    }

} // namespace tools

//==============================================================================
//==============================================================================

namespace tools
{
    build_version::build_version(str_t v) noexcept
        : m_text(::std::move(v))
    {}

    build_version::build_version(const build_version& v)
        : m_text(v.m_text)
    {}

    build_version::build_version(build_version&& v) noexcept
        : m_text(::std::move(v.m_text))
    {}

    build_version& build_version::operator=(const build_version& v)
    {
        if (this != &v)
            this->m_text = v.m_text;
        return *this;
    }

    build_version& build_version::operator=(build_version&& v) noexcept
    {
        if (this != &v)
            this->m_text = ::std::move(v.m_text);
        return *this;
    }

    const str_t& build_version::str() const noexcept
    {
        return this->m_text;
    }

    bool operator==(const build_version& a, const build_version& b) noexcept
    {
        const auto re = ::tools::compare_versions(a.m_text, b.m_text);
        return re == eCOMPARE_VERSION::eCV_SAME;
    }
    bool operator>=(const build_version& a, const build_version& b) noexcept
    {
        const auto re = ::tools::compare_versions(a.m_text, b.m_text);
        return 
            re == eCOMPARE_VERSION::eCV_SAME || 
            re == eCOMPARE_VERSION::eCV_GREATER;
    }

    bool operator> (const build_version& a, const build_version& b) noexcept
    {
        const auto re = ::tools::compare_versions(a.m_text, b.m_text);
        return re == eCOMPARE_VERSION::eCV_GREATER;
    }

    bool operator< (const build_version& a, const build_version& b) noexcept
    {
        const auto re = ::tools::compare_versions(a.m_text, b.m_text);
        return re == eCOMPARE_VERSION::eCV_LESS;
    }

    bool operator<=(const build_version& a, const build_version& b) noexcept
    {
        const auto re = ::tools::compare_versions(a.m_text, b.m_text);
        return
            re == eCOMPARE_VERSION::eCV_SAME ||
            re == eCOMPARE_VERSION::eCV_LESS;
    }

} // namespace tools

//==============================================================================
//==============================================================================


#if 0
void test(const str_t& a, const str_t& b, const str_t& e)
{
    const str_t r = tools::compare_versions_str(a, b);
    if (r != e)
    {
        std::cerr << "[ERROR] a = '"      << a << "'\n";
        std::cerr << "[ERROR] b = '"      << b << "'\n";
        std::cerr << "[ERROR] etalon = '" << e << "'\n";
        std::cerr << "[ERROR] real = '"   << r << "'\n";
        std::cerr << "[FAILED]\n";
        ::std::terminate();
    }
}


int main(int argc, char* argv[])
{
    (void)argc;
    (void)argv;

    test("1"         , "1"       , "SAME"   );
    test("12.34.56"  , "12.34.56", "SAME"   );
    test(""          , ""        , "SAME"   );
    test("1"         , "2"       , "LESS"   );
    test("2"         , "1"       , "GREATER");
    test("1"         , "1.1"     , "LESS"   );
    test("1.1"       , "1"       , "GREATER");
    test("1.1"       , "1.x"     , "LESS"   );
    test("1.x"       , "1.1"     , "GREATER");
    test("1.x"       , "1.x.1"   , "LESS"   );
    test("1.x.1"     , "1.x"     , "GREATER");
    test("1.x"       , "1.1.1"   , "GREATER");
    test("1.1.1"     , "1.x"     , "LESS"   );
    test("a"         , "b"       , "LESS"   );
    test("b"         , "a"       , "GREATER");
    test("a.dd"      , "b.dd"    , "LESS"   );
    test("b.dd"      , "a.dd"    , "GREATER");
    test("aa.bb.11"  , "aa.bb.22", "LESS"   );
    test("aa.bb.22"  , "aa.bb.11", "GREATER");
}
#endif