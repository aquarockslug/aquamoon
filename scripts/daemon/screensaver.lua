-- Screensaver for Aquamoon
-- Switches to hidden tag and launches weather display

os.execute("riverctl set-focused-tags 128 && riverctl spawn 'neovide term://weathr'")
