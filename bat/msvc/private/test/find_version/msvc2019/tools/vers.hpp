
#pragma once
#ifndef dTOOLS_VERS_USED_
#define dTOOLS_VERS_USED_ 1

// #include <functional>
#include <string>
//#include <list>

#define dOUT_TO_STREAM(classname)  \
    template<class ostream> friend \
    ostream& operator<<(ostream& out, const classname& obj)

//==============================================================================
//==============================================================================

namespace std
{
    template <class T> struct hash;

} // namespace std

namespace tools
{
    using str_t  = ::std::string;

    enum eCOMPARE_VERSION { eCV_SAME, eCV_GREATER, eCV_LESS };

    eCOMPARE_VERSION compare_versions(const str_t& a, const str_t& b) noexcept;

    const char* compare_versions_str(const str_t& a, const str_t& b) noexcept;

    class build_version
    {
        dOUT_TO_STREAM(build_version)
        {
            out << obj.str();
            return out;
        }

        friend bool operator==(const build_version&, const build_version&) noexcept;
        friend bool operator>=(const build_version&, const build_version&) noexcept;
        friend bool operator> (const build_version&, const build_version&) noexcept;
        friend bool operator< (const build_version&, const build_version&) noexcept;
        friend bool operator<=(const build_version&, const build_version&) noexcept;
    public:
        build_version(str_t) noexcept;
        build_version(const build_version&);
        build_version(build_version&&) noexcept;

        build_version& operator=(const build_version&);
        build_version& operator=(build_version&&) noexcept;

        const str_t& str() const noexcept;

    private:
        str_t m_text;
    };

    bool operator==(const build_version&, const build_version&) noexcept;
    bool operator>=(const build_version&, const build_version&) noexcept;
    bool operator> (const build_version&, const build_version&) noexcept;
    bool operator< (const build_version&, const build_version&) noexcept;
    bool operator<=(const build_version&, const build_version&) noexcept;

} // namespace tools

namespace std
{
    template <> struct hash<::tools::build_version>
    {
        size_t operator()(const ::tools::build_version& x) const noexcept
        {
            using hash_t = hash<::std::string>;
            return hash_t()(x.str());
        }
    };

} // namespace std

//==============================================================================
//==============================================================================

#endif // !dTOOLS_VERS_USED_

