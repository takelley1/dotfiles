function fish_prompt --description 'Write out the prompt'
    set -l normal (set_color normal)

    # reinitialize the prompt if the user has changed the colors
    if not set -q -g __fish_classic_git_functions_defined
        set -g __fish_classic_git_functions_defined
        function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
            if status --is-interactive
                commandline -f repaint 2>/dev/null
            end
        end
        function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
            if status --is-interactive
                commandline -f repaint 2>/dev/null
            end
        end
        function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
            if status --is-interactive
                commandline -f repaint 2>/dev/null
            end
        end
        function __fish_repaint_bind_mode --on-variable fish_key_bindings --description "Event handler; repaint when fish_key_bindings changes"
            if status --is-interactive
                commandline -f repaint 2>/dev/null
            end
        end
        if not set -q __fish_classic_git_prompt_initialized
            set -qU fish_color_user
            or set -U fish_color_user -o green
            set -qU fish_color_host
            or set -U fish_color_host -o cyan
            set -qU fish_color_status
            or set -U fish_color_status red
            set -U __fish_classic_git_prompt_initialized
        end
    end

    set -l color_cwd
    set -l prefix
    set -l suffix

    # set colors depending on the user
    switch "$USER"
        # root gets red colors
        case root toor admin
            echo -n -s (set_color ff0000) "$USER" $normal @ (set_color ff0000) (prompt_hostname) $normal ':' (set_color 729fcf) (pwd) $normal (__fish_vcs_prompt) $normal "# "
        # everyone else gets green colors
        case '*'
            echo -n -s (set_color 8ae234) "$USER" $normal @ (set_color 8ae234) (prompt_hostname) $normal ':' (set_color 729fcf) (pwd) $normal (__fish_vcs_prompt) $normal "> "
    end

end
