#!/usr/bin/env fish

# Color functions using direct ANSI escape codes for wide compatibility
function color_reset
    printf '\033[0m'
end

function color_header
    printf '\033[1;36m'
end

function color_success
    printf '\033[32m'
end

function color_error
    printf '\033[31m'
end

function color_warning
    printf '\033[33m'
end

function color_info
    printf '\033[34m'
end

function color_file
    printf '\033[35m'
end

function sync_files
    argparse 's/src-dir=' 'd/dst-dir=' -- $argv
    or return 1
    
    set src_dir $_flag_src_dir
    set dst_dir $_flag_dst_dir
    
    printf '%s󰈿 Syncing from %s to %s%s\n' (color_header) $src_dir $dst_dir (color_reset)
    
    for file in $src_dir/*
        set src_path $file
        set dst_path $dst_dir/(basename $file)
        
        if test -d $src_path
            mkdir -p $dst_path
            sync_files --src-dir=$src_path --dst-dir=$dst_path
        else
                printf '%s  󰈿 Copying %s%s → %s%s%s\n' (color_info) (color_file) $src_path (color_info) $dst_path (color_reset)
            cp -r $src_path $dst_path
        end
    end
end

function main
    printf '%s󰈿 Starting AquaMoon Config Sync%s\n' (color_header) (color_reset)
    printf '%s═══════════════════════════════════════════%s\n' (color_header) (color_reset)
    printf '\n'
    
    set home $HOME
    set aquamoon_dir $home/.aquamoon
    set config_dir $home/.config
    
    if not test -d $aquamoon_dir
        printf '%s❌ Error: .aquamoon directory not found%s\n' (color_error) (color_reset)
        exit 1
    end
    
    if not test -d $config_dir
        printf '%s⚠️  Creating .config directory%s\n' (color_warning) (color_reset)
        mkdir -p $config_dir
    end
    
    # Define mappings: source relative to aquamoon, destination relative to config
    set mappings river river etc/cliq.toml cliq/cliq.toml etc/television.toml television/config.toml etc/gitu.toml gitu/config.toml nvim nvim
    
    printf '%s󰈿 Processing config mappings:%s\n' (color_header) (color_reset)
    printf '\n'
    
    set etc_processed false
    
    for i in (seq 1 2 (count $mappings))
        set src_rel $mappings[$i]
        set dst_rel $mappings[(math $i + 1)]
        
        set src_path $aquamoon_dir/$src_rel
        set dst_path $config_dir/$dst_rel
        
        if test -e $src_path
            # Add header for etc directory files
            if string match -q "etc/*" $src_rel; and test $etc_processed = false
                printf '%s󰈿 Syncing from %s/etc to %s/.config:%s\n' (color_header) $aquamoon_dir $home (color_reset)
                set etc_processed true
            end
            
            set dst_parent (dirname $dst_path)
            mkdir -p $dst_parent
            
            if test -d $src_path
                sync_files --src-dir=$src_path --dst-dir=$dst_path
            else
                printf '%s  󰈿 Copying %s%s → %s%s%s\n' (color_info) (color_file) $src_path (color_info) $dst_path (color_reset)
                cp -r $src_path $dst_path
            end
        else
            printf '%s  ⚠️  Warning: Source path not found: %s%s%s\n' (color_warning) (color_file) $src_path (color_reset)
        end
    end
    
    printf '\n'
    printf '%s═══════════════════════════════════════════%s\n' (color_header) (color_reset)
    printf '%s✅ Sync completed successfully!%s\n' (color_success) (color_reset)
end

main