
#include "tools/fsystem.hpp"
#include "tools/pattern.hpp"

#include <Windows.h>
#include <stdexcept>
#include <cassert>
#include <string>
#include <list>
//==============================================================================
//==============================================================================

namespace fsystem
{
    namespace
    {
        template<class s> bool is_dots(const s& path) noexcept
        {
            const auto& a = path[0];
            const auto& b = path[1];
            const auto& c = path[2];
            if (a == '.' && (b == 0 || (b == '.' && c == 0)))
                return true;
            return false;
        }

        ::DWORD reset_attrib(const ::std::string& path)
        {
            const ::DWORD attr = ::GetFileAttributesA(path.c_str());

            if (attr == INVALID_FILE_ATTRIBUTES)
                throw ::std::runtime_error(
                    "reset_attrib(): "
                    "can't get attributes for file: '" + path + "'"
                );

            constexpr const ::DWORD all
                = FILE_ATTRIBUTE_READONLY | FILE_ATTRIBUTE_HIDDEN | FILE_ATTRIBUTE_SYSTEM;

            const ::DWORD attr2 = attr & (~all);

            if (!::SetFileAttributesA(path.c_str(), attr2))
                throw ::std::runtime_error(
                    "reset_attrib(): "
                    "can't set attributes for file: '" + path + "'"
                );

            return attr;
        }

        struct raiiA
        {
            raiiA(const ::std::string& dir): hFind()
            {
                ::std::string mask = dir + "\\*";

                this->hFind 
                    = ::FindFirstFileA(mask.c_str(), &this->ffd);

                if (this->hFind == INVALID_HANDLE_VALUE)
                    throw ::std::runtime_error(
                        "remove_directory(INVALID_HANDLE_VALUE): '" 
                        + dir + "'"
                    );
            }

            bool next() noexcept
            {
                return ::FindNextFileA(this->hFind, &this->ffd);
            }

            ~raiiA()
            {
                const ::BOOL re = ::FindClose(this->hFind);
                assert(re);
                (void) re;
            }

            ::HANDLE hFind;
            ::WIN32_FIND_DATAA ffd;
        };

    } // namespace

//==============================================================================
//==============================================================================

    bool is_directory(const ::std::string& path) 
    {
        const ::DWORD attr = ::GetFileAttributesA(path.c_str());
        if (attr == INVALID_FILE_ATTRIBUTES)
            throw ::std::runtime_error(
                "is_directory(): "
                "can't get attributes for file: '" + path + "'"
            );

        if (attr & FILE_ATTRIBUTE_DIRECTORY)
            return true;
        return false;
    }

    void remove_file(const ::std::string& path)
    {
        const auto old = fsystem::reset_attrib(path);
        if (::DeleteFileA(path.c_str()))
            return;

        const auto re = ::SetFileAttributesA(path.c_str(), old);
        assert(re);
        (void)re;
        throw ::std::runtime_error(
            "remove_file(): '" + path + "'"
        );
    }

    void remove_directory(const ::std::string& dir)
    {
        ::fsystem::raiiA data(dir);
        while(data.next())
        {
            if (fsystem::is_dots(data.ffd.cFileName))
                continue;

            const auto path 
                = dir + "\\" + data.ffd.cFileName;

            if (data.ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
                fsystem::remove_directory(path);
            else
                fsystem::remove_file(path);
        }

        if (::GetLastError() != ERROR_NO_MORE_FILES)
            throw ::std::runtime_error(
                "delete_directory(FindNextFile): '"
                + dir + "'"
            );

        // remove the empty directory
        if (!::RemoveDirectoryA(dir.c_str()))
            throw ::std::runtime_error(
                "delete_directory(RemoveDirectory): '"
                + dir + "'"
            );
    }

    void remove_all(const ::std::string& path)
    {
        if(!::fsystem::is_directory(path))
            remove_file(path);
        else
            ::fsystem::remove_directory(path);
    }


    bool has_wild(const ::std::string& text) noexcept
    {
        for (const auto& ch : text)
            if (ch == '*' || ch == '?')
                return true;
        return false;
    }

    void remove_empty(std::list<std::string>& s)
    {
        for (auto i = s.cbegin(); i != s.cend(); )
            if (i->empty())
                i = s.erase(i);
            else
                ++i;
    }


    template<class Path>
    bool exists_(const Path& path, const std::list<std::string>& symptoms)
    {
        if (symptoms.empty())
            return true;

        auto s = symptoms;
        for (auto i = s.begin(), e = s.end(); i != e; ++i)
        {
            auto& symptom = *i;
            if (has_wild(symptom))
                continue;

            fs::path p(path);
            p = p/ symptom;

            if (!fs::exists(p))
                return false;
            symptom = "";
        }

        remove_empty(s);
        if (s.empty())
            return true;

        for (const fs::path& cur : fs::directory_iterator(path))
        {
            const auto name = cur.filename().generic_string();
            for (auto i = s.cbegin(), e = s.cend(); i != e; ++i)
            {
                const auto& symptom = *i;
                if (symptom.empty() || tools::match_pattern(name, symptom))
                {
                    s.erase(i);
                    if (s.empty())
                        return true;
                    break;
                }
            }
        }
        return false;
    }


    bool exists(const fs::path& path, const std::list<std::string>& symptoms)
    {
        return exists_(path, symptoms);
    }

    bool exists(const ::std::string& path, const std::list<std::string>& symptoms)
    {
        return exists_(path, symptoms);
    }

} // namespace fsystem



