
#include "cmd.hpp"

#include <iostream>
#include <cstring>
#include <cassert>

#include "tools/find_in.hpp"
#include <tools/fsystem.hpp>
#include "tools/strncomp.hpp"
#include "tools/tokenizer.hpp"
#include "tools/pattern.hpp"
#include "tools/trim.hpp"
#include "tools/env.hpp"

#include <iostream>

using str_t = std::string;
using list_t = std::list<str_t>;

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

    inline list_t split(const char* src, const size_t len)
    {
        assert(src);
        assert(len <= std::strlen(src));

        list_t result;
        const auto word = [&result](const char* text, const size_t len)
        {
            str_t tmp(text, len);
            tools::trim(tmp);
            if (!tmp.empty())
                result.emplace_back(std::move(tmp));
        };
        const auto punct = [](const char) {};
        const auto& sep = ";";
        tools::tokenize(src, src + len, 
            std::begin(sep), std::end(sep), word, punct);
        return result;
    }

    inline list_t split(const char* src)
    {
        assert(src);
        return cmd::split(src, std::strlen(src));
    }

    inline list_t split(const str_t& src)
    {
        return cmd::split(src.c_str(), src.length());
    }

    static void expand(list_t& collect)
    {
        for (auto i = collect.begin(), e = collect.end(); i != e; )
        {
            auto exp = tools::env::expand(*i);
            if (exp.empty())
                i = collect.erase(i);
            else
                *i = std::move(exp), 
                ++i;
        }

        list_t exp;
        for (auto& el : collect)
        {
            auto add = cmd::split(el);
            exp.insert(exp.end(), add.begin(), add.end());
        }
        collect = std::move(exp);
    }

} // namespace cmd

//==============================================================================
//==============================================================================

namespace cmd
{
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

            if (tools::strncmp_nocase(arg + x, "start:", 6) == 0)
                dst.dirs_start = cmd::split(arg + x + 6);

            if (tools::strncmp_nocase(arg + x, "mask:", 5) == 0)
                dst.dirs_mask = cmd::split(arg + x + 5);

            else if (tools::strncmp_nocase(arg + x, "s:", 2) == 0)
                dst.scan_include = cmd::split(arg + x + 2);

            else if (tools::strncmp_nocase(arg + x, "es:", 3) == 0)
                dst.scan_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "d:", 2) == 0)
                dst.dirs_include = cmd::split(arg + x + 2);

            else if(tools::strncmp_nocase(arg + x, "ed:", 3) == 0)
                dst.dirs_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "f:", 2) == 0)
                dst.files_include = cmd::split(arg + x + 2);

            else if(tools::strncmp_nocase(arg + x, "ef:", 3) == 0)
                dst.files_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "debug", 5) == 0)
                dst.debug = true;

            else if (tools::strncmp_nocase(arg + x, "test", 4) == 0)
                dst.test = true;

        next:
            void();
        }
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
    }

    void options::view_syntaxis()
    {
        const char* msg
            = R"raw(syntaxis:

garbage 
    "--start: dirs-where-search"    [required] 
    "--mask: masks-dir-or-files"    [optional]
    "--S: dirs-masks-include"       [optional]
    "--ES: dirs-masks-exclude"      [optional]
    "--D: dirs-masks-include"       [optional]
    "--ED: dirs-masks-exclude"      [optional]
    "--F: files-masks-include"      [optional]
    "--EF: files-masks-exclude"     [optional]
    "--debug"                       [optional]
    "--test"                        [optional]
)raw";
        std::cout << msg << "\n";
    }

    options::options(int argc, char** argv)
        : test()
        , debug()
        , dirs_start   ()
        , scan_include ()
        , scan_exclude ()
        , dirs_include ()
        , dirs_exclude ()
        , files_include()
        , files_exclude()
    {
        cmd::setCommandOptions(argc, argv, *this);
        cmd::commit(this->dirs_start);
        this->applyParams();
    }

    void options::applyParams()
    {
        cmd::expand(this->dirs_mask    );
        cmd::expand(this->scan_include );
        cmd::expand(this->scan_exclude );
        cmd::expand(this->dirs_include );
        cmd::expand(this->dirs_exclude );
        cmd::expand(this->files_include);
        cmd::expand(this->files_exclude);

        cmd::expand(this->dirs_start);

        auto& dirs = this->dirs_start;
        if (dirs.empty())
        {
            dirs.emplace_back(fs::current_path().generic_string());
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
    }

} // namespace cmd

//==============================================================================
//==============================================================================

namespace cmd
{
    void run(const options& opt)
    {
        fsystem::settings params =
        {
            std::move(opt.scan_include ),
            std::move(opt.scan_exclude ),
            std::move(opt.dirs_include ),
            std::move(opt.dirs_exclude ),
            std::move(opt.files_include),
            std::move(opt.files_exclude)
        };

        if (!opt.dirs_mask.empty())
        {
            params.dirs_include.assign(
                opt.dirs_mask.cbegin(), 
                opt.dirs_mask.cend()
            );

            params.files_include.assign(
                opt.dirs_mask.cbegin(), 
                opt.dirs_mask.cend()
            );
        }

        bool found = false;
        const bool test  = opt.test;
        const bool debug = opt.debug;

        const auto call = [&found, test, debug](
            const bool is_directory, 
            const std::string& path, 
            const size_t depth)
        {
            found = true;

            if (debug || test)
            {
                std::cout << "[" << depth << "]";
                if (is_directory)
                    std::cout << "[DIR] ";
                else
                    std::cout << "[FILE]";
                std::cout << std::string(depth * 2, ' ');
                std::cout << ' ' << path << '\n';
            }
            if(!test)
                fsystem::remove_all(path);

            return true;
        };

        if(debug)
            std::cout << "started...\n";

        for (const auto& dir : opt.dirs_start)
            fsystem::find_in(dir, params, call);

        if (debug && !found)
            std::cout << " -- not found\n";
    }

} // namespace cmd
