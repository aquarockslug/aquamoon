# Aqua Arch

### SHELL: ZSH
 - Navigate files with *lf*.
   - Pressing "e" opens nvim in a pane to the right
 - Manage git repositories with *lazygit*.
 - Write notes and save snippets with *nap*.
 - Write shell scripts with *gum*.

### TERMINAL: ZELLIJ
 - Minimal appearence using the *zjstatus* plugin.

### TEXT: NEOVIM
 - I use many of the *mini.nvim* packages.
 - Language servers are downloaded and managed by *mason*.
 - Completions are done with *blink.cmp*

### COLOR THEME: DRACULA
 - I use the *dracula* color scheme whenever possible.

### STARTUP
                Neovim startup times (total: 24.473ms)
┏━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━┓
┃ File             ┃ Perc   ┃ Min     ┃ Average ┃ Max     ┃ Stdev    ┃
┡━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━━┩
│ init.lua         │ 12.98% │   2.742 │   3.178 │   5.161 │ 7.14e-01 │
│ dracula.lua      │  4.14% │   0.897 │   1.013 │   1.441 │ 1.58e-01 │
│ matchit.vim      │  1.97% │   0.375 │   0.482 │   1.281 │ 2.82e-01 │
│ syntax.vim       │  1.42% │   0.173 │   0.348 │   1.866 │ 5.33e-01 │
│ netrwPlugin.vim  │  1.40% │   0.267 │   0.342 │   0.807 │ 1.68e-01 │
│ filetype.lua     │  1.05% │   0.139 │   0.257 │   1.226 │ 3.41e-01 │
│ rplugin.vim      │  0.88% │   0.175 │   0.216 │   0.463 │ 8.78e-02 │
│ matchit.vim      │  0.86% │   0.168 │   0.209 │   0.518 │ 1.09e-01 │
│ gzip.vim         │  0.77% │   0.136 │   0.188 │   0.575 │ 1.36e-01 │
│ synload.vim      │  0.70% │   0.067 │   0.172 │   1.090 │ 3.23e-01 │
│ matchparen.vim   │  0.67% │   0.119 │   0.164 │   0.539 │ 1.32e-01 │
│ zipPlugin.vim    │  0.60% │   0.123 │   0.147 │   0.334 │ 6.61e-02 │
│ ftplugin.vim     │  0.43% │   0.040 │   0.104 │   0.620 │ 1.81e-01 │
│ editorconfig.lua │  0.42% │   0.055 │   0.102 │   0.372 │ 9.76e-02 │
│ tarPlugin.vim    │  0.40% │   0.076 │   0.099 │   0.270 │ 6.04e-02 │
│ osc52.lua        │  0.40% │   0.034 │   0.098 │   0.319 │ 8.83e-02 │
│ man.lua          │  0.38% │   0.048 │   0.093 │   0.392 │ 1.06e-01 │
│ tohtml.lua       │  0.37% │   0.033 │   0.091 │   0.228 │ 6.76e-02 │
│ indent.vim       │  0.36% │   0.027 │   0.088 │   0.622 │ 1.88e-01 │
│ shada.vim        │  0.31% │   0.050 │   0.076 │   0.280 │ 7.18e-02 │
│ spellfile.vim    │  0.16% │   0.017 │   0.040 │   0.235 │ 6.86e-02 │
│ tutor.vim        │  0.15% │   0.015 │   0.037 │   0.226 │ 6.63e-02 │
└──────────────────┴────────┴─────────┴─────────┴─────────┴──────────┘

                Clean Neovim startup times (total: 10.193ms)
┏━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━━┓
┃ File             ┃ Perc   ┃ Min     ┃ Average ┃ Max     ┃ Stdev    ┃
┡━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━╇━━━━━━━━━━┩
│ init.lua         │ 13.44% │   0.959 │   1.370 │   3.152 │ 6.62e-01 │
│ matchit.vim      │  3.37% │   0.267 │   0.344 │   0.851 │ 1.80e-01 │
│ netrwPlugin.vim  │  2.99% │   0.260 │   0.305 │   0.597 │ 1.03e-01 │
│ syntax.vim       │  2.21% │   0.163 │   0.225 │   0.720 │ 1.74e-01 │
│ matchit.vim      │  2.08% │   0.168 │   0.212 │   0.515 │ 1.07e-01 │
│ gzip.vim         │  1.80% │   0.151 │   0.183 │   0.411 │ 8.13e-02 │
│ filetype.lua     │  1.58% │   0.128 │   0.161 │   0.414 │ 8.89e-02 │
│ matchparen.vim   │  1.49% │   0.120 │   0.152 │   0.398 │ 8.68e-02 │
│ zipPlugin.vim    │  1.46% │   0.120 │   0.149 │   0.259 │ 4.98e-02 │
│ man.lua          │  1.38% │   0.048 │   0.141 │   0.404 │ 1.04e-01 │
│ synload.vim      │  1.09% │   0.069 │   0.111 │   0.341 │ 9.14e-02 │
│ editorconfig.lua │  0.98% │   0.055 │   0.099 │   0.331 │ 8.34e-02 │
│ tarPlugin.vim    │  0.90% │   0.077 │   0.092 │   0.194 │ 3.64e-02 │
│ osc52.lua        │  0.82% │   0.035 │   0.083 │   0.266 │ 6.86e-02 │
│ ftplugin.vim     │  0.75% │   0.041 │   0.077 │   0.362 │ 1.00e-01 │
│ tohtml.lua       │  0.67% │   0.032 │   0.068 │   0.170 │ 4.17e-02 │
│ shada.vim        │  0.64% │   0.050 │   0.065 │   0.173 │ 3.83e-02 │
│ rplugin.vim      │  0.54% │   0.042 │   0.056 │   0.169 │ 3.99e-02 │
│ indent.vim       │  0.50% │   0.027 │   0.051 │   0.258 │ 7.28e-02 │
│ spellfile.vim    │  0.31% │   0.017 │   0.032 │   0.158 │ 4.44e-02 │
│ tutor.vim        │  0.29% │   0.015 │   0.029 │   0.139 │ 3.86e-02 │
└──────────────────┴────────┴─────────┴─────────┴─────────┴──────────┘
