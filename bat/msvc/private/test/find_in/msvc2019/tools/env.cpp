
#include <tools/env.hpp>
#include <tools/tokenizer.hpp>

#include <cstdlib>

//================================================================================
//=== [length] ===================================================================
namespace tools
{
    namespace env
    {
        namespace
        {
            void copy(const wchar_t* from, char(&dst)[256]) noexcept
            {
                assert(from);
                for(size_t i = 0; i != 255; ++i)
                {
                    dst[i] = static_cast<char>(from[i]);
                    if(dst[i] == 0)
                        return;
                }
                dst[255] = 0;
            }

            template<class it, class ch>
            it find(it b, const it& e, const ch& val) noexcept
            {
                for(; b != e; ++b)
                    if(*b == val)
                        return b;
                return b;
            }

            template<class ch> 
            size_t strlen(const ch* text) noexcept
            {
                assert(text);
                const ch* cur = text;
                while(*cur != 0)
                    ++cur;
                return static_cast<size_t>(cur - text);
            }

        } // namespace


        // return length of environment variable 
        // without null-terminator 
        // 0 if non exist or empty

        size_t length(const char* variable) noexcept
        {
            assert(variable);
            #ifdef _MSC_VER
                size_t required_size = 0;
                const auto success
                    = ::getenv_s(&required_size, NULL, 0, variable) == 0;
                assert(success);  
                (void)success;
                return required_size == 0? 0: required_size - 1;
            #else
                const auto* pval
                    = ::std::getenv(variable);
                return pval? env::strlen(pval) : 0;
            #endif
        }

        size_t length(const wchar_t* variable) noexcept
        {
            assert(variable);

            #ifdef _MSC_VER
                size_t required_size = 0;
                const auto success
                    = ::_wgetenv_s(&required_size, NULL, 0, variable) == 0;
                assert(success);  
                (void)success;
                return required_size == 0? 0: required_size - 1;
            #else
                char dst[256];
                env::copy(variable, dst);
                return env::length(dst);
            #endif
        }

    } // namespace env

} // namespace tools

//================================================================================
//=== [exist] ====================================================================
namespace tools
{
    namespace env
    {
        bool exist(const char* variable) noexcept
        {
            assert(variable);
            return length(variable) != 0;
        }

        bool exist(const wchar_t* variable) noexcept
        {
            assert(variable);
            return length(variable) != 0;
        }

    } // namespace env

} // namespace tools

//================================================================================
//=== [set] ======================================================================
namespace tools
{
    namespace env
    {
        bool set(const char* variable, const char* value) noexcept
        {
            assert(value);
            assert(variable);
            bool success = false;

            #ifdef _MSC_VER
                success = ::_putenv_s(variable, value) == 0;
            #else
                try
                {
                    const std::string var = variable;
                    const std::string val = value;
                    const std::string now = var + '=' + val;
                    success = ::putenv(now.c_str()) == 0;
                }
                catch(...){}
            #endif
            return success;
        }

        bool set(const wchar_t* variable, const wchar_t* value) noexcept
        { 
            assert(variable && value);
            #ifdef _MSC_VER
                const bool success
                    = ::_wputenv_s(variable, value) == 0;
                return success;
            #else
                char var[256];
                char val[256];
                env::copy(variable, var);
                env::copy(value, val);
                return env::set(var, val);
            #endif
        }

    } // namespace env

} // namespace tools

//================================================================================
//=== [unset] ====================================================================
namespace tools
{
    namespace env
    {
        bool unset(const char* variable) noexcept
        {
            assert(variable);
            return set(variable, "");
        }

        bool unset(const wchar_t* variable) noexcept
        {
            assert(variable);
            return set(variable, L"");
        }

    } // namespace env

} // namespace tools

//================================================================================
//=== [get] ======================================================================
namespace tools
{
    namespace env
    {
        bool get(const char* variable, char* dst, const size_t length) noexcept
        {
            assert(dst);
            assert(variable);
            if(length == 0)
                return false;

            #ifdef _MSC_VER
                size_t required_size = 0;
                const bool success
                    = ::getenv_s(&required_size, dst, length, variable) == 0;
                return success;
            #else
                const char* pval = ::getenv(variable);
                for(size_t i = 0; i != length - 1; ++i, ++pval)
                {
                    dst[i] = *pval;
                    if(dst[i] == 0)
                        return true;
                }
                dst[length - 1] = '\0';
                return true;
            #endif
        }

        bool get(const wchar_t* variable, wchar_t* dst, const size_t length) noexcept
        {
            assert(dst);
            assert(variable);
            if(length == 0)
                return false;

            #ifdef _MSC_VER
                size_t required_size = 0;
                const auto success 
                    = ::_wgetenv_s(&required_size, dst, length, variable) == 0;
                return success; 
            #else
                char var[256];
                env::copy(variable, var);
                const char* pval = ::std::getenv(var);
                if(!pval)
                    return false;

                for(size_t i = 0; i != length - 1; ++i,++pval)
                {
                    dst[i] = static_cast<wchar_t>(*pval);
                    if(dst[i] == 0)
                        return true;
                }
                dst[length - 1] = '\0';
                return true;
            #endif
        }

    } // namespace env

} // namespace tools

//================================================================================
//=== [add] ======================================================================
namespace tools
{
    namespace env
    {
        bool add(const char* variable, const char* value, const char delim) noexcept
        {
            assert(variable && value);
            std::string re = env::get(variable);
            if(!re.empty())
                re += delim;
            re += value;
            return env::set(variable, re);
        }

        bool add(const wchar_t* variable, const wchar_t* value, const char delim) noexcept
        {
            assert(variable && value);
            std::wstring re = env::get(variable);
            if(!re.empty())
                re += static_cast<wchar_t>(delim);
            re += value;
            return env::set(variable, re);
        }

    } // namespace env

} // namespace tools

//================================================================================
//=== [expand] ===================================================================
namespace tools
{
    namespace env
    {
        namespace
        {
            template<class ch> 
            bool is_upper_pointer(const ch* const text) noexcept
            {
                assert(text);
                for (const auto* p = text; *p != 0; ++p)
                {
                    auto& sym = *p;
                    if (sym >= 'a' && sym <= 'z')
                        return false;
                }
                return true;
            }

            template<class ch> auto 
                sepparators() ->const auto&;

            template<> inline auto sepparators<char>() -> const auto&   
                { return  "\\/-"; }

            template<> inline auto sepparators<wchar_t>() ->const auto& 
                { return L"\\/-"; }

        } // namespace

        template<class ch, class it> auto expand(const it& beg, const it& end)
        {
            using str_t = ::std::basic_string<ch>;

            str_t result; 
            const auto& punctuations = env::sepparators<ch>();

            const auto b = ::std::begin(punctuations);
            const auto e = ::std::end(punctuations);

            const auto words = [&result](const ch* p, const size_t len)
            {
                const str_t v(p, len);
                assert(!v.empty());

                if(v[0] == 'e' && is_upper_pointer(&v[1]))
                {
                    const str_t value = env::get(v);
                    result += env::expand(value);
                }
                else
                    result += v;
            };

            const auto punct = [&result, &b, &e](const ch c)
            {
                if(result.empty() || env::find(b, e, result.back()) == e)
                    result += c;
            };

            ::tools::tokenize(beg, end, b, e, words, punct);

            if(!result.empty() && env::find(b, e, result.back()) != e)
                result.pop_back();
            return result;
        }


        ::std::string expand(const ::std::string& variable)
        {
            return env::expand<char>(variable.cbegin(), variable.cend());
        }

        ::std::string expand(const char* variable)
        {
            assert(variable);
            return env::expand<char>(
                variable, 
                variable + env::strlen(variable)
            );
        }

        ::std::wstring expand(const ::std::wstring& variable)
        {
            return env::expand<wchar_t>(
                variable.cbegin(),
                variable.cend()
            );
        }

        ::std::wstring expand(const wchar_t* variable)
        {
            assert(variable);
            return env::expand<wchar_t>(
                variable, 
                variable + env::strlen(variable)
            );
        }

    } // namespace env

} // namespace tools

//================================================================================
//=== [expand_format] ============================================================
namespace tools
{
    namespace env
    {
        template<class ch, class it> 
        auto expand_format(const it& beg, const it& end, const char prefix_)
        {
            using str_t = ::std::basic_string<ch>;

            const ch prefix = static_cast<ch>(prefix_);

            str_t result; 
            const auto& punctuations = env::sepparators<ch>();

            const auto b = ::std::begin(punctuations);
            const auto e = ::std::end(punctuations);

            const auto words = [prefix, &result](const ch* p, const size_t len)
            {
                str_t v(p, len);
                const bool interst = v.front() == '{' && v.back() == '}';
                if(!interst)
                {
                    result += v;
                    return;
                }

                v.pop_back();
                v.erase(0, 1);
                if(v.empty())
                    return;

                v = prefix + v;
                const str_t value = env::get(v);
                result += env::expand_format(value);
            };

            const auto punct = [&result, &b, &e](const ch c)
            {
                if(result.empty() || env::find(b, e, result.back()) == e)
                    result += c;
            };

            ::tools::tokenize(beg, end, b, e, words, punct);

            if(!result.empty() && env::find(b, e, result.back()) != e)
                result.pop_back();
            return result;
        }

        ::std::string expand_format(const ::std::string& variable, const char prefix)
        {
            return env::expand_format<char>(
                variable.cbegin(), variable.cend(), prefix
            );
        }

        ::std::string expand_format(const char* variable, const char prefix)
        {
            assert(variable);
            return env::expand_format<char>(
                variable, 
                variable + env::strlen(variable),
                prefix
            );
        }

        ::std::wstring expand_format(const ::std::wstring& variable, const char prefix)
        {
            return env::expand_format<wchar_t>(
                variable.cbegin(),
                variable.cend(),
                prefix
            );
        }

        ::std::wstring expand_format(const wchar_t* variable, const char prefix)
        {
            assert(variable);
            return env::expand_format<wchar_t>(
                variable, 
                variable + env::strlen(variable),
                prefix
            );
        }

    } // namespace env

} // namespace tools

//================================================================================
//================================================================================


