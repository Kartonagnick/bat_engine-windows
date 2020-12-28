
#include "cmd.hpp"

#include <iostream>
#include <cstring>
#include <cassert>

#include "tools/find_in.hpp"
#include <tools/fsystem.hpp>
#include "tools/strncomp.hpp"
#include "tools/tokenizer.hpp"
#include "tools/pattern.hpp"
#include "tools/bitexe.hpp"
#include "tools/vers.hpp"
#include "tools/trim.hpp"
#include "tools/env.hpp"

#include <map>
#include <iostream>
#include <unordered_set>
//==============================================================================
//==============================================================================

namespace cmd
{
    bool checkQuotes(const char* text) noexcept
    {
        assert(text);
        size_t count = 0;
        for (const auto* i = text; *i != 0; ++i)
            if (*i == '"')
                ++count;

        if (count % 2 == 0)
            return true;
        return false;
    }

    void view_arguments(const int argi, char* argv[]) noexcept
    {
        assert(argi != 0);
        std::cout << "command arguments:\n";
        if (argi == 0)
        {
            std::cout << " -- none\n";
            return;
        }
        const size_t argc = static_cast<size_t>(argi);
        for (size_t i = 0; i != argc; ++i)
            std::cout << i << ") " << argv[i] << '\n';
    }

} // namespace cmd

//==============================================================================
//==============================================================================

namespace cmd
{
    inline list_t split(const char* src)
    {
        list_t result;
        const auto word = [&result](const char* text, const size_t len)
        {
            std::string tmp(text, len);
            ::tools::trim(tmp);
            if(!tmp.empty())
                result.emplace_back(std::move(tmp));
        };
        const auto punct = [](const char){};

        const auto& sep = ";";

        ::tools::tokenize(
            src, src + ::std::strlen(src),
            std::begin(sep), std::end(sep), 
            word, punct
        );

        return result;
    }

    inline void setCommandOptions(int argi, char** argv, options& dst)
    {
        assert(argi >= 1);
        if (argi <= 1)
            return;

        const size_t argc = static_cast<size_t>(argi);

        for(size_t i = 1; i != argc; ++i)
        {
            size_t x = 0;
            const char* arg = argv[i];

            if(!arg)
                goto next;

            while(arg[x] == ' ' || arg[x] == '-')
                if(arg[++x] == 0)
                    goto next;

            if (tools::strncmp_nocase(arg + x, "version:", 8) == 0)
                dst.versions = cmd::split(arg + x + 8);

            if (tools::strncmp_nocase(arg + x, "symptoms:", 9) == 0)
                dst.symptoms = cmd::split(arg + x + 9);

            if (tools::strncmp_nocase(arg + x, "min-version:", 12) == 0)
                dst.min_versions = cmd::split(arg + x + 12);

            if (tools::strncmp_nocase(arg + x, "max-version:", 12) == 0)
                dst.max_versions = cmd::split(arg + x + 12);

            if (tools::strncmp_nocase(arg + x, "names:", 6) == 0)
                dst.names = cmd::split(arg + x + 6);

            if (tools::strncmp_nocase(arg + x, "start:", 6) == 0)
                dst.dirs_start = cmd::split(arg + x + 6);

            else if (tools::strncmp_nocase(arg + x, "s:", 2) == 0)
                dst.scan_include = cmd::split(arg + x + 2);

            else if (tools::strncmp_nocase(arg + x, "es:", 3) == 0)
                dst.scan_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "debug", 5) == 0)
                dst.debug = true;

            else if (tools::strncmp_nocase(arg + x, "once", 4) == 0)
                dst.once = true;

        next:
            void();
        }
    }

    template<class container>
    inline void unsortedRemoveDuplicates(container& collect)
    {
        using val_t = typename container::value_type;
        ::std::unordered_set<val_t> seen;
        auto it = collect.cbegin();
        while (it != collect.cend())
            if (seen.find(*it) != seen.cend())
                it = collect.erase(it);
            else
                seen.insert(*it++);
    }

    inline void commit(list_t& dirs)
    {
        if (dirs.empty())
        {
            dirs.emplace_back(
                fs::current_path().generic_string()
            );
            return;
        }

        for(auto& val: dirs)
        {
            val = tools::env::expand(val);
            fs::path p = val + "/";
            if(!p.is_absolute())
                p = fs::current_path()/p;
            val = fs::canonical(p).generic_string();
        }
        cmd::unsortedRemoveDuplicates(dirs);
    }

    void options::view_syntaxis()
    {
        const char* msg
            = R"raw(syntaxis:

find_version 
    "--names: names-of-targets"     [required] 
    "--start: dirs-where-search"    [optional] 
    "--s: dirs-masks-include"       [optional]
    "--es: dirs-masks-exclude"      [optional]
    "--version: 1.10.x"             [optional]    
    "--min-version: 1.8.1"          [optional]    
    "--max-version: 1.10.x"         [optional]    
    "--symptoms: include;lib*"      [optional]
    "--debug"                       [optional]

example:
    find_version "--names: gmock; gtest" "--start: ePATH_WORKSPACE; ePATH_LONG" "--s: lib*" "--es: *" "--symptoms: include;lib*" "--debug"

    find_version "--names: gmock" "--start: ePATH_WORKSPACE/external" "--version: 1.8.1" "--symptoms: include; lib*" "--debug"

    find_version "--names: gmock" "--start: ePATH_WORKSPACE/external" "--min-version: 1.8.1" "--symptoms: include; lib*" "--debug"

    find_version "--names: gmock" "--start: ePATH_WORKSPACE/external" "--max-version: 1.10.x" "--symptoms: include; lib*" "--debug"

    find_version "--names: gmock" "--start: ePATH_WORKSPACE/external" "--min-version: 1.8.1" "--max-version: 1.10.x" "--symptoms: include; lib*" "--debug"
)raw";
        std::cout << msg << "\n";
    }

    inline void add_token(list_t& collect, const str_t& text)
    {
        const auto b = collect.cbegin();
        const auto e = collect.cend();
        const auto found = std::find(b, e, text);
        if (found == e)
            collect.emplace_back(text);
    }

    options::options(int argc, char** argv)
        : debug()
        , once()
        , versions()
        , min_versions()
        , max_versions()
        , names()
        , symptoms()
        , dirs_start()
        , scan_include()
        , scan_exclude()
        , dirs_include()
        , dirs_exclude()
        , files_include()
        , files_exclude()
    {
        cmd::setCommandOptions(argc, argv, *this);
        cmd::commit(this->dirs_start);

        this->dirs_include = this->names;

        add_token(this->scan_exclude, "_*");
        add_token(this->dirs_exclude, "_*");
        add_token(this->files_exclude, "_*");

        if (this->versions.size() > 1)
            throw std::logic_error("options(): invalid 'version'");

        if (this->min_versions.size() > 1)
            throw std::logic_error("options(): invalid 'min-version'");

        if (this->max_versions.size() > 1)
            throw std::logic_error("options(): invalid 'max-version'");

        #if 0
        if (!this->versions.empty())
        {
            if(!this->min_versions.empty())
                throw std::logic_error("options(): "
                    "conflict 'version' VS 'min-version'"
                );

            if (!this->max_versions.empty())
                throw std::logic_error("options(): "
                    "conflict 'version' VS 'max-version'"
                );
        }
        #endif
    }

} // namespace cmd

//==============================================================================
//==============================================================================

namespace cmd
{
    const std::string& commit(const options& opt, const std::string& path)
    {
        (void)opt;
        return path;
    }

    void view_result(
        const options& opt, 
        const size_t depth, 
        const std::string& path)
    {
        std::cout
            << "[FILE] "
            << std::string(depth * 2, ' ')
            << commit(opt, path)
            << '\n';
    }

    void view_result(
        const options& opt, 
        const size_t depth,
        const std::string& path, 
        const std::string& dsc)
    {
        std::cout
            << "[FILE] "
            << std::string(depth * 2, ' ')
            << commit(opt, path)
            << ' ' << dsc 
            << '\n';
    }


    list_t find_all_targets(const options& opt)
    {
        list_t result;

        fsystem::settings params =
        {
            std::move(opt.scan_include ),
            std::move(opt.scan_exclude ),
            std::move(opt.dirs_include ),
            std::move(opt.dirs_exclude ),
            std::move(opt.files_include),
            std::move(opt.files_exclude)
        };

        const auto call = [&opt, &result](
            const bool is_directory, 
            const std::string& path, 
            const size_t depth)
        {
            assert(is_directory);
            (void)is_directory;

            result.emplace_back(path);
            if (opt.debug)
            {
                std::cout << "[" << depth << "]";
                std::cout << "[DIR]  " << std::string(depth * 2, ' ') << path << '\n';
                return true;
            }
            return true;
        };

        for (const auto& dir : opt.dirs_start)
        {
            const bool exist = fs::is_directory(dir);
            if (!exist)
            {
                if (opt.debug)
                    std::cout << "skip(not directory): '" << dir << "'\n";
                continue;
            }
            if (opt.debug)
                std::cout << "find in: '" << dir << "'\n";
            fsystem::find_in(dir, params, call);
        }
        if (opt.debug && result.empty())
            std::cout << " -- not found\n";

        return result;
    }

    using map_t = std::map<tools::build_version, str_t>;


    bool checkSymptoms(const fs::path& d, const list_t& symptoms)
    {
        return fsystem::exists(d, symptoms);

#if 0
        if (symptoms.empty())
            return true;

        list_t s = symptoms;
        for (const fs::path& cur : fs::directory_iterator(d))
        {
            const auto name = cur.filename().generic_string();
            for (auto i = s.cbegin(), e = s.cend(); i != e; ++i)
            {
                const auto& symptom = *i;
                if (tools::match_pattern(name, symptom))
                {
                    s.erase(i);
                    if (s.empty())
                        return true;
                    break;
                }
            }
        }
        return false;
#endif
    }

    void create_map(const options& opt, const list_t& paths, map_t& versionned, str_t& unversionned)
    {
        for (const auto& d : paths)
        {
            assert(fs::is_directory(d));

            const auto name_target = fs::path(d).filename();

            bool has_versions = false;
            assert(fs::is_directory(d));
            for (const fs::path& cur : fs::directory_iterator(d))
            {
                if (!fs::is_directory(cur))
                    continue;

                auto ver = cur.filename().generic_string();
                if (tools::match_pattern(ver, "ver-*"))
                {
                    ver.erase(0, 4);
                    const auto found = versionned.find(ver);
                    if (found != versionned.cend())
                        continue;

                    const auto check = cur / name_target;
                    const auto& x = fs::is_directory(check) ?
                        check : cur;

                    if (!checkSymptoms(x, opt.symptoms))
                        continue;

                    has_versions = true;
                    versionned[ver] = x.generic_string();
                }
            }
            if (!has_versions)
            {
                if (unversionned.empty()) 
                {
                    if(checkSymptoms(d, opt.symptoms))
                        unversionned = d;
                }
            }
        }
    }

    void fromUnversonned(const options& opt, const str_t& unversionned)
    {
        if (unversionned.empty())
        {
            if (opt.debug)
                std::cout << "\n[result]\n  not found\n";
        }
        else
        {
            if (opt.debug)
                std::cout << "\n[result]\n  " << unversionned << "\n";
            else
                std::cout << unversionned << '\n';
        }
    }

    bool strictVersion(const options& opt, const map_t& versionned)
    {
        if (opt.versions.empty())
            return false;

        const auto& strict = opt.versions.front();
        const auto found = versionned.find(strict);
        if (found == versionned.cend())
        {
            if (opt.debug)
                std::cout << "[strict-version]\n"
                    << "  version: '" << strict << "' not found\n";
        }
        else
        {
            const auto result = found->second;
            if (opt.debug)
                std::cout << "\n[result]\n  " << result << '\n';
            else
                std::cout << result << '\n';
        }
        return true;
    }

    void viewMaxVersion(const options& opt, map_t& versionned)
    {
        assert(!versionned.empty());

        if (!opt.min_versions.empty())
        {
            const auto& minimal = opt.min_versions.front();
            const auto itlow = versionned.lower_bound(minimal);
            versionned.erase(versionned.cbegin(), itlow);
        }

        if (!opt.max_versions.empty())
        {
            const auto& maximal = opt.max_versions.front();
            const auto itup = versionned.upper_bound(maximal);
            versionned.erase(itup, versionned.cend());
        }

        if (versionned.empty())
        {
            if(opt.debug)
                std::cout << "\n[min-max range]\n  not found";
            return;
        }

        const auto& last = versionned.crbegin();
        const auto result = last->second;
        if (opt.debug)
        {
            std::cout << "\n[min-max range]\n";
            for (const auto& v : versionned)
                std::cout << "  " << v.first << ": " << v.second << '\n';

            std::cout << "\n[result]\n  " << result << '\n';
        }
        else
            std::cout << result << '\n';
    }

    void run(const options& opt)
    {
        if (opt.debug)
            std::cout << "\n[find all target`s directories] ...\n";

        const list_t paths = find_all_targets(opt);
        if (paths.empty())
        {
            if (opt.debug)
                std::cout << "\ntargets not found\n";
            return;
        }

        //---------------------------

        if (opt.debug)
            std::cout << "\n[check versions] ...\n";

        map_t versionned;
        str_t unversionned;
        create_map(opt, paths, versionned, unversionned);

        if (opt.debug)
        {
            if (!unversionned.empty())
                std::cout << "unversionned:\n  " << unversionned << '\n';

            if (!versionned.empty())
            {
                std::cout << "versionned:\n";
                for (const auto& v : versionned)
                    std::cout << "  " << v.first << ": " << v.second << '\n';
            }
        }

        //---------------------------

        if (versionned.empty())
        {
            fromUnversonned(opt, unversionned);
            return;
        }

        if (strictVersion(opt, versionned))
            return;

        viewMaxVersion(opt, versionned);
    }

} // namespace cmd


