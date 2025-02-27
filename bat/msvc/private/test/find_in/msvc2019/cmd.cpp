
// --- workspace/scripts/bat/msvc                                      [cmd.cpp]
// reconstruct:
//   [2024-12m-24][09:09:00] 005 Kartonagnick    
//   [2024-04m-02][00:15:59] 004 Kartonagnick    
// reconstruct:
//   [2024-02m-09][02:58:33] 003 Kartonagnick    
//   [2023-06m-01][01:54:31] 002 Kartonagnick    
//   [2022-08m-05][05:59:37] 001 Kartonagnick    

//==============================================================================
//==============================================================================

#include "cmd.hpp"

#include "tools/find_in.hpp"
#include <tools/fsystem.hpp>
#include "tools/strncomp.hpp"
#include "tools/tokenizer.hpp"
#include "tools/pattern.hpp"
#include "tools/bitexe.hpp"
#include "tools/trim.hpp"
#include "tools/env.hpp"

#include <iostream>
#include <cstring>
#include <cassert>

//==============================================================================
//=== [split/commit] ===========================================================

namespace cmd
{
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

} // namespace cmd

//==============================================================================
//=== checkQuotes/viewArguments ================================================

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

    void showArguments(const int argi, char* argv[]) noexcept
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

    int invalidSyntaxis()
    {
        std::cerr << "invalid syntaxis\n";
        return EXIT_FAILURE;
    }
    
    bool needShowHelpInfo(char* argv[])
    {
        assert(argv);
        if(cmd::options::checkHelp(argv[1]))
        {
            cmd::options::viewSyntaxis();
            return true;
        }
        else if (cmd::options::checkVersion(argv[1]))
        {
            std::cout << cmd::options::version() << '\n';
            return true;
        }
        return false;
    }
    
    bool checkArgument(int argc, char* argv[])
    {
        for (int i = 0; i != argc; ++i)
            if (!cmd::checkQuotes(argv[i]))
            {
                cmd::showArguments(argc, argv);
                std::cerr << '\n';
                std::cerr << "[ERROR] invalid 'pair quote'\n";
                std::cerr << "[ERROR] " << i << ") " << argv[i] << std::endl;
                return false;
            }
        return true;
    }

} // namespace cmd

//==============================================================================
//=== [options] ================================================================

namespace cmd
{
    options::options(int argc, char** argv)
        : debug         ()
        , once          ()
        , dir_once      ()
        , dirnames      ()
        , regexp        ()
        , match_mode    ()
        , case_sensitive()
        , sorted        ()
        , exe           ()
        , dirs_start    ()
        , dirs_mask     ()
        , scan_include  ()
        , scan_exclude  ()
        , dirs_include  ()
        , dirs_exclude  ()
        , files_include ()
        , files_exclude ()
    {
        assert(argc > 1);
        this->parseCommands(static_cast<size_t>(argc), argv);
        this->applyParams();
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

    void options::parseCommands(size_t argc, const char* const* const argv)
    {
        assert(argc > 1);
        if (argc < 2)
        {
            const str_t n = std::to_string(argc);
            throw std::logic_error(
                "options::parseCommands(argc = " + n + "): must be >1"
            );
        }

        for(size_t i = 1; i != argc; ++i)
        {
            const char* arg = argv[i];
            if(!arg)
                continue;

            size_t x = 0;
            while (arg[x] == ' ')
                ++x;
            while (arg[x] == '-')
                ++x;

            if (arg[x] == 0)
                continue;

            if (tools::strncmp_nocase(arg + x, "start:", 6) == 0)
                this->dirs_start = cmd::split(arg + x + 6);

            if (tools::strncmp_nocase(arg + x, "mask:", 5) == 0)
                this->dirs_mask = cmd::split(arg + x + 5);

            else if (tools::strncmp_nocase(arg + x, "s:", 2) == 0)
                this->scan_include = cmd::split(arg + x + 2);

            else if (tools::strncmp_nocase(arg + x, "es:", 3) == 0)
                this->scan_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "d:", 2) == 0)
                this->dirs_include = cmd::split(arg + x + 2);

            else if(tools::strncmp_nocase(arg + x, "ed:", 3) == 0)
                this->dirs_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "f:", 2) == 0)
                this->files_include = cmd::split(arg + x + 2);

            else if(tools::strncmp_nocase(arg + x, "ef:", 3) == 0)
                this->files_exclude = cmd::split(arg + x + 3);

            else if(tools::strncmp_nocase(arg + x, "debug", 5) == 0)
                this->debug = true;

            else if (tools::strncmp_nocase(arg + x, "once", 4) == 0)
                this->once = true;

            else if (tools::strncmp_nocase(arg + x, "dir_once", 8) == 0)
                this->dir_once = true;

            else if (tools::strncmp_nocase(arg + x, "exe32", 5) == 0)
                this->exe = 1;

            else if (tools::strncmp_nocase(arg + x, "exe64", 5) == 0)
                this->exe = 2;

            else if (tools::strncmp_nocase(arg + x, "dirnames", 8) == 0)
                this->dirnames = true;

            else if (tools::strncmp_nocase(arg + x, "regexp", 6) == 0)
                this->regexp = true;

            else if (tools::strncmp_nocase(arg + x, "ci", 2) == 0)
                this->case_sensitive = true;

            else if (tools::strncmp_nocase(arg + x, "match", 5) == 0)
                this->match_mode = true;

            else if (tools::strncmp_nocase(arg + x, "case_sensitive", 14) == 0)
                this->case_sensitive = true;

            else if (tools::strncmp_nocase(arg + x, "sort", 4) == 0)
                this->sorted = true;
        }
    }

    bool options::checkCommand(const char* arg, const char* cmd) noexcept
    {
        assert(arg);
        assert(cmd);
        assert(cmd[0] != 0);

        size_t i = 0;
        while (arg[i] == ' ')
            ++i;
        while (arg[i] == '-')
            ++i;

        if (arg[i] == 0)
            return false;

        const char* text = arg + i;

        if (tools::strncmp_nocase(text, cmd) == 0)
            return true;
        return false;
    }

    bool options::checkVersion(const char* arg) noexcept
    {
        const bool success =
            cmd::options::checkCommand(arg, "v")   ||
            cmd::options::checkCommand(arg, "ver") ||
            cmd::options::checkCommand(arg, "version");
        return success;
    }

    bool options::checkHelp(const char* arg) noexcept
    {
        const bool success =
            cmd::options::checkCommand(arg, "h") ||
            cmd::options::checkCommand(arg, "help");
        return success;
    }

    void options::viewSyntaxis()
    {
        const char* msg
            = R"raw(syntaxis:
  find_in 
    "--start: dirs-where-search"    [required] by default: %CD%
    "--mask: masks-dir-or-files"    [optional] common part of -S and -D keys
    "--S: dirs-masks-include"       [optional] what directories need to be scanned
    "--ES: dirs-masks-exclude"      [optional] which directories should be excluded from scanning
    "--D: dirs-masks-include"       [optional] what directories need to be found
    "--ED: dirs-masks-exclude"      [optional] which directories should be excluded from the search
    "--F: files-masks-include"      [optional] what files need to be found
    "--EF: files-masks-exclude"     [optional] which files should be excluded from the search
    "--once"                        [optional] stop immediately upon successful detection
    "--dir_once"                    [optional] do not scan the directory if target were found in it
    "--dirnames"                    [optional] show filename only
    "--exe32"                       [optional] 32 bit executable only
    "--exe64"                       [optional] 64 bit executable only
    "--regexp"                      [optional] use regular expression
    "--sorted"                      [optional] need sorted directories and files
    "--match"                       [optional] check start directories only
    "--case_sensitive"              [optional] use case sensitive (by default case insensitive)
    "--debug"                       [optional] debug mode
)raw";
        std::cout << msg << "\n";
    }

} // namespace cmd

//==============================================================================
//=== [run] ====================================================================

namespace cmd
{
    inline str_t commit(const options& opt, const str_t& path)
    {
        return opt.dirnames ?
            fs::path(path).parent_path().generic_string() :
            path;
    }

    void viewResult(const options& opt, const size_t depth, const str_t& path)
    {
        std::cout
            << "[FILE] "
            << str_t(depth * 2, ' ')
            << cmd::commit(opt, path)
            << '\n';
    }

    void viewResult(const options& opt, const size_t depth, const str_t& path, const str_t& dsc)
    {
        std::cout
            << "[FILE] "
            << str_t(depth * 2, ' ')
            << cmd::commit(opt, path)
            << ' ' << dsc  << '\n';
    }

    void run(const options& opt)
    {
        using x = fsystem::eFIND_RESPONCE;

        bool found = false;
        const auto call = [&found, &opt](const bool is_directory, const str_t& path, const size_t depth)
        {
            if (opt.debug)
            {
                std::cout << "[" << depth << "]";

                if (is_directory)
                    std::cout << "[DIR]  " << str_t(depth * 2, ' ') << path << '\n';
                else
                {
                    if (opt.exe == 0)
                        cmd::viewResult(opt, depth, path);
                    else if (opt.exe == 1)
                    {
                        const auto info = fsystem::check_bit_model(path);
                        if (info == fsystem::eBIT_32_ELF || info == fsystem::eBIT_32_WIN)
                            cmd::viewResult(opt, depth, path);
                        else
                        {
                            cmd::viewResult(opt, depth, path, "[SKIP-64]");
                            return x::eFIND_CONTINUE;
                        }
                    }
                    else if (opt.exe == 2)
                    {
                        const auto info = fsystem::check_bit_model(path);
                        if (info == fsystem::eBIT_64_ELF || info == fsystem::eBIT_64_WIN)
                            cmd::viewResult(opt, depth, path);
                        else
                        {
                            cmd::viewResult(opt, depth, path, "[SKIP-32]");
                            return x::eFIND_CONTINUE;
                        }
                    }
                }
                found = true;
                return opt.once ? x::eFIND_DONE : 
                    opt.dir_once ? 
                        x::eFIND_SKIP_DIR: x::eFIND_CONTINUE;
            }

            if (is_directory)
                std::cout << path << '\n';
            else
            {
                if (opt.exe == 0)
                    std::cout << cmd::commit(opt, path) << '\n';
                else if (opt.exe == 1)
                {
                    const auto info = fsystem::check_bit_model(path);
                    if (info == fsystem::eBIT_32_ELF || info == fsystem::eBIT_32_WIN)
                        std::cout << cmd::commit(opt, path) << '\n';
                    else
                        return x::eFIND_CONTINUE;
                }
                else if (opt.exe == 2)
                {
                    const auto info = fsystem::check_bit_model(path);
                    if (info == fsystem::eBIT_64_ELF || info == fsystem::eBIT_64_WIN)
                        std::cout << cmd::commit(opt, path) << '\n';
                    else
                        return x::eFIND_CONTINUE;
                }
            }
            found = true;
            return opt.once ? x::eFIND_DONE : 
                opt.dir_once && is_directory ? 
                    x::eFIND_SKIP_DIR: x::eFIND_CONTINUE;
        };

        fsystem::settings params =
        {
            std::move(opt.scan_include ),
            std::move(opt.scan_exclude ),
            std::move(opt.dirs_include ),
            std::move(opt.dirs_exclude ),
            std::move(opt.files_include),
            std::move(opt.files_exclude),
            opt.case_sensitive,
            opt.dir_once,
            opt.regexp,
            opt.sorted,
            call
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

        for (const auto& dir : opt.dirs_start)
        {
            if (opt.debug)
                std::cout << "find in: " << dir << '\n';

            if (opt.match_mode)
            {
                if(fsystem::dir_match(dir, params) && opt.once)
                    return;
            }
            else
            {
                fsystem::find_in(dir, params);
                if (opt.once && found)
                    return;
            }
        }

        if (opt.debug && !found)
            std::cout << " -- not found\n";
    }

} // namespace cmd
