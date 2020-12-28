
#pragma once
#ifndef dTOOLS_REPLACE_USED_
#define dTOOLS_REPLACE_USED_ 1
//==============================================================================
//==============================================================================

namespace tools
{
    template<class s>
    void replace_all(s& src_txt, const s& old_txt, const s& new_txt)
    {
        size_t index = 0;
        while (true)
        {
            index = src_txt.find(old_txt, index);
            if (index == s::npos)
                break;
            src_txt.replace(index, old_txt.size(), new_txt);
            index += new_txt.size();
        }
    }

} // namespace tools

//==============================================================================
//==============================================================================

#endif // !dTOOLS_REPLACE_USED_

