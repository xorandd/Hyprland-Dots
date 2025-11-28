# meh. Dark Blood Rewind, a new beginning.

PROMPT=$'%{$fg[white]%}┌[%{$fg_bold[white]%}%n%{$reset_color%}%{$fg[white]%}@%{$fg_bold[white]%}%m%{$reset_color%}%{$fg[white]%}] [%{$fg_bold[white]%}/dev/%y%{$reset_color%}%{$fg[white]%}] %{$(git_prompt_info)%}%(?,,%{$fg[white]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[white]%}])
%{$fg[white]%}└[%{$fg_bold[white]%}%~%{$reset_color%}%{$fg[white]%}]>%{$reset_color%} '
PS2=$' %{$fg[white]%}|>%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}[%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[white]%}] "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[white]%}⚡%{$reset_color%}"
