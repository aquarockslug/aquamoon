#!/usr/bin/env fish

function sync_files
    argparse 's/src-dir=' 'd/dst-dir=' -- $argv
    or return 1

    set src_dir $_flag_src_dir
    set dst_dir $_flag_dst_dir

    echo "Syncing from $src_dir to $dst_dir"

    for file in $src_dir/*
        set src_path $file
        set dst_path $dst_dir/(basename $file)

        if test -d $src_path
            mkdir -p $dst_path
            sync_files --src-dir=$src_path --dst-dir=$dst_path
        else
            echo "Copying $src_path -> $dst_path"
            cp -r $src_path $dst_path
        end
    end
end

function main
    set home $HOME
    set aquamoon_dir $home/.aquamoon
    set config_dir $home/.config

    if not test -d $aquamoon_dir
        echo "Error: .aquamoon directory not found"
        exit 1
    end

    if not test -d $config_dir
        echo "Creating .config directory"
        mkdir -p $config_dir
    end

    # Define mappings: source relative to aquamoon, destination relative to config
    set mappings river river etc/cliq.toml cliq/cliq.toml nvim nvim

    for i in (seq 1 2 (count $mappings))
        set src_rel $mappings[$i]
        set dst_rel $mappings[(math $i + 1)]

        set src_path $aquamoon_dir/$src_rel
        set dst_path $config_dir/$dst_rel

        if test -e $src_path
            set dst_parent (dirname $dst_path)
            mkdir -p $dst_parent

            if test -d $src_path
                sync_files --src-dir=$src_path --dst-dir=$dst_path
            else
                echo "Copying $src_path -> $dst_path"
                cp -r $src_path $dst_path
            end
        else
            echo "Warning: Source path not found: $src_path"
        end
    end

    echo "Sync completed successfully!"
end

main
